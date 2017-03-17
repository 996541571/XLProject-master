//
//  MBProgressHUDTools.h
//  BaoYuanProIos
//
//  Created by zzs on 15/11/13.
//  Copyright (c) 2015年 Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MBProgressHUDTools : NSObject
// 显示进度条
+ (void)showMBProgressHUDView:(UIView*)view message:(NSString*)message;
;// 隐藏进度条
+ (void)hideMBProgressHUDView:(UIView*)view;
@end
