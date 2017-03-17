//
//  FPDateQueryModel.m
//  XXProjectNew
//
//  Created by apple on 16/11/10.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "FPDateQueryModel.h"
//#import "FPResultModel.h"
@implementation FPDateQueryModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

//-(void)setResult:(FPResultModel *)result{
//    
//    NSDictionary* dic = [NSDictionary ]
//    
////    _result = [FPResultModel ResultModelWithDictionary:dic];
//    
////    NSLog(@"-----%@",_result);
//    
//    [_result setValuesForKeysWithDictionary:result];
//    
//    NSLog(@"%@",_result);
//    NSLog(@"%@",result);
//    
//    
//    
//    
//}

//-(void)setResult:(FPResultModel *)result{
//    
//    
//    NSLog(@"%@",result.class);
//    
//}



- (instancetype)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

+(instancetype)DateQueryWithDictionary:(NSDictionary*)dic{
    
    FPDateQueryModel* model = [[FPDateQueryModel alloc]initWithDictionary:dic];
    
    return model;
}



@end
