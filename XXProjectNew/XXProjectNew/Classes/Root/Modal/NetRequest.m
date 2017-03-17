//
//  NetRequest.m
//  KXTTest222
//
//  Created by 108财经 on 15/6/16.
//  Copyright (c) 2015年 108财经. All rights reserved.
//


#import "XLEncryptionManager.h"
#import <UIKit/UIKit.h>
#import "DeviceIDModel.h"

//http://appapi.kxt.com/data/action 
@implementation NetRequest
//封装请求
+(void)requetWithParams:(NSArray *)parms requestName:(NSString *)requestName finishBlock:(void (^)(NSDictionary *, NSError *))block
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:parms options:NSJSONWritingPrettyPrinted error:nil];
    
    
    NSString *fsgfg =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSString*dStr=[XLEncryptionManager sha512Base64:fsgfg];
    
    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *operationType = [NSString stringWithFormat:@"com.xianglin.appserv.common.service.facade.%@",requestName];
    
    
    //该函数将 将要添加到URL的字符串进行特殊处理，如果这些字符串含有 &， ？ 这些特殊字符，用“%+ASCII” 代替之。
    
    NSString *fsgfg_ = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)fsgfg,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
    //

    

    NSDictionary*dic=@{@"d":dReal,@"operationType":operationType,@"requestData":fsgfg_};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"%@",error.localizedDescription);
    }];
}

//图片处理特殊请求
+(void)requetWith_img_Params:(NSArray *)parms requestName:(NSString *)requestName finishBlock:(void (^)(NSDictionary *, NSError *))block
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:parms options:NSJSONWritingPrettyPrinted error:nil];
    
    
    NSString *fsgfg =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString*dStr=[XLEncryptionManager sha512Base64:fsgfg];
    
    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *operationType = [NSString stringWithFormat:@"com.xianglin.appserv.common.service.facade.%@",requestName];
    
    //该函数将 将要添加到URL的字符串进行特殊处理，如果这些字符串含有 &， ？ 这些特殊字符，用“%+ASCII” 代替之。
    
     NSString *fsgfg_ = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)fsgfg,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
    
    NSDictionary*dic=@{@"d":dReal,@"operationType":operationType,@"requestData":fsgfg_};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"%@",error.localizedDescription);
    }];
}




+ (void)ProactiveLoginByNode:(NSString*)nodeStr passwordStr:(NSString*)passwordStr block:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString*password=[XLEncryptionManager sha512Base64:passwordStr];
    NSArray*arr=@[@{@"nodeCode":nodeStr,@"password":password,@"clientVersion":sysVersion},[[XLPlist sharePlist] deviceInfo]];
    NSLog(@"%@",arr);
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.AppLoginService.login",@"requestData":requestData};
    NSLog(@"%@",dic);
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"++++++=======%@",operation.response.allHeaderFields);
        [[NSUserDefaults standardUserDefaults]setObject:[operation.response.allHeaderFields objectForKey:@"Set-Cookie"]   forKey:@"cookie"];
        
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
}



//激活设备
+ (void)ActivateDevide:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
//    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
 
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    NSString *currentDeviceID = [keychainStore stringForKey:XLDeviceID];
    if (!currentDeviceID) {
        currentDeviceID = @"";
    }
    NSArray*arr=@[@{@"platform":iPhonePlatform,@"systemType":PhoneType,@"systemVersion":iPhoneVersion,@"deviceId":currentDeviceID}];
//    NSArray*arr=@[@{@"platform":iPhonePlatform,@"systemType":@"ios",@"systemVersion":iPhoneVersion,@"iosInfo":[DeviceIDModel getDeviceId]}];
//  NSArray*arr=@[@{@"platform":@"iphone",@"systemType":@"ios",@"systemVersion":@"1.0.0"}];
    NSLog(@"-----platform===%@===systemType===%@==systemVersion==%@===deviceID==%@",iPhonePlatform,PhoneType,iPhoneVersion,iPhoneUDID);
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fsgfg =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:fsgfg];

    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dReal,@"operationType":@"com.xianglin.appserv.common.service.facade.DeviceInfoService.activateDevice",@"requestData":fsgfg};
    NSLog(@"%@",dic);
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults]setObject:[operation.response.allHeaderFields objectForKey:@"Set-Cookie"]   forKey:@"cookie"];
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"激活error===%@",error.localizedDescription);
    }];
}
//登录接口
+ (void)ProactiveLoginByPhoneNum:(NSString*)phoneNum identityCode:(NSString*)identityCodeStr block:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString*password=[XLEncryptionManager sha512Base64:identityCodeStr];
    NSArray*arr=@[@{@"mobilePhone":phoneNum,@"smsCode":identityCodeStr,@"clientVersion":sysVersion},[[XLPlist sharePlist] deviceInfo]];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.AppLoginService.loginByMobileV1_3",@"requestData":requestData};    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"++++++=======%@",operation.response.allHeaderFields);
        [[NSUserDefaults standardUserDefaults]setObject:[operation.response.allHeaderFields objectForKey:@"Set-Cookie"]   forKey:@"cookie"];
        
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
}

