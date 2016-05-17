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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserToken) name:@"getUserToken" object:nil];
    
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

- (void)GuestViewUpdateTitle:(NSString*)title
{
    [navi updateTitle:title];
}

- (void)weChatViewUpdateTitle:(NSString*)title
{
    [navi updateTitle:title];
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
    
}


@end
