//
//  ZBView.m
//  QPAL
//
//  Created by KDC on 28/09/2016.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "ZBView.h"

@implementation ZBView

- (void)initView {
    UIScrollView *zbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 72 * self.scale, self.frame.size.width, self.frame.size.height)];
    [zbScrollView setContentSize:CGSizeMake(zbScrollView.frame.size.width, 2402 / 2 * self.scale + 72 * self.scale)];
    [zbScrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:zbScrollView];
    
    UIImageView *zbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2402 / 2 * self.scale )];
    [zbImageView setImage:[UIImage imageNamed:@"zb"]];
    [zbScrollView addSubview:zbImageView];
}

@end
