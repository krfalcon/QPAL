//
//  APITool.h
//  QPAL
//
//  Created by KDC on 5/13/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APITool : NSObject<NSURLConnectionDelegate>

- (void)getAccessToken;

@end
