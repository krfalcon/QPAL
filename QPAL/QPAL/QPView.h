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
#import "WsAddrHelper.h"
#import <TencentOpenAPI/TencentOAuth.h>

@protocol QPViewDelegate;

@interface QPView : TempletView <UITextFieldDelegate,TencentSessionDelegate>
{
    UITextField*            phoneTextField;
    UITextField*            securityCodeTextField;
    
    UIButton*               endTextingButton;
}

@property (strong, nonatomic) id<QPViewDelegate>     delegate;
@property (strong, nonatomic) TencentOAuth           *tencentOAuth;

@end

@protocol QPViewDelegate <NSObject>

- (void)guestLogin;
- (void)QQLogin;

@end
