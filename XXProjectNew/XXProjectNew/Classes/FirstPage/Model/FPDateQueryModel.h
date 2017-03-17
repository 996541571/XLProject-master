//
//  FPDateQueryModel.h
//  XXProjectNew
//
//  Created by apple on 16/11/10.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FPResultModel;
@interface FPDateQueryModel : NSObject
@property(nonatomic,copy)NSString* code;
@property(nonatomic,copy)NSString* amount;
//用copy会出错
@property(nonatomic,strong)FPResultModel* result;
@property(nonatomic,copy)NSString* resultStatus;
- (instancetype)initWithDictionary:(NSDictionary*)dic;
+(instancetype)DateQueryWithDictionary:(NSDictionary*)dic;
@end
