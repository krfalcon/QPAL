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
    /*
     NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
     [cookieProperties setObject:@"UserToken" forKey:NSHTTPCookieName];
     [cookieProperties setObject:@"e3ebc8d2-0f06-44a8-b6de-4bcffe404d5e" forKey:NSHTTPCookieValue];
     [cookieProperties setValue:@"http://qpal.dgshare.cn/crm/getToken" forKey:NSHTTPCookieDomain];
     [cookieProperties setValue:@"/" forKey:NSHTTPCookiePath];
     
     [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
     
     NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
     
     NSHTTPCookie *cookiee;
     NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
     for (cookiee in [cookieJar cookies]) {
     NSLog(@"%@:%@", cookiee.name, cookiee.value);
     }*/
    
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
