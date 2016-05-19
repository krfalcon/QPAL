//
//  WeChatLoginViewController.h
//  QPAL
//
//  Created by KDC on 5/13/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WsAddrHelper.h"


@protocol WeChatLoginViewControllerDelegate;

@interface WeChatLoginViewController : UIViewController

@property (strong, nonatomic) NSString*     userToken;
@property (strong, nonatomic) UIWebView*    webView;
@property (weak, nonatomic)  id<WeChatLoginViewControllerDelegate>      delegate;

@end

@protocol WeChatLoginViewControllerDelegate <NSObject>

- (void)weChatViewUpdateTitle:(NSString*)title andUrl:(NSString*)url;

@end
