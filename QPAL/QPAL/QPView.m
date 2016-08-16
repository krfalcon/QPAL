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
    
    UIButton *securityButton = [[UIButton alloc] initWithFrame:CGRectMake(228 * self.scale, 459 / 2 * self.scale, 245 / 2 * self.scale, 56.5 * self.scale)];
    [securityButton setTag:2];
    [securityButton setExclusiveTouch:YES];
    [securityButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [indexView addSubview:securityButton];
    
    UIButton *guestButton = [[UIButton alloc] initWithFrame:CGRectMake(22.5 * self.scale, 331 * self.scale, 659/2 * self.scale, 54 * self.scale)];
    [guestButton setTag:3];
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
        [weChatButton setTag:0];
        [weChatButton setExclusiveTouch:YES];
        [weChatButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [indexView addSubview:weChatButton];
        
        /*
        UIImageView *weChatLogin = [[UIImageView alloc] initWithFrame:weChatButton.bounds];
        [weChatLogin setImage:[UIImage imageNamed:@"btn-weixin"]];
        [weChatButton addSubview:weChatLogin];*/
    }
    
    UIButton *qqButton = [[UIButton alloc] initWithFrame:CGRectMake(113 * self.scale, 497 * self.scale, 50 * self.scale, 50 * self.scale)];
    [qqButton setTag:0];
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
            NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";//总况
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
            if ([regextestmobile evaluateWithObject:phoneTextField.text] == NO)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"请输入正确的手机号！"];
                return;
            }
            NSError *error;
            NSString *accessUrlStr = [NSString stringWithFormat:@"http://sw.dgshare.cn/Crm/GetVerificationCode?mobilePhone=%@",phoneTextField.text];
            NSURL *url = [NSURL URLWithString:accessUrlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            //NSLog(@"%@", resDic);
            
            if ([resDic[@"Status"] intValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"发送成功！"];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"发送失败，请稍后再尝试"];
            }
            
            break;
        }
        case 3:
        {
            if (securityCodeTextField.text.length == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"请输入验证码！"];
                return;
            }
            
            NSError *error;
            NSString *accessUrlStr = [NSString stringWithFormat:@"http://sw.dgshare.cn/Crm/CustomerLogin?mobilePhone=%@&code=%@",phoneTextField.text,securityCodeTextField.text];
            NSURL *url = [NSURL URLWithString:accessUrlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@", resDic);
            
            if ([resDic[@"Status"] intValue] == 1) {
                NSString *userToken = [NSString stringWithFormat:@"%@",resDic[@"Customer"][@"Token"]];
                NSLog(@"%@",userToken);
                NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
                [defalts setObject:userToken forKey:@"userToken"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserToken" object:nil];
                }
            
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"登陆失败,请重试！"];
            }
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
