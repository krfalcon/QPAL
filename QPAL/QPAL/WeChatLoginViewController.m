 //
//  WeChatLoginViewController.m
//  QPAL
//
//  Created by KDC on 5/13/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "WeChatLoginViewController.h"


@implementation WeChatLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityHUD = [CCActivityHUD new];
    
    [self.view setFrame:super.view.bounds];
    
    //IMYWebView *webView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 68, self.view.frame.size.width, self.view.frame.size.height - 68)];
    //IMYWebView *webView = [[IMYWebView alloc] init];
    UIWebView *wb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView = wb;
    _webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:WXAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:[NSString stringWithFormat:@"UserToken=%@",_userToken] forHTTPHeaderField:@"Cookie"];
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
    if (_delegate && [_delegate respondsToSelector:@selector(weChatViewUpdateTitle:andUrl:)]) {
        [_delegate weChatViewUpdateTitle:title andUrl:url ];
    }
}
/*
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"网络异常！请检查网络连接状况！"];
}*/

@end
