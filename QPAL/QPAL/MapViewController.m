//
//  MapViewController.m
//  QPAL
//
//  Created by KDC on 6/23/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!mapView) {
        mapView = [[MapView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:mapView];
        
        [mapView getMap];
    }
}

@end
