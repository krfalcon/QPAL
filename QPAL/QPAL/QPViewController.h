//
//  IndexViewController.h
//  QPAL
//
//  Created by KDC on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QPView.h"

@protocol  QPViewControllerDelegate;

@interface QPViewController : UIViewController<QPViewDelegate>
{
    QPView   *qpView;
}

@property(nonatomic,weak) id<QPViewControllerDelegate>      delegate;

@end

@protocol  QPViewControllerDelegate <NSObject>

- (void)pushViewControllerWithViewControllerType:(ViewControllerType)viewControllerType;

@end
