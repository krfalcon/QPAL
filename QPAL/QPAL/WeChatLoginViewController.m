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
    
    [self.view setFrame:super.view.bounds];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView = webView;
    _webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:WXAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:[NSString stringWithFormat:@"UserToken=%@",_userToken] forHTTPHeaderField:@"Cookie"];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"网络异常！请检查网络连接状况！"];
}

@end
