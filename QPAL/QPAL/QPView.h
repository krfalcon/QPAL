//
//  IndexView.h
//  QPAL
//
//  Created by KDC on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"
#import "WXApi.h"

@protocol QPViewDelegate;

@interface QPView : TempletView

@property (strong, nonatomic) id<QPViewDelegate>     delegate;

@end

@protocol QPViewDelegate <NSObject>

- (void)guestLogin;

@end
