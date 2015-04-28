//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import "HGSubjectsChatViewController.h"
#import "Masonry.h"
#import "HGSubjectsViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HGSubject.h"
#import "DateTools.h"
#import "HGMessagesChatViewController.h"


@interface HGSubjectsChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *subjects;
@property(strong, nonatomic) HGSubjectsViewModel *viewModel;

@end

@implementation HGSubjectsChatViewController {

}

- (instancetype)initWithViewModel:(HGSubjectsViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
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


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGSubjectsChatViewController.button.close", nil) style:UIBarButtonItemStylePlain block:^(id weakSender) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HGChatViewController.button.new.subject"] style:UIBarButtonItemStylePlain block:^(id weakSender) {

    }];

    [self setupViews];
    [self setupTableView];
    [self setupViewModel];
    [self updateViewConstraints];

}

- (void)setupViews {

    self.subjects = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.subjects];

}

- (void)setupViewModel {

    [[RACObserve(self.viewModel, subjects) ignore:nil] subscribeNext:^(id x) {
        [self.subjects reloadData];
    }];
}

static NSString *cellIdentifier = @"сellIdentifier";

- (void)setupTableView {
    self.subjects.delegate = self;
    self.subjects.dataSource = self;

    //[self.subjects registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

    self.subjects.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
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
    cell.textLabel.text =subject.title;

    if (subject.count.intValue > 1){
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"HGSubjectsChatViewController.cell.detail.text.label.multiple", nil),subject.count,subject.lastMessage.timeAgoSinceNow];
    } else{
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"HGSubjectsChatViewController.cell.detail.text.label.single", nil),subject.count,subject.lastMessage.timeAgoSinceNow];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HGMessagesChatViewController *vc = [[HGMessagesChatViewController alloc] initWithViewModel:[[HGMessagesViewModel alloc] initWithSubject:self.viewModel.subjects[indexPath.row]]];
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