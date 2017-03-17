//
//  NoticeTool.h
//  XXProjectNew
//
//  Created by apple on 2016/10/28.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeTool : NSObject
+(instancetype)notice;//初始化
-(void)expireNoticeOnController:(UIViewController *)VC;//过期提示
-(void)showTips:(NSString *)tips onController:(UIViewController *)vc;//其他提示
-(void)showTips:(NSString *)tips onView:(UIView *)view;//其他提示
@end
