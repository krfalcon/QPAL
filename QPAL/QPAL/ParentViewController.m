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
    ZBViewController                *zbViewController;
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [defaults objectForKey:@"userToken"];
    
    if (userToken) {
        [self pushViewControllerWithViewControllerType:ViewControllerTypeWeChat andToken:userToken];
        [viewControllerContainer addSubview:weChatViewController.view];
        
        [weChatViewController.activityHUD show];
        
    }
    else {
        QPViewController *qpViewController = [[QPViewController alloc] init];
        [qpViewController setDelegate:self];
        [viewControllerContainer addSubview:qpViewController.view];
   
        currentViewController = qpViewController;
        
        viewControllerArray = [[NSMutableArray alloc] init];
        [viewControllerArray addObject:currentViewController];
    }
        
}

- (void)getUserToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [defaults objectForKey:@"userToken"];
    
    [self pushViewControllerWithViewControllerType:ViewControllerTypeWeChat andToken:userToken];
}

- (void)pushViewControllerWithViewControllerType:(ViewControllerType)viewControllerType andToken:(NSString *)string
{
    
    navi = [[NavigationView alloc] initWithFrame:self.view.bounds andColor:3 andTitle:@""];
    [navi setDelegate:self];
    [self.view addSubview:navi];
    
    switch (viewControllerType) {
        case ViewControllerTypeGuest:
        {
            zbViewController = [[ZBViewController alloc] init];
            //[zbViewController setDelegate:self];
            
            [navi createNextNavigationBarWithColor:ThemeBlack andTitle:@"" andIsIndex:NO];
            
            nextViewController = zbViewController;
            
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
                         //[navi changeNavigationBarAddArray];
                         //currentViewController.view.userInteractionEnabled = NO;
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
        /*else {
            [navi removeFromSuperview];
            
            [self popViewController];
            }*/
    
}

- (void)popViewController {
    if (!nextViewController) {
        nextViewController = [viewControllerArray objectAtIndex:(viewControllerArray.count - 2)];
    }
    if (!navi.hasNew) {
        [navi createBeforeNavigationBar];
    }

    
    [UIView animateWithDuration:0.f
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
    //TencentOAuth *_tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105514703" andDelegate:self];
    
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
    
    ZYShareItem *item3 = [ZYShareItem itemWithTitle:@"退出登录"
                                               icon:@"Action_LogOut"
                                            handler:^{ [weakSelf WXActionLogOut]; }];
    ZYShareItem *item4 = [ZYShareItem itemWithTitle:@"分享到QQ"
                                               icon:@"Action_QQ"
                                            handler:^{ [weakSelf WXActionQQ]; }];
    ZYShareItem *item5 = [ZYShareItem itemWithTitle:@"分享到Qzone"
                                               icon:@"Action_qzone"
                                            handler:^{ [weakSelf WXActionQzone]; }];
    ZYShareItem *item6 = [ZYShareItem itemWithTitle:@"分享到微博"
                                               icon:@"Action_Weibo"
                                            handler:^{ [weakSelf WXActionWeibo]; }];
    
    
    // 创建shareView
    ZYShareView *shareView = [ZYShareView shareViewWithShareItems:@[item0, item1, item2,item4, item5,item6]
                                                    functionItems:@[item3]];
    // 弹出shareView
    [shareView show];
}

- (void)WXActionShare{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"消费总动员，让购物轻松无忧";
    message.description = @"网罗全上海精彩互动活动，带你尽享上海全方位消费体验！";
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
    message.title = @"消费总动员，让购物轻松无忧";
    message.description = @"网罗全上海精彩互动活动，带你尽享上海全方位消费体验！";
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
    message.title = @"消费总动员，让购物轻松无忧";
    message.description = @"网罗全上海精彩互动活动，带你尽享上海全方位消费体验！";
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

- (void)WXActionQQ{
    NSString *utf8String = navi.url;
    NSString *title = @"消费总动员，让购物轻松无忧";
    NSString *description = @"网罗全上海精彩互动活动，带你尽享上海全方位消费体验！";
    NSString *previewImageUrl = @"http://sw.dgshare.cn/content/images/icon.png";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    //将内容分享到qzone
    //QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
}

- (void)WXActionQzone{
    NSString *utf8String = navi.url;
    NSString *title = @"消费总动员，让购物轻松无忧";
    NSString *description = @"网罗全上海精彩互动活动，带你尽享上海全方位消费体验！";
    NSString *previewImageUrl = @"http://sw.dgshare.cn/content/images/icon.png";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

- (void)WXActionWeibo{

    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"ViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    //分享文字和图片   多媒体文件和图片不能同时分享
    WBMessageObject *message = [WBMessageObject message];
    //
    //    message.text = NSLocalizedString(@"www.baidu.com", nil);
    //    WBImageObject *image = [WBImageObject object];
    //    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123456" ofType:@"jpg"]];
    //    message.imageObject = image;
    
    //分享多媒体文件
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = @"消费总动员，让购物轻松无忧";
    webpage.description = @"网罗全上海精彩互动活动，带你尽享上海全方位消费体验！";
    UIImage *MyImage = [UIImage imageNamed:@"ShareIcon"];
    
    webpage.thumbnailData = UIImagePNGRepresentation(MyImage);
    webpage.webpageUrl = navi.url;
    message.mediaObject = webpage;
    return message;

}

- (void)WXActionLogOut{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[weChatViewController.webView removeFromSuperview];
    //viewControllerContainer = nil;
    
    //[navi removeFromSuperview];
    
    [self viewDidLoad];
}

- (void)showTipViewWithMessage:(NSNotification *)notification {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[notification object] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


@end
