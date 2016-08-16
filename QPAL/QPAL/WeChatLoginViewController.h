//
//  WeChatLoginViewController.h
//  QPAL
//
//  Created by KDC on 5/13/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WsAddrHelper.h"
#import "CCActivityHUD.h"
#import "IMYWebView.h"



@protocol WeChatLoginViewControllerDelegate;

@interface WeChatLoginViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString*     userToken;
@property (strong, nonatomic) UIWebView*    webView;
@property (weak, nonatomic)  id<WeChatLoginViewControllerDelegate>      delegate;

@property (strong, nonatomic) CCActivityHUD *activityHUD;

@end

@protocol WeChatLoginViewControllerDelegate <NSObject>

- (void)weChatViewUpdateTitle:(NSString*)title andUrl:(NSString*)url;

@end
