//
// Created by Privat on 27/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ENumberViewController.h"
#import "HGENumber.h"

@interface ENumberViewController () <UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation ENumberViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
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
}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *websiteUrl = [NSURL URLWithString:@"http://www.alahazrat.net/islam/e-numbers-listing-halal-o-haram-ingredients.php"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];

}

- (void)webViewDidStartLoad:(UIWebView *)theWebView {
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"fetching", nil)];

}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    [SVProgressHUD dismiss];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


@end