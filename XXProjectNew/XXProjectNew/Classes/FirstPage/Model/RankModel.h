//
//  RankModel.h
//  XXProjectNew
//
//  Created by apple on 2016/11/14.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankModel : NSObject
@property(nonatomic,assign)long balanceRank;
@property(nonatomic,strong)NSString *nodeManagerPartyId;
@property(nonatomic,assign)long rewardsMark;
@property(nonatomic,strong)NSString *nodeName;
@property(nonatomic,assign)long rewards;
@property(nonatomic,assign)long mark;
@property(nonatomic,strong)NSString *nodePartyId;
@property(nonatomic,assign)long cardCount;
@property(nonatomic,assign)long flowers;
@property(nonatomic,assign)double balance;
@property(nonatomic,strong)NSString *hasLogin;
@property(nonatomic,strong)NSString *headImg;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
//+ (RankModel *)initWithDic:(NSDictionary *)dic;
@end
