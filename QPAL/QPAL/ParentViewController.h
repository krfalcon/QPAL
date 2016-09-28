//
//  ParentViewController.h
//  QPAL
//
//  Created by ZhuYiqun on 5/10/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "NavigationView.h"
#import "TempletView.h"

#import "QPViewController.h"
#import "GuestViewController.h"
#import "WeChatLoginViewController.h"
#import "MapViewController.h"
#import "ZBViewController.h"

#import "NavigationView.h"
#import "ZYShareView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WeiboSDK.h"

#import "CCActivityHUD.h"


@interface ParentViewController : UIViewController<QPViewControllerDelegate,NavigationViewDelegate,GuestViewControllerDelegate,WeChatLoginViewControllerDelegate,TencentSessionDelegate,WeiboSDKDelegate>
{
    NavigationView          *navi;
    
    TempletView             *viewControllerContainer;
    NSMutableArray          *viewControllerArray;
    
    UIViewController        *currentViewController;
    UIViewController        *nextViewController;

}

@property (strong, nonatomic) CCActivityHUD *activityHUD;


@end

