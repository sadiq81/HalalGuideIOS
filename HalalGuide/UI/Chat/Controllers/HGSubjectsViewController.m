//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import "HGSubjectsViewController.h"
#import "Masonry.h"
#import "HGSubjectsViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HGSubject.h"
#import "DateTools.h"
#import "HGMessagesViewController.h"
#import "HGChatService.h"
#import "UIAlertView+Blocks.h"


@interface HGSubjectsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong, nonatomic) UITableView *subjects;
@property(strong, nonatomic) HGSubjectsViewModel *viewModel;

@end

@implementation HGSubjectsViewController {
}

- (instancetype)initWithViewModel:(HGSubjectsViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [self.viewModel refreshSubjects];
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(HGSubjectsViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel refreshSubjects];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"HGChatViewController.title", nil);

    @weakify(self)
    if ([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGSubjectsViewController.button.close", nil) style:UIBarButtonItemStylePlain block:^(id weakSender) {
            @strongify(self)
            [self dismissViewControllerAnimated:true completion:nil];
        }];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HGChatViewController.button.new.subject"] style:UIBarButtonItemStylePlain block:^(id weakSender) {
        @strongify(self)

        UIAlertController *newSubject = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"HGSubjectsViewController.alert.new.subject.title", nil) message:NSLocalizedString(@"HGSubjectsViewController.alert.new.subject.message", nil) preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGSubjectsViewController.alert.new.subject.ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [newSubject dismissViewControllerAnimated:YES completion:nil];
            UITextField *name = newSubject.textFields[0];
            [self.viewModel createSubject:name.text];
        }];
        ok.enabled = false;
        [newSubject addAction:ok];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGSubjectsViewController.alert.new.subject.regret", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [newSubject dismissViewControllerAnimated:YES completion:nil];
        }];
        [newSubject addAction:cancel];

        [newSubject addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"HGSubjectsViewController.alert.new.subject.name.placeholder", nil);
            textField.delegate = self;
            [textField.rac_textSignal subscribeNext:^(NSString *name) {
                ok.enabled = [name length] >= 5;
            }];
        }];
        [self presentViewController:newSubject animated:true completion:nil];
    }];

    [self setupViews];
    [self setupTableView];
    [self setupViewModel];
    [self updateViewConstraints];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return textField.text.length >= 5;
}

- (void)setupViews {

    self.subjects = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.subjects];

}

- (void)setupViewModel {

    @weakify(self)
    [[RACObserve(self.viewModel, subjects) ignore:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.subjects reloadData];
    }];

    [[RACObserve(self.viewModel, subject) ignore:nil] subscribeNext:^(HGSubject *subject) {
        @strongify(self)
        HGMessagesViewModel *model = [[HGMessagesViewModel alloc] initWithSubject:subject];
        HGMessagesViewController *vc = [[HGMessagesViewController alloc] initWithViewModel:model];
        [self.navigationController pushViewController:vc animated:true];
    }];
}

static NSString *cellIdentifier = @"сellIdentifier";

- (void)setupTableView {
    self.subjects.delegate = self;
    self.subjects.dataSource = self;

    //[self.subjects registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

    self.subjects.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.subjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.subjects dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    HGSubject *subject = self.viewModel.subjects[indexPath.row];
    cell.textLabel.text = subject.title;

    if (subject.count.intValue > 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"HGSubjectsViewController.cell.detail.text.label.multiple", nil), subject.count, subject.lastMessage.timeAgoSinceNow];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"HGSubjectsViewController.cell.detail.text.label.single", nil), subject.count, subject.lastMessage.timeAgoSinceNow];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HGSubject *subject = self.viewModel.subjects[indexPath.row];
    HGMessagesViewModel *model = [[HGMessagesViewModel alloc] initWithSubject:subject];
    HGMessagesViewController *vc = [[HGMessagesViewController alloc] initWithViewModel:model];
    [self.navigationController pushViewController:vc animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


- (void)updateViewConstraints {

    [self.subjects mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

@end