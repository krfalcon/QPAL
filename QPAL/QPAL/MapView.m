//
//  MapView.m
//  QPAL
//
//  Created by KDC on 6/23/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "MapView.h"
#import <MapKit/MapKit.h>

@implementation MapView

- (void)getMap
{
    locationView = [[UIView alloc ] initWithFrame:CGRectMake(0, self.titleHeight * self.frame.size.width / 375.f, self.frame.size.width, self.frame.size.height - self.titleHeight * self.frame.size.width / 375.f)];
    [self addSubview:locationView];
    
    mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.titleHeight * self.frame.size.width / 375.f, self.frame.size.width - 20, (self.frame.size.width - 20 ) * 7117/2835)];
    [mapImageView setImage:[UIImage imageNamed:@"Map"]];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [locationView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [locationView addGestureRecognizer:panGestureRecognizer];
    
    [locationView setUserInteractionEnabled:YES];
    [locationView setMultipleTouchEnabled:YES];
    [locationView addSubview:mapImageView];
}

- (void) pinchView:(UIPinchGestureRecognizer*) pinchGestureRecognizer
{
    if ([pinchGestureRecognizer numberOfTouches] < 2) {
        return;
    }
    
    [self adjustAnchorPointForGestureRecognizer:pinchGestureRecognizer];
    
    if ([pinchGestureRecognizer state] == UIGestureRecognizerStateBegan ||[pinchGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        mapImageView.transform = CGAffineTransformScale(mapImageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *) pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView* view = mapImageView;
        CGPoint locationInView = [pinchGestureRecognizer locationInView:view];
        CGPoint locationInSuperView = [pinchGestureRecognizer locationInView:view.superview];
        
        view.layer.anchorPoint = CGPointMake(locationInView.x / view.bounds.size.width, locationInView.y / view.bounds.size.height);
        view.center = locationInSuperView;
        
    }
}


- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = mapImageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end
