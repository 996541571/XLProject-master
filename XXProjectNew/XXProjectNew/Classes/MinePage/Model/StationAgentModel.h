//
//  StationAgentModel.h
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationAgentModel : NSObject

//dealWithData:@[@"trueName",@"userRole",@"gender",@"credentialsNumber",@"mobilePhone",@"wechatId"] andDic:dic];
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* sex;
@property(nonatomic,copy)NSString* idNumber;
@property(nonatomic,copy)NSString* mobilePhone;
@property(nonatomic,copy)NSString* wechatId;
@property(nonatomic,copy)NSString* userType;
@property(nonatomic,copy)NSString* nikerName;
@property(nonatomic,copy)NSString* introduce;
@property(nonatomic,copy)NSString* headImg;
@property(nonatomic,strong)NSNumber *fansNumber;
@property(nonatomic,strong)NSNumber *followsNumber;
@property(nonatomic,copy)NSString* partyId;
//登录手机号
@property(nonatomic,copy)NSString* loginName;
@end
