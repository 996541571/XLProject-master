//
//  BaseTabBarController.h
//  KXTTest222
//
//  Created by 张鹏伟 on 15/8/25.
//  Copyright (c) 2015年 108. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController

@property (strong, nonatomic) UIView *bgView;
@property(nonatomic,assign)BOOL isNew;
+(BaseTabBarController *) sharedInstance;

- (void)changeShowViewOfPush:(NSDictionary *)dic;
- (void)changeShowViewInOutState:(NSDictionary *)dic;

- (void)sendToSpecVc:(NSString *)contentStr;

@end
