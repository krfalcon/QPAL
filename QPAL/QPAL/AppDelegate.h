//
//  AppDelegate.h
//  QPAL
//
//  Created by ZhuYiqun on 5/10/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"

#import "WsAddrHelper.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,TencentSessionDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) TencentOAuth           *tencentOAuth;


@end

