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

@protocol QPViewDelegate;

@interface QPView : TempletView <UITextFieldDelegate>
{
    UITextField*            phoneTextField;
    UITextField*            securityCodeTextField;
    
    UIButton*               endTextingButton;
}

@property (strong, nonatomic) id<QPViewDelegate>     delegate;

@end

@protocol QPViewDelegate <NSObject>

- (void)guestLogin;

@end
