//
//  TempletView.h
//  QPAL
//
//  Created by KDC on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenHelper.h"
#import "EnumHelper.h"


@interface TempletView : UIView
{
    UIActivityIndicatorView*                            activityIndicatorView;
}

@property (assign, nonatomic) CGFloat                   titleHeight;
@property (assign, nonatomic) CGFloat                   scale;

- (void)initView;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
