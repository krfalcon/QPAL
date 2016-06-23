//
//  MapView.h
//  QPAL
//
//  Created by KDC on 6/23/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"

@interface MapView : TempletView
{
    UIView*             locationView;
    UIImageView*        mapImageView;
}

- (void)getMap;

@end
