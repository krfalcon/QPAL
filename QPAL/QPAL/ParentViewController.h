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
#import "NavigationView.h"


@interface ParentViewController : UIViewController<QPViewControllerDelegate,NavigationViewDelegate,GuestViewControllerDelegate,WeChatLoginViewControllerDelegate>
{
    NavigationView          *navi;
    
    TempletView             *viewControllerContainer;
    NSMutableArray          *viewControllerArray;
    
    UIViewController        *currentViewController;
    UIViewController        *nextViewController;

}


@end