//确认推送消息被收到或点开
+(void)updatePushMsgWithMsgId:(NSString *)msgId deviceid:(NSString *)deviceid pushStatus:(NSString *)pushStatus block:(void(^)(NSDictionary *responseDicionary, NSError *error))block
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    if (!msgId) {
        msgId = @"";
    }
    NSArray*arr=@[@{@"msgId":msgId,@"deviceId":deviceid,@"pushStatus":pushStatus}];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.MessageService.updatePushMsg",@"requestData":requestData};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"++++++=======%@",operation.response.allHeaderFields);
        [[NSUserDefaults standardUserDefaults]setObject:[operation.response.allHeaderFields objectForKey:@"Set-Cookie"]   forKey:@"cookie"];
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
}
//自动登录
+ (void)AutoLogin:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
      NSDictionary*proactiveLoginDic=      [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber*partyID=[proactiveLoginDic objectForKey:@"nodeManagerPartyId"];
    if (!partyID) {
        partyID  = @-1;
    }
    NSString*partyIDStr=[NSString stringWithFormat:@"%@",partyID];
    NSLog(@"%@",[[XLPlist sharePlist] deviceInfo]);
    NSArray*arr=@[@{@"partyId":partyIDStr,@"clientVersion":sysVersion},[[XLPlist sharePlist] deviceInfo]];
    NSLog(@"%@",arr);
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dReal,@"operationType":@"com.xianglin.appserv.common.service.facade.AppLoginService.autoLoginVOPT",@"requestData":jsonStr};
    
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 30.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults]setObject:[operation.response.allHeaderFields objectForKey:@"Set-Cookie"]   forKey:@"cookie"];
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
}
//退出

+ (void)quitLogin:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    //    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary*proactiveLoginDic=      [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber*partyID=[proactiveLoginDic objectForKey:@"nodeManagerPartyId"];
    NSString*partyIDStr=[NSString stringWithFormat:@"%@",partyID];
    NSArray*arr=@[@{@"partyId":partyIDStr,@"deviceId":[[NSUserDefaults standardUserDefaults] objectForKey:@"did"]}];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dReal,@"operationType":@"com.xianglin.appserv.common.service.facade.AppLoginService.logout",@"requestData":jsonStr};
    
    
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
}
//发送短信

//+ (void)getIdendityCodeNumWithNode:(NSString*)nodeStr phoneNum:(NSString*)phoneStr block:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
//    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
//    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
//    
//    //    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
//    //    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    NSArray*arr=@[@{@"nodeCode":nodeStr,@"mobilePhone":phoneStr}];
//    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
//    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    NSDictionary*dic=@{@"d":dReal,@"operationType":@"com.xianglin.appserv.common.service.facade.AppLoginService.sendSms",@"requestData":jsonStr};
//    
//    
//    
//    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        block(responseObject,nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        block(nil,error);
//        NSLog(@"===%@",error.localizedDescription);
//    }];
//}

//首次登录(需配合短信验证码)
+ (void)firstLoginWithNode:(NSString*)nodeStr phoneStr:(NSString*)phoneStr smgStr:(NSString*)smgStr passwordStr:(NSString*)passwordStr block:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    //    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString*password=[XLEncryptionManager sha512Base64:passwordStr];
    
    NSArray*arr=@[@{@"nodeCode":nodeStr,@"smsCode":smgStr,@"password":password,@"mobilePhone":phoneStr}];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSDictionary*dic=@{@"d":dReal,@"operationType":@"com.xianglin.appserv.common.service.facade.AppLoginService.userFirstLogin",@"requestData":requestData};
    
    
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
}



//根据手机号获取验证码
+ (void)getIdentityCodeByPhoneNum:(NSString*)phoneNum block:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    //    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSArray*arr=@[@{@"mobilePhone":phoneNum}];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dReal,@"operationType":@"com.xianglin.appserv.common.service.facade.AppLoginService.sendSms",@"requestData":jsonStr};
    
    NSLog(@"%@",dic);
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
}


//开通业务
+ (void)getOpenService:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
//        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray*arr=@[@"",@""];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.getXLAppHomeData",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];

   }
