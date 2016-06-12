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
    UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [self addSubview:indexView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:indexView.bounds];
    [imageView setImage:[UIImage imageNamed:@"bbb"]];
    [indexView addSubview:imageView];
    
    UIButton *guestButton = [[UIButton alloc] initWithFrame:CGRectMake(67.5 * self.scale, 400 * self.scale, 240 * self.scale, 40 * self.scale)];
    [guestButton setTag:0];
    [guestButton setExclusiveTouch:YES];
    [guestButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [indexView addSubview:guestButton];
    
    UIImageView *guestLogin = [[UIImageView alloc] initWithFrame:guestButton.bounds];
    [guestLogin setImage:[UIImage imageNamed:@"btn-youke"]];
    [guestButton addSubview:guestLogin];
    
    
    if ([WXApi isWXAppInstalled])
    {
        UIButton *weChatButton = [[UIButton alloc] initWithFrame:CGRectMake(67.5 * self.scale, 470 *    self.scale, 240 * self.scale, 40 * self.scale)];
        [weChatButton setTag:1];
        [weChatButton setExclusiveTouch:YES];
        [weChatButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        [indexView addSubview:weChatButton];
    
        UIImageView *weChatLogin = [[UIImageView alloc] initWithFrame:weChatButton.bounds];
        [weChatLogin setImage:[UIImage imageNamed:@"btn-weixin"]];
        [weChatButton addSubview:weChatLogin];
    }
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

@end
