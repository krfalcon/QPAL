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
    NSURL *url = [NSURL URLWithString:@"http://qpal.dgshare.cn"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:[NSString stringWithFormat:@"UserToken=e3ebc8d2-0f06-44a8-b6de-4bcffe404d5e"] forHTTPHeaderField:@"Cookie"];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

@end
