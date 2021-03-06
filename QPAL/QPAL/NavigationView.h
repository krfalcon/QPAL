//
//  NavigationView.h
//  QPAL
//
//  Created by ZhuYiqun on 5/12/16.
//  Copyright © 2016 ZhuYiqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationViewDelegate;

@interface NavigationView : UIView
{
    UINavigationBar*        navigationBar;
    UINavigationBar*        navigationBarNew;
    
    
    NSMutableArray*         navigationBarArray;
}
@property (weak, nonatomic)     id<NavigationViewDelegate>      delegate;
@property (assign, nonatomic)   int                             color;
@property (assign, nonatomic)   BOOL                            hasNew;
@property (strong, nonatomic) UINavigationItem                  *navigationItem;
@property (strong, nonatomic)  NSString                         *title;
@property (strong, nonatomic)  NSString                         *url;


- (id)initWithFrame:(CGRect)frame andColor:(int)color andTitle:(NSString *)title;
- (void)createNextNavigationBarWithColor:(UIColor *)color andTitle:(NSString *)title andIsIndex:(BOOL)isIndex;
- (void)createBeforeNavigationBar;
- (void)createFirstNavigationBar;
- (void)changeNavigationBarWithRatio:(float)ratio;
- (void)changeNavigationBarAddArray;
- (void)changeNavigationBarDeleteArray;

- (void)didGetMessage:(BOOL)message;
- (void)updateTitle:(NSString *)title andUrl:(NSString *)url;

@end

@protocol NavigationViewDelegate <NSObject>
- (void)navigationViewDidTapBackButton:(NavigationView *)navigationView;
- (void)navigationViewDidTapQRCodeButton:(NavigationView *)navigationView;
- (void)navigationViewDidTapMemberButton;

@end
