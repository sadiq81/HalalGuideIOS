//
// Created by Privat on 27/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "ENumberViewController.h"
#import "TFHpple.h"
#import "ENumber.h"


@implementation ENumberViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *websiteUrl = [NSURL URLWithString:@"http://www.alahazrat.net/islam/e-numbers-listing-halal-o-haram-ingredients.php"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];

}
- (void)webViewDidStartLoad:(UIWebView *)theWebView{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeBlack];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    [SVProgressHUD dismiss];
}


@end