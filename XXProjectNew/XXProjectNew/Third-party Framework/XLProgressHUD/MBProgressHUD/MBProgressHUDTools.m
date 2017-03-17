//
//  MBProgressHUDTools.m
//  BaoYuanProIos
//
//  Created by zzs on 15/11/13.
//  Copyright (c) 2015年 Sun. All rights reserved.
//

#import "MBProgressHUDTools.h"
#import "MBProgressHUD.h"
@implementation MBProgressHUDTools
+ (void)showMBProgressHUDView:(UIView*)view message:(NSString*)message
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view  animated:YES];
    // 显示的文字,比如:加载失败...加载中...
    hud.labelText = message;
    // 标志:必须为YES,才可以隐藏,  隐藏的时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    //圆形进度条
    hud.mode = MBProgressHUDModeIndeterminate;

    if([message isEqualToString:LOADINGLOSEMESSAGE]){
        [hud hide:YES afterDelay:3];
    }
}

+ (void)hideMBProgressHUDView:(UIView*)view
{
    
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
}
@end
