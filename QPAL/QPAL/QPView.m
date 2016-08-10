//
//  IndexView.m
//  QPAL
//
//  Created by KDC on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "QPView.h"

@implementation QPView

- (void)initView
{
    UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:indexView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:indexView.bounds];
    [imageView setImage:[UIImage imageNamed:@"bg"]];
    [indexView addSubview:imageView];
    
    UIButton *guestButton = [[UIButton alloc] initWithFrame:CGRectMake(22.5 * self.scale, 331 * self.scale, 659/2 * self.scale, 54 * self.scale)];
    [guestButton setTag:0];
    [guestButton setExclusiveTouch:YES];
    [guestButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [indexView addSubview:guestButton];
    
    endTextingButton = [[UIButton alloc] initWithFrame:self.bounds];
    [endTextingButton setEnabled:NO];
    [endTextingButton setExclusiveTouch:YES];
    [endTextingButton addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endTextingButton];
    
    phoneTextField = [[UITextField alloc ] initWithFrame:CGRectMake(45 * self.scale, 193 * self.scale, 200 * self.scale, 35 * self.scale)];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [phoneTextField setAttributedPlaceholder:str];
    [phoneTextField setFont:[UIFont systemFontOfSize:18 * self.scale]];
    [phoneTextField setDelegate:self];
    [phoneTextField setReturnKeyType:UIReturnKeyDone];
    [phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [phoneTextField setTextColor:[UIColor whiteColor]];
    [indexView addSubview: phoneTextField];
    
    securityCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(45 * self.scale, 250 * self.scale, 200 * self.scale, 35 * self.scale)];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"请输入6位验证码" attributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [securityCodeTextField setAttributedPlaceholder:str2];
    [securityCodeTextField setFont:[UIFont systemFontOfSize:18 * self.scale]];
    [securityCodeTextField setDelegate:self];
    [securityCodeTextField setReturnKeyType:UIReturnKeyDone];
    [securityCodeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [securityCodeTextField setTextColor:[UIColor whiteColor]];
    [indexView addSubview: securityCodeTextField];
    /*
    UIImageView *guestLogin = [[UIImageView alloc] initWithFrame:guestButton.bounds];
    [guestLogin setImage:[UIImage imageNamed:@"btn-youke"]];
    [guestButton addSubview:guestLogin];
    */
    
    if ([WXApi isWXAppInstalled])
    {
        UIButton *weChatButton = [[UIButton alloc] initWithFrame:CGRectMake(27 * self.scale, 497 * self.scale, 50 * self.scale, 50 * self.scale)];
        [weChatButton setTag:1];
        [weChatButton setExclusiveTouch:YES];
        [weChatButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [indexView addSubview:weChatButton];
        
        /*
        UIImageView *weChatLogin = [[UIImageView alloc] initWithFrame:weChatButton.bounds];
        [weChatLogin setImage:[UIImage imageNamed:@"btn-weixin"]];
        [weChatButton addSubview:weChatLogin];*/
    }
    
    UIButton *qqButton = [[UIButton alloc] initWithFrame:CGRectMake(113 * self.scale, 497 * self.scale, 50 * self.scale, 50 * self.scale)];
    [qqButton setTag:2];
    [qqButton setExclusiveTouch:YES];
    [qqButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [indexView addSubview:qqButton];
}

#pragma mark - Button Events

- (void)tappedButton:(UIButton*)button
{
    switch (button.tag) {
        case 0:
        {
            /*if (_delegate && [_delegate respondsToSelector:@selector(guestLogin)]) {
                [_delegate guestLogin];
            }*/
            [_delegate guestLogin];
            break;
        }
        
        case 1:
        {
            NSString *acessToken =  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            NSString *unionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"unionid"];
            if (acessToken && unionID) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserToken" object:nil];
            } else {
                [self wechatLogin];
            }
            break;
        }
            
        case 2:
        {
            
            [self wechatLogin];
            
            break;
        }
        default:
            break;
    }
}

- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
}

- (void)QQLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [phoneTextField resignFirstResponder];
    [securityCodeTextField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [endTextingButton setEnabled:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [endTextingButton setEnabled:NO];
}

@end
