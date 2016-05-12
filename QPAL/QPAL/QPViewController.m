//
//  IndexViewController.m
//  QPAL
//
//  Created by KDC on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "QPViewController.h"

@interface QPViewController ()

@end

@implementation QPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    qpView = [[QPView alloc] initWithFrame:self.view.bounds];
    [qpView setDelegate:self];
    [self.view addSubview:qpView];
}

- (void)guestLogin {
    if (_delegate && [_delegate respondsToSelector:@selector(pushViewControllerWithViewControllerType:)]) {
        [_delegate pushViewControllerWithViewControllerType:ViewControllerTypeGuest];
    }}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
