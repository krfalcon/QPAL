//
//  ZBViewController.m
//  QPAL
//
//  Created by KDC on 28/09/2016.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "ZBViewController.h"

@interface ZBViewController ()

@end

@implementation ZBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZBView *zbView = [[ZBView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:zbView];
}

@end
