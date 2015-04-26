//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import "HGChatViewController.h"
#import "Masonry.h"
#import "HGChatViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HGSubject.h"


@interface HGChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *subjects;
@property(strong, nonatomic) HGChatViewModel *viewModel;

@end

@implementation HGChatViewController {

}

- (instancetype)initWithViewModel:(HGChatViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(HGChatViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.viewModel refreshSubjects];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGChatViewController.button.close", nil) style:UIBarButtonItemStylePlain block:^(id weakSender) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGChatViewController.button.new.subject", nil) style:UIBarButtonItemStylePlain block:^(id weakSender) {

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
    HGSubject *subject = [self.viewModel.subjects objectAtIndex:indexPath.row];
    cell.textLabel.text =subject.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",subject.count,subject.lastMessage];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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