//
//  NetRequest.h
//  KXTTest222
//
//  Created by 108财经 on 15/6/16.
//  Copyright (c) 2015年 108财经. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>
@interface NetRequest : NSObject
//封装请求
+(void)requetWithParams:(NSArray *)parms requestName:(NSString *)requestName finishBlock:(void(^)(NSDictionary *responseDicionary, NSError *error))block;

//图片特殊处理

+(void)requetWith_img_Params:(NSArray *)parms requestName:(NSString *)requestName finishBlock:(void (^)(NSDictionary *, NSError *))block;


//注册apns通知
+ (void)registerAPNS:(void(^)(NSDictionary *responseDicionary, NSError *error))block;

+ (void)ProactiveLoginByNode:(NSString*)nodeStr passwordStr:(NSString*)passwordStr block:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//备用
+ (void)post:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;//post请求封装
//激活设备,获取did值
+ (void)ActivateDevide:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//主动登录
//自动登录
+ (void)AutoLogin:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
+ (void)ProactiveLoginByPhoneNum:(NSString*)phoneNum identityCode:(NSString*)identityCodeStr block:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//退出
+ (void)quitLogin:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//确认推送消息被收到或点开
+(void)updatePushMsgWithMsgId:(NSString *)msgId deviceid:(NSString *)deviceid pushStatus:(NSString *)pushStatus block:(void(^)(NSDictionary *responseDicionary, NSError *error))block;

//首次登录
+ (void)firstLoginWithNode:(NSString*)nodeStr phoneStr:(NSString*)phoneStr smgStr:(NSString*)smgStr passwordStr:(NSString*)passwordStr block:(void(^)(NSDictionary *responseDicionary, NSError *error))block;

//通过手机号码获取验证码

+ (void)getIdentityCodeByPhoneNum:(NSString*)phoneNum block:(void(^)(NSDictionary *responseDicionary, NSError *error))block;

//忘记密码
+ (void)forgetSecret:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//5个小圆按钮
+ (void)fiveRoundBtnList:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//开通业务
+ (void)getOpenService:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
+ (void)scrollList:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//赚钱
+ (void)earnMoneyPage:(void(^)(NSDictionary *responseDicionary, NSError *error))block;

//赚钱更多
+ (void)earnMoneyMoreListWithPage:(int)page  block:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//查询站长公告信息
+ (void)searchStationInfo:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//是否存在资金栏
+ (void)whetherCountExist:(void(^)(NSDictionary *responseDicionary, NSError *error))block;
//首页点击消息广告加载更多
+ (void)firstPageMesMoreWithPage:(int)page  block:(void(^)(NSDictionary *responseDicionary, NSError *error))block;

//时间
+(NSString *)dealThevideoTime:(double)time;
//首页的业绩与收益排行图片点击进去的数据
+ (void)yejiAndBenefitRank:(void(^)(NSDictionary *responseDicionary, NSError *error))block;










@end
