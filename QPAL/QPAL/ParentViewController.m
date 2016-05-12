//
//  ParentViewController.m
//  QPAL
//
//  Created by ZhuYiqun on 5/10/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewControllerContainer = [[TempletView alloc] initWithFrame:self.view.bounds];
    [viewControllerContainer setBackgroundColor:AbsoluteWhite];
    [viewControllerContainer setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:viewControllerContainer];
    
    navi = [[NavigationView alloc] initWithFrame:self.view.bounds andColor:1 andTitle:@"登陆"];
    [self.view addSubview:navi];
    
    QPViewController *qpViewController = [[QPViewController alloc] init];
    [qpViewController setDelegate:self];
    [viewControllerContainer addSubview:qpViewController.view];
    
    currentViewController = qpViewController;
}

- (void)pushViewControllerWithViewControllerType:(ViewControllerType)viewControllerType
{
    switch (viewControllerType) {
        case ViewControllerTypeGuest:
        {
            GuestViewController *guestViewController = [[GuestViewController alloc] init];
            
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"微官网" andIsIndex:NO];
            
            nextViewController = guestViewController;
            
            break;
        }
            
        default:
            break;
    }
    
    [viewControllerContainer addSubview:nextViewController.view];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