//5个小圆按钮
+ (void)fiveRoundBtnList:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray*arr=@[@""];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //    NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.getBusinessList",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}
//scrollview
+ (void)scrollList:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray*arr=@[];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //    NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.getBanerList",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}
//赚钱首页
+ (void)earnMoneyPage:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary*proactiveLoginDic=      [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber*partyID=[proactiveLoginDic objectForKey:@"nodeManagerPartyId"];
    NSString*partyIDStr=[NSString stringWithFormat:@"%@",partyID];
    NSArray*arr=@[partyIDStr];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //        NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.EarnPageService.getEarnHomeData",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}


//赚钱更多
+ (void)earnMoneyMoreListWithPage:(int)page  block:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray*arr=@[@"",@"INCOME",[NSString stringWithFormat:@"%d",page],@"10"];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//        NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.EarnPageService.getProfitDetailList",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}


+ (void)searchStationInfo:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray*arr=@[@"1",@"2"];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //        NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.appXLAppIndexPageService.getMsgList",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}
//资金账户拦是否存在
+ (void)whetherCountExist:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary*loginInfodic =[[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
     NSString*partyStr=[NSString stringWithFormat:@"%@",[loginInfodic objectForKey:@"nodePartyId"]];
    NSArray*arr=@[partyStr];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //        NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.isExistPartyAttrAccount",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}
//首页消息广告是否更多
+ (void)firstPageMesMoreWithPage:(int)page  block:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary*loginInfodic =[[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
//    NSString*partyStr=[NSString stringWithFormat:@"%@",[loginInfodic objectForKey:@"nodePartyId"]];
//    NSArray*arr=@[partyStr];
    NSArray*arr=@[[NSString stringWithFormat:@"%d",page],@"10"];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //        NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.getMsgList",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}

+(NSString *)dealThevideoTime:(double)time
{
    NSDate *detaildate= [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
+ (void)yejiAndBenefitRank:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    ;
    //        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray*arr=@[@""];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:jsonStr];
    NSString*dRealStr = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    //        NSString*requestData = [jsonStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dRealStr,@"operationType":@"com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.getBusiVisitUrlInfo",@"requestData":jsonStr};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
        NSLog(@"===%@",error.localizedDescription);
    }];
    
}
//注册apns通知
+ (void)registerAPNS:(void(^)(NSDictionary *responseDicionary, NSError *error))block{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber *nodeManagerPartyId = [proactiveLoginDic objectForKey:@"nodeManagerPartyId"];
    NSString *did = [[NSUserDefaults standardUserDefaults]objectForKey:@"did"];
    if (!did) {
        did = @"";
    }

    if (!nodeManagerPartyId) {
        nodeManagerPartyId = @0;
    }
    NSArray*arr=@[@{@"deviceId":did,@"pushType":@"JPUSH",@"pushToken":did,@"version":sysVersion,@"partyId":nodeManagerPartyId}];
//      NSArray*arr=@[@{@"deviceId":[[NSUserDefaults standardUserDefaults]objectForKey:@"did"],@"pushType":@"APNS",@"pushToken":[[NSUserDefaults standardUserDefaults]objectForKey:APNSTokenKey],@"version":sysVersion,@"partyId":[proactiveLoginDic objectForKey:@"nodeManagerPartyId"]}];
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fsgfg =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString*dStr=[XLEncryptionManager sha512Base64:fsgfg];
    
    NSString*dReal = [dStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary*dic=@{@"d":dReal,@"operationType":@"com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.submitPushInfo",@"requestData":fsgfg};
    
    [manger POST:totalUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

















































//post异步请求封装函数
+ (void)post:(NSString *)URL RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block{
    //把传进来的URL字符串转变为URL地址
    NSURL *url = [NSURL URLWithString:URL];
    //请求初始化，可以在这针对缓存，超时做出一些设置
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:20];
    //解析请求参数，用NSDictionary来存参数，通过自定义的函数parseParams把它解析成一个post格式的字符串
   NSString *parseParamsResult = [self parseParams:params];
    
//    NSString*str=[NSString stringWithFormat:@"d=%@&operationType=%@&requestData=%@",params[@"d"],params[@"operationType"],params[@"requestData"]];
    NSData *postData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"-1" forHTTPHeaderField:@"did"];
    [request setHTTPBody:postData];
    
    //创建一个新的队列（开启新线程）
    NSOperationQueue *queue = [NSOperationQueue new];
    //发送异步请求，请求完以后返回的数据，通过completionHandler参数来调用
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:block];
    //    return result;
}

//把NSDictionary解析成post格式的NSString字符串
+ (NSString *)parseParams:(NSDictionary *)params{
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        [result appendString:keyValueFormat];
        NSLog(@"post()方法参数解析结果：%@",result);
    }
    return result;
}


@end
