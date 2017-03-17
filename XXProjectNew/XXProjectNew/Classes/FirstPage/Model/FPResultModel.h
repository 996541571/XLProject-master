//
//  FPResultModel.h
//  XXProjectNew
//
//  Created by apple on 16/11/10.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FPResultModel : NSObject
@property(nonatomic,copy)NSString* isFlag;
@property(nonatomic,copy)NSString* profitDto;
@property(nonatomic,copy)NSArray* msgVoList;
@property(nonatomic,copy)NSArray* banerDtoList;
@property(nonatomic,copy)NSArray* businessDtoList;
@property(nonatomic,copy)NSArray* stations;
@property(nonatomic,copy)NSString* bankBalance;
@property(nonatomic,copy)NSDictionary* solarData;
@property(nonatomic,copy)NSString* cardCount;
//@property(nonatomic,copy)NSArray* newStatiosList;
+(instancetype)ResultModelWithDictionary:(NSDictionary*)dic;

@end
