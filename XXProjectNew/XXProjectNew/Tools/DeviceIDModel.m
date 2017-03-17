//
//  DeviceIDModel.m
//  XXProjectNew
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "DeviceIDModel.h"
#import "SSKeychain.h"
@implementation DeviceIDModel
//+(instancetype)Model{
//    
//    static id model;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        model = [DeviceIDModel new];
//        
//    });
//    
//    return model;
//    
//}

+(NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"XLuuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"XLuuid"];
    }
    return currentDeviceUUIDStr;
}
@end
