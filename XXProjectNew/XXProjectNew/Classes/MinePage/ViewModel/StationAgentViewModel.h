//
//  StationAgentViewModel.h
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ad_section_0_rowCount 3
#define ad_section_1_rowCount 4
#define vi_section_0_rowCount 5

#import "SubSAViewController.h"

@class StationAgentModel;

@interface StationAgentViewModel : NSObject
+(instancetype)model;

@property(nonatomic,strong)NSArray* dataArr;
@property(nonatomic,strong)NSArray* logArr;
@property(nonatomic,strong)StationAgentModel* dataModel;
@property(nonatomic,strong)NSArray* dataModel_arr;

@property(nonatomic,assign)BOOL coinAppear;

@property(nonatomic,copy)NSString* partyId;

-(void)uploadForHeadIcon:(UIImage*)img Success:(void(^)(NSString* imgUrl))success;


-(void)obtainWebDataWithSuccess:(void (^)())success andFinished:(void(^)())finished;


-(void)saveAndUpdataWithType:(Type)type para:(NSString*)str andSuccess:(void (^)(BOOL success))block;


@end
