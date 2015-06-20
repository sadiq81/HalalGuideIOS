//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "HGMessagesViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "DateTools.h"
#import "HGMessage.h"
#import "Masonry.h"
#import "HGMessageCell.h"
#import "HGMessageComposeView.h"
#import "IQKeyboardManager.h"

@interface HGMessagesViewController () <UITableViewDelegate, UITableViewDataSource, HGImagePickerControllerDelegate>

@property(strong, nonatomic) UITableView *messages;
@property(strong, nonatomic) HGMessageComposeView *composeView;
@property(strong, nonatomic) HGMessagesViewModel *viewModel;

@end

@implementation HGMessagesViewController {
}
- (instancetype)initWithViewModel:(HGMessagesViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;

    }
    return self;
}

+ (instancetype)controllerWithViewModel:(HGMessagesViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.viewModel startTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.viewModel.subject.title;

    [self setupViews];
    [self setupTableView];
    [self setupViewModel];
    [self updateViewConstraints];
}

- (void)setupViews {

    UIImage *image = [UIImage imageNamed:self.viewModel.subscribing.boolValue ? @"HGMessagesViewController.notification.on" : @"HGMessagesViewController.notification.off"];
    @weakify(self)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain block:^(id weakSender) {
        @strongify(self)
        [self.viewModel toggleSubscription];
        [SVProgressHUD showInfoWithStatus:self.viewModel.subscribing.boolValue ? NSLocalizedString(@"HGMessagesViewController.notification.on", nil) : NSLocalizedString(@"HGMessagesViewController.notification.off", nil) maskType:SVProgressHUDMaskTypeNone];
        UIImage *notificationImage = [UIImage imageNamed:self.viewModel.subscribing.boolValue ? @"HGMessagesViewController.notification.on" : @"HGMessagesViewController.notification.off"];
        [self.navigationItem.rightBarButtonItem setImage:notificationImage];
    }];

    self.messages = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.messages];

    self.composeView = [[HGMessageComposeView alloc] initWithFrame:CGRectZero andViewModel:self.viewModel];
    [self.view addSubview:self.composeView];

}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;

    [self.composeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];

    [UIView animateWithDuration:duration delay:0 options:(animationCurve | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        [self.view layoutIfNeeded];
    }                completion:NULL];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    CGRect kbFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [self.composeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kbFrame.size.height);
    }];

    [UIView animateWithDuration:duration delay:0 options:(animationCurve | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        [self.view layoutIfNeeded];
    }                completion:^(BOOL finished) {
        [self scrollToBottom:true];
    }];
}

- (void)setupViewModel {

    [self.viewModel refreshSubjects];

    @weakify(self)
    [[[RACObserve(self.viewModel, sentMessage) ignore:nil] deliverOnMainThread] subscribeNext:^(HGMessage *message) {
        @strongify(self)
        NSIndexPath *newMessage = [NSIndexPath indexPathForRow:[self.viewModel.messages count] - 1 inSection:0];
        NSArray *indexArray = @[newMessage];
        [self.messages beginUpdates];
        [self.messages insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
        [self.messages endUpdates];
        [self scrollToBottom:true];
    }];

    [[[RACObserve(self.viewModel, receivedMessages) ignore:nil] deliverOnMainThread] subscribeNext:^(NSArray *messages) {
        @strongify(self)
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < [messages count]; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:([self.viewModel.messages count] - [messages count] + i) inSection:0];
            [indexPaths addObject:path];
        }
        [self.messages beginUpdates];
        [self.messages insertRowsAtIndexPaths:indexPaths withRowAnimation:([self.viewModel.messages count] - [messages count] == 0) ? UITableViewRowAnimationNone : UITableViewRowAnimationBottom];
        [self.messages endUpdates];
        [self scrollToBottom:([self.viewModel.messages count] - [messages count] == 0) == 0 ? false : true];
    }];

    [self.composeView.mediaChooser handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        @strongify(self)
        [self getPictures:1 viewModel:self.viewModel WithDelegate:self];
    }];

}

- (void)HGImagePickerControllerDidCancel:(HGImagePickerController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

- (void)HGImagePickerControllerDidConfirm:(HGImagePickerController *)controller pictures:(NSArray *)pictures {
    [controller dismissViewControllerAnimated:true completion:^{
        UIImage *image = pictures[0];
        [self.viewModel sendImage:image];
    }];
}


- (void)scrollToBottom:(BOOL)animated {
    int count = (int) [self.viewModel.messages count];
    if (count > 0) {
        [self.messages scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

static NSString *cellIdentifier = @"сellIdentifier";

- (void)setupTableView {
    self.messages.delegate = self;
    self.messages.dataSource = self;

    self.messages.allowsSelection = false;
    self.messages.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.messages registerClass:[HGMessageCell class] forCellReuseIdentifier:cellIdentifier];

    self.messages.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HGMessageCell *cell = [self.messages dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.viewModel = [self.viewModel viewModelForMessage:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGMessage *message = (HGMessage *) self.viewModel.messages[indexPath.row];;
    if (message.image){
        return [UIScreen mainScreen].bounds.size.width - 60;
    } else{
        CGRect rect = [message.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
        return 35 + rect.size.height + 20;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


- (void)updateViewConstraints {

    [self.messages mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.composeView.mas_top);
    }];

    [self.composeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@44).with.priorityMedium();
    }];

    [super updateViewConstraints];
}

@end