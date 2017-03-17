//
//  FirstPageViewModel.h
//  XXProjectNew
//
//  Created by apple on 12/8/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BusinessModel;
@interface FirstPageViewModel : NSObject
+(instancetype)model;
@property(nonatomic,strong)NSArray<BusinessModel*>* business_arr;

@property(nonatomic,strong)NSDictionary* solarDic;


-(void)queryBusinessModulWithSuccess:(void(^)())success;

-(void)queryForSolarDataWithSuccess:(void (^)())block;

-(void)obtainInvitePeopleNum:(void (^)(NSString* str))success;

@end
