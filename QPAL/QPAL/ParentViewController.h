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


@interface ParentViewController : UIViewController<QPViewControllerDelegate>
{
    NavigationView          *navi;
    TempletView             *viewControllerContainer;
    
    UIViewController    *currentViewController;
    UIViewController    *nextViewController;
}


@end

