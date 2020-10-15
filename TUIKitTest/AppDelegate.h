//
//  AppDelegate.h
//  TUIKitTest
//
//  Created by aaa on 2020/9/28.
//

#import <UIKit/UIKit.h>

#import "TabbarViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) TabbarViewController           *tabbarViewController;
@property (nonatomic, assign)BOOL allowRotation;// 是否允许转向
- (void)getToken;
@end

