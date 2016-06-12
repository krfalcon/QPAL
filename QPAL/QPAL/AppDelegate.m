//
//  AppDelegate.m
//  QPAL
//
//  Created by ZhuYiqun on 5/10/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong, nonatomic) ParentViewController*      currentController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //向微信注册
    [WXApi registerApp:WXPatient_App_ID withDescription:@"bbb"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    _currentController = [[ParentViewController alloc] init];
    [self.window setRootViewController: _currentController];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)onResp:(BaseResp *)resp {
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        if (temp.code) {
        
        NSError *error;
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXPatient_App_ID, WXPatient_App_Secret, temp.code];
        NSURL *url = [NSURL URLWithString:accessUrlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        //NSLog(@"%@", resDic);
        NSString *accessToken = [resDic objectForKey:@"access_token"];
        NSString *unionID = [resDic objectForKey:@"unionid"];
        
        NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
        [defalts setObject:unionID forKey:@"unionid"];
        [defalts setObject:accessToken forKey:@"access_token"];
        
        [defalts synchronize];
        
        [self getUserTokenWithUnionID:unionID];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"微信授权失败！"];
        }
        
    }
}

- (void)getUserTokenWithUnionID:(NSString *)string {
    NSError *error;
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@%@", WXAPI, string];
    NSURL *url = [NSURL URLWithString:accessUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@", resDic);
    //NSString *userToken = [[resDic objectForKey:@"c"] objectForKey:@"Token"];
    if (resDic[@"c"] != [NSNull null]) {
        NSString *userToken = [NSString stringWithFormat:@"%@",resDic[@"c"][@"Token"]];
        
        NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
        [defalts setObject:userToken forKey:@"userToken"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserToken" object:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败"
                                                        message:@"请关注第一八佰伴微信公众号后登陆"
                                                       delegate:self
                                               cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil, nil];
        [alert show];
        NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
        [defalts removeObjectForKey:@"access_token"];
        [defalts removeObjectForKey:@"unionid"];
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
