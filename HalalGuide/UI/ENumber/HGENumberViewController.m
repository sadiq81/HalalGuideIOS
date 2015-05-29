//
// Created by Privat on 27/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGENumberViewController.h"
#import "HGEnumber.h"
#import "HGENumberScraper.h"

@interface HGENumberViewController () <UIWebViewDelegate/*, UITableViewDataSource, UITableViewDelegate*/>
@property(nonatomic, strong) UIWebView *webView;
/*@property(nonatomic, retain) UITableView *enumbers;
@property(nonatomic, retain) NSArray *numbers;*/
@end

@implementation HGENumberViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.numbers = [NSArray new];
        [self setupViews];
        [self updateViewConstraints];
    }

    return self;
}

- (void)setupViews {

    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.scalesPageToFit = true;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];


/*    self.enumbers = [[UITableView alloc] initWithFrame:CGRectZero];
    self.enumbers.delegate = self;
    self.enumbers.dataSource = self;
    self.enumbers.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.enumbers];

    [self.enumbers registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];*/

}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *websiteUrl = [NSURL URLWithString:@"http://www.alahazrat.net/islam/e-numbers-listing-halal-o-haram-ingredients.php"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];


    /*[HGENumberScraper eNumbersOnCompletion:^(NSArray *numbers) {

    }];*/
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView {
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"fetching", nil)];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    [SVProgressHUD dismiss];
}


/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.numbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    HGEnumber *enumber = [self.numbers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", enumber.number, enumber.name];
    cell.detailTextLabel.text = enumber.halalStatus;

    return cell;
}*/


- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    /*[self.enumbers mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];*/
}


@end