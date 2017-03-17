//
//  FPResultModel.m
//  XXProjectNew
//
//  Created by apple on 16/11/10.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "FPResultModel.h"
#import "businessDtoListModal.h"
@implementation FPResultModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
- (instancetype)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

+(instancetype)ResultModelWithDictionary:(NSDictionary*)dic{
    
    FPResultModel* model = [[FPResultModel alloc]initWithDictionary:dic];
    
    return model;
}

-(void)setBusinessDtoList:(NSArray *)businessDtoList{
    
    NSMutableArray* arr = [NSMutableArray array];
    
    for (NSDictionary* dic in businessDtoList) {
        
       BusinessDtoListModal* model =  [BusinessDtoListModal new];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [arr addObject:model];
        
    }
    
    _businessDtoList = arr.copy;
    
}


@end
