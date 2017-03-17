//
//  XLProgressHUD.h
//  Pods
//
//  Created by Jone on 16/1/6.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface XLProgressHUD : UIView<MBProgressHUDDelegate>

+ (MBProgressHUD *)showOnWindowMessage:(NSString *)message;

+ (MBProgressHUD *)showOnWindowMessage:(NSString *)message autoHide:(NSTimeInterval)time;

+ (MBProgressHUD *)showOnView:(UIView *)view message:(NSString *)message animated:(BOOL)animated;

+ (MBProgressHUD *)showOnView:(UIView *)view onlyMessage:(NSString *)message animated:(BOOL)animated;

+ (MBProgressHUD *)showOnView:(UIView *)view message:(NSString *)message animated:(BOOL)animated autoHide:(NSTimeInterval)time;

+ (void)hideOnWindow;

+ (void)hideOnView:(UIView *)view;

@end
