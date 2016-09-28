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

    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50 * self.scale, 400 * self.scale, 275 * self.scale, 50 * self.scale)];
    [loginButton setTag:0];
    [loginButton setExclusiveTouch:YES];
    [loginButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [indexView addSubview:loginButton];
    
    UIImageView *loginImageView = [[UIImageView alloc] initWithFrame:loginButton.bounds];
    [loginImageView setImage:[UIImage imageNamed:@"loginButton"]];
    [loginButton addSubview:loginImageView];
    
    if ([WXApi isWXAppInstalled])
    {
    
    UIButton *guestButton = [[UIButton alloc] initWithFrame:CGRectMake(50 * self.scale, 500 * self.scale, 275 * self.scale, 50 * self.scale)];
    [guestButton setTag:1];
    [guestButton setExclusiveTouch:YES];
    [guestButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [indexView addSubview:guestButton];
    
    UIImageView *guestImageView = [[UIImageView alloc] initWithFrame:loginButton.bounds];
    [guestImageView setImage:[UIImage imageNamed:@"guestButton"]];
    [guestButton addSubview:guestImageView];
    }
    
    /*
    if ([WXApi isWXAppInstalled])
    {
        UIButton *weChatButton = [[UIButton alloc] initWithFrame:CGRectMake(27 * self.scale, 567 * self.scale, 50 * self.scale, 50 * self.scale)];
        [weChatButton setTag:1];
        [weChatButton setExclusiveTouch:YES];
        [weChatButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [indexView addSubview:weChatButton];
        
        
        UIImageView *weChatLogin = [[UIImageView alloc] initWithFrame:weChatButton.bounds];
        [weChatLogin setImage:[UIImage imageNamed:@"Button_weixin"]];
        [weChatButton addSubview:weChatLogin];
    }
    
    if ([TencentOAuth iphoneQQInstalled]){
    
    UIButton *qqButton = [[UIButton alloc] initWithFrame:CGRectMake(113 * self.scale, 567 * self.scale, 50 * self.scale, 50 * self.scale)];
    [qqButton setTag:4];
    [qqButton setExclusiveTouch:YES];
    [qqButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [indexView addSubview:qqButton];
    
    UIImageView *qqLogin = [[UIImageView alloc] initWithFrame:qqButton.bounds];
    [qqLogin setImage:[UIImage imageNamed:@"Button_qq"]];
    [qqButton addSubview:qqLogin];
    }
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        UIButton *weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(199 * self.scale, 567 * self.scale, 50 * self.scale, 50 * self.scale)];
        [weiboButton setTag:5];
        [weiboButton setExclusiveTouch:YES];
        [weiboButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [indexView addSubview:weiboButton];
        
        UIImageView *weiboLogin = [[UIImageView alloc] initWithFrame:weiboButton.bounds];
        [weiboLogin setImage:[UIImage imageNamed:@"Button_weibo"]];
        [weiboButton addSubview:weiboLogin];
    }*/
}

#pragma mark - Button Events

- (void)tappedButton:(UIButton*)button
{
    switch (button.tag) {
        case 0:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(guestLogin)]) {
                [_delegate guestLogin];
            }
            //[_delegate guestLogin];
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
        case 4:
        {

            [self QQLogin];
            
            break;
        }
            
        case 5:
        {
            
            [self WeiboLogin];
            
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
    //[_delegate QQLogin];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105514703" andDelegate:self];
    NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    [_tencentOAuth authorize:_permissions inSafari:NO]; //授权
}

- (void)WeiboLogin {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    request.userInfo = @{@"myKey": @"myValue"};
    [WeiboSDK sendRequest:request];
}

#pragma mark - QQ

- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        //NSLog(@"%@",_tencentOAuth.accessToken);
        [_tencentOAuth getUserInfo];
        
    }else {
    }
}

-(void)getUserInfoResponse:(APIResponse *)response {
    NSLog(@"respons:%@",response.jsonResponse);
    NSString *nickName = [response.jsonResponse objectForKey:@"nickname"];
    NSString *headImgUrl = [response.jsonResponse objectForKey:@"figureurl_qq_1"];
    //NSString *code =
    [self QQgetUserTokenWithNickName:nickName HeadImgUrl:headImgUrl Code:nil ];
    //self.name.text = [response.jsonResponse objectForKey:@"nickname"];
}

- (void)QQgetUserTokenWithNickName:(NSString *)nickname
                        HeadImgUrl:(NSString *)headimgurl
                              Code:(NSString *)code {
    NSError *error;
    NSString *accessUrlStr = [NSString stringWithFormat:@"http://sw.dgshare.cn/crm/BindCustomer?Nickname=%@&HeadImgUrl=%@&Code=%@&From=qq", nickname, headimgurl, code];

    accessUrlStr = [accessUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:accessUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

    if (resDic[@"c"] != [NSNull null]) {
        NSString *userToken = [NSString stringWithFormat:@"%@",resDic[@"Customer"][@"Token"]];
        //NSLog(@"%@",userToken);
        NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
        [defalts setObject:userToken forKey:@"userToken"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserToken" object:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"登陆失败"
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil, nil];
        [alert show];
        NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
        [defalts removeObjectForKey:@"access_token"];
        [defalts removeObjectForKey:@"unionid"];
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
