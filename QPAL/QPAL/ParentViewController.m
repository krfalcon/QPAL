//
//  ParentViewController.m
//  QPAL
//
//  Created by ZhuYiqun on 5/10/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

{
    GuestViewController             *guestViewController;
    WeChatLoginViewController       *weChatViewController;
}

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTipViewWithMessage:) name:@"shouldShowTip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserToken) name:@"getUserToken" object:nil];
    
    viewControllerContainer = [[TempletView alloc] initWithFrame:self.view.bounds];
    [viewControllerContainer setBackgroundColor:AbsoluteWhite];
    [viewControllerContainer setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:viewControllerContainer];
    
    navi = [[NavigationView alloc] initWithFrame:self.view.bounds andColor:3 andTitle:@"登陆"];
    [navi setDelegate:self];
    [self.view addSubview:navi];
    
    QPViewController *qpViewController = [[QPViewController alloc] init];
    [qpViewController setDelegate:self];
    [viewControllerContainer addSubview:qpViewController.view];
    
    currentViewController = qpViewController;
    
    viewControllerArray = [[NSMutableArray alloc] init];
    [viewControllerArray addObject:currentViewController];
    
}

- (void)getUserToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [defaults objectForKey:@"userToken"];
    
    [self pushViewControllerWithViewControllerType:ViewControllerTypeWeChat andToken:userToken];
}

- (void)pushViewControllerWithViewControllerType:(ViewControllerType)viewControllerType andToken:(NSString *)string
{
    switch (viewControllerType) {
        case ViewControllerTypeGuest:
        {
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            guestViewController = [[GuestViewController alloc] init];
            [guestViewController setDelegate:self];
            
            [navi createNextNavigationBarWithColor:ThemeBlack andTitle:@"" andIsIndex:NO];
            
            nextViewController = guestViewController;
            
            break;
        }
            
        case ViewControllerTypeWeChat:
        {
            weChatViewController = [[WeChatLoginViewController alloc] init];
            [weChatViewController setDelegate:self];
            
            weChatViewController.userToken = string;
            
            [navi createNextNavigationBarWithColor:ThemeBlack andTitle:@"" andIsIndex:NO];
            
            nextViewController = weChatViewController;
            
            break;
        }
            
        default:
            break;
    }
    
    [viewControllerContainer addSubview:nextViewController.view];
    [viewControllerArray addObject:nextViewController];
    nextViewController.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         currentViewController.view.transform = CGAffineTransformMakeTranslation(-80, 0);
                         nextViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         [navi changeNavigationBarWithRatio:0.f];
                     }
                     completion:^(BOOL finished){
                         [navi changeNavigationBarAddArray];
                         currentViewController.view.userInteractionEnabled = NO;
                         currentViewController = nextViewController;
                         nextViewController = nil;
                         
                     }];
}

- (void)navigationViewDidTapBackButton:(NavigationView *)navigationView {
        if (guestViewController.webView.canGoBack) {
            [guestViewController.webView goBack];
        }  else if (weChatViewController.webView.canGoBack) {
            [weChatViewController.webView goBack];
        }
        else {
                [self popViewController];
                }
    
}

- (void)popViewController {
    if (!nextViewController) {
        nextViewController = [viewControllerArray objectAtIndex:(viewControllerArray.count - 2)];
    }
    if (!navi.hasNew) {
        [navi createBeforeNavigationBar];
    }

    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         currentViewController.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
                         nextViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                         [navi changeNavigationBarWithRatio:0.f];
                     } completion:^(BOOL finished){
                         [currentViewController willMoveToParentViewController:nil];
                         [currentViewController.view removeFromSuperview];
                         [currentViewController removeFromParentViewController];
                         [viewControllerArray removeLastObject];
                         
                         [navi changeNavigationBarDeleteArray];
                         
                         currentViewController = nextViewController;
                         currentViewController.view.userInteractionEnabled = YES;
                         nextViewController = nil;
                         
                         
                     }];
    
}

- (void)GuestViewUpdateTitle:(NSString*)title andUrl:(NSString *)url
{
    [navi updateTitle:title andUrl:url];
}

- (void)weChatViewUpdateTitle:(NSString*)title andUrl:(NSString *)url
{
    [navi updateTitle:title andUrl:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationViewDidTapQRCodeButton:(NavigationView *)navigationView
{
    
}

- (void)navigationViewDidTapMemberButton;
{
    __weak typeof(self) weakSelf = self;
    
    ZYShareItem *item0 = [ZYShareItem itemWithTitle:@"发送给朋友"
                                               icon:@"Action_Share"
                                            handler:^{ [weakSelf WXActionShare]; }];
    
    ZYShareItem *item1 = [ZYShareItem itemWithTitle:@"分享到朋友圈"
                                               icon:@"Action_Moments"
                                            handler:^{ [weakSelf WXActionMoments]; }];
    
    ZYShareItem *item2 = [ZYShareItem itemWithTitle:@"收藏"
                                               icon:@"Action_MyFavAdd"
                                            handler:^{ [weakSelf WXActionMyFavAdd]; }];
    
    
    // 创建shareView
    ZYShareView *shareView = [ZYShareView shareViewWithShareItems:@[item0, item1, item2]
                                                    functionItems:nil];
    // 弹出shareView
    [shareView show];
}

- (void)WXActionShare{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = navi.title;
    message.description = @"百联青浦奥莱官方App";
    [message setThumbImage:[UIImage imageNamed:@"ShareIcon"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = navi.url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)WXActionMoments{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = navi.title;
    message.description = @"百联青浦奥莱官方App";
    [message setThumbImage:[UIImage imageNamed:@"ShareIcon"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = navi.url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)WXActionMyFavAdd{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = navi.title;
    message.description = @"百联青浦奥莱官方App";
    [message setThumbImage:[UIImage imageNamed:@"ShareIcon"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = navi.url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneFavorite;
    
    [WXApi sendReq:req];
}

- (void)showTipViewWithMessage:(NSNotification *)notification {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[notification object] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}




@end
