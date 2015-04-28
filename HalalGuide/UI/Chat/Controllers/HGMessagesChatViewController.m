//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGMessagesChatViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "DateTools.h"
#import "HGMessage.h"
#import "Masonry.h"

@interface HGMessagesChatViewController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *messages;
@property (strong, nonatomic) HGMessagesViewModel *viewModel;

@end

@implementation HGMessagesChatViewController {

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

    //[self.subjects registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

    self.messages.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.messages dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    HGMessage *subject = [self.viewModel.messages objectAtIndex:indexPath.row];
    cell.textLabel.text =subject.text;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


- (void)updateViewConstraints {

    [self.messages mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

@end