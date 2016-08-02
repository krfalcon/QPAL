//
//  GuestViewController.m
//  QPAL
//
//  Created by KDC on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "GuestViewController.h"


@implementation GuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityHUD = [CCActivityHUD new];
    
    [self.view setFrame:super.view.bounds];

    UIWebView *wb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView = wb;
    _webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:WXAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    //[request setValue:[NSString stringWithFormat:@"UserToken=e3ebc8d2-0f06-44a8-b6de-4bcffe404d5e"] forHTTPHeaderField:@"Cookie"];
    [_webView loadRequest:request];
    [self.activityHUD show];
    
    [self.view addSubview:_webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityHUD dismiss];

    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    if (theTitle.length > 10) {
        theTitle = [[theTitle substringToIndex:9] stringByAppendingString:@"…"];
    }
    self.title = theTitle;
    [self updateNavTitle:theTitle andUrl:url];
    //    [self.progressView setProgress:1 animated:NO];
}

- (void)updateNavTitle:(NSString *)title andUrl:(NSString *)url
{
    if (_delegate && [_delegate respondsToSelector:@selector(GuestViewUpdateTitle:andUrl:)]) {
        [_delegate GuestViewUpdateTitle:title andUrl:url ];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"网络异常！请检查网络连接状况！"];
}

@end
