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
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    NSURL *url = [NSURL URLWithString:@"http://qpal.dgshare.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

@end
