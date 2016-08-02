//
//  GuestViewController.h
//  QPAL
//
//  Created by KDC on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WsAddrHelper.h"

#import "CCActivityHUD.h"


@protocol GuestViewControllerDelegate;

@interface GuestViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView*    webView;
@property (weak, nonatomic)  id<GuestViewControllerDelegate>      delegate;

@property (strong, nonatomic) CCActivityHUD *activityHUD;

@end

@protocol GuestViewControllerDelegate <NSObject>

- (void)GuestViewUpdateTitle:(NSString*)title andUrl:(NSString*)url;

@end