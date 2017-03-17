//
//  XLPackage.h
//  XXProject
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLPlist : NSObject
+(instancetype)sharePlist;//初始化
-(NSString*)getPlistRouteByPlistRoute:(NSString*)appendPlistRoute;
// 保存数据到plist文件
-(void)saveToPlistByAppendPlisRouteStr:(NSString*)appendPlistRoute ByJsonDic:(id)jsonDic;
//从plist文读取数据
-(NSDictionary*)getPlistDicByAppendPlistRoute:(NSString*)appendPlistRoute;
//删除plist文件
-(void)deletePlistByPlistRoute:(NSString*)appendPlistRoute;
// 手机信息
-(NSDictionary*)deviceInfo;
//60s重新验证
-(void)reGetIdentityCode:(UIButton*)btn;

-(void)cancelTimerOfButton:(UIButton *)btn;

-(void)setObject:(NSObject *)obj forKey:(NSString *)key;

-(void)removeObjectForKey:(NSString *)key;

@end
