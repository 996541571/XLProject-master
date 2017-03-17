//
//  RankModel.m
//  XXProjectNew
//
//  Created by apple on 2016/11/14.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "RankModel.h"

@implementation RankModel
//static RankModel * _model;
//+ (void)initialize
//{
//    [super initialize];
//    _model = [[RankModel alloc]init];
//}

//+ (RankModel *)initWithDic:(NSDictionary *)dic
//{
//    [_model setValuesForKeysWithDictionary:dic];
//    
//    return  _model;
//}
//// 解决KVC赋值时程序奔溃的问题
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
