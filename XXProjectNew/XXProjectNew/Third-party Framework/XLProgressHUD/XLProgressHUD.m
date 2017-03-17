//
//  XLProgressHUD.m
//  Pods
//
//  Created by Jone on 16/1/6.
//
//

#import "XLProgressHUD.h"

@implementation XLProgressHUD

#pragma mark - Public Function

+ (MBProgressHUD *)showOnWindowMessage:(NSString *)message{
    MBProgressHUD * hud = [self showOnWindowMessage:message autoHide:2.0f];
    return hud;
}

+ (MBProgressHUD *)showOnWindowMessage:(NSString *)message autoHide:(NSTimeInterval)time{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [self showOnView:view message:message animated:NO];
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:time];
    return hud;
}

+ (MBProgressHUD *)showOnView:(UIView *)view message:(NSString *)message animated:(BOOL)animated{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    return hud;
}

+ (MBProgressHUD *)showOnView:(UIView *)view onlyMessage:(NSString *)message animated:(BOOL)animated{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2.0f];
    return hud;
}

+ (MBProgressHUD *)showOnView:(UIView *)view message:(NSString *)message animated:(BOOL)animated autoHide:(NSTimeInterval)time{
    MBProgressHUD *hud = [self showOnView:view message:message animated:animated];
    [hud hide:YES afterDelay:time];
    return hud;
}

+ (void)hideOnWindow{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    [self hideOnView:view];
}

+ (void)hideOnView:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}


@end
