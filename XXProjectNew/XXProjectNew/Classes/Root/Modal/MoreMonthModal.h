//
//  MoreMonthModal.h
//  XXProjectNew
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreMonthModal : NSObject
@property(nonatomic,retain)NSString*bankProfit;
@property(nonatomic,retain)NSString*eshopProfit;
@property(nonatomic,retain)NSString*loanProfit;
@property(nonatomic,retain)NSString*liveEchargeProfit;
@property(nonatomic,strong)NSString *mobileEchargeProfit;
@property(nonatomic,retain)NSString*month;
@property(nonatomic,retain)NSString*total;
@property(nonatomic,retain)NSMutableArray*totalProfit;
@property(nonatomic,retain)NSMutableArray*year;

@property(nonatomic,retain)NSMutableArray*modalArr;


@end
