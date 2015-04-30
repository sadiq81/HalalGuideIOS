//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGMessagesViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "DateTools.h"
#import "HGMessage.h"
#import "Masonry.h"
#import "HGMessageCell.h"
#import "HGMessageComposeView.h"
#import "IQKeyboardManager.h"

@interface HGMessagesViewController () <UITableViewDelegate, UITableViewDataSource>

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

    [self.viewModel refreshSubjects];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self setupViews];
    [self setupTableView];
    [self setupViewModel];
    [self updateViewConstraints];

}

- (void)setupViews {

    self.messages = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.messages];

    self.composeView = [[HGMessageComposeView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.composeView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;

    [self.composeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];

    [UIView animateWithDuration:duration delay:0 options:(animationCurve | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        [self.view layoutIfNeeded];
    }                completion:NULL];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    CGRect kbFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [self.composeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kbFrame.size.height);
    }];

    [UIView animateWithDuration:duration delay:0 options:(animationCurve | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        [self.view layoutIfNeeded];
    }                completion:NULL];
}

- (void)setupViewModel {

    [[RACObserve(self.viewModel, messages) ignore:nil] subscribeNext:^(id x) {
        [self.messages reloadData];
    }];
}

static NSString *cellIdentifier = @"сellIdentifier";

- (void)setupTableView {
    self.messages.delegate = self;
    self.messages.dataSource = self;

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
    CGRect rect = [message.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    return 35 + rect.size.height + 10;
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
        make.height.equalTo(@(43));
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

@end