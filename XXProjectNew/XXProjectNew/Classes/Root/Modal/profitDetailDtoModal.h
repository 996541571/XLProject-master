//
//  profitDetailDtoModal.h
//  XXProjectNew
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface ProfitDetailDtoModal : NSObject
@property(nonatomic,retain)NSString*bankProfit;
@property(nonatomic,retain)NSString*eshopProfit;
@property(nonatomic,retain)NSString*loanProfit;
@property(nonatomic,retain)NSString*liveEchargeProfit;


@property(nonatomic,retain)NSString*month;
@property(nonatomic,retain)NSString*total;
@property(nonatomic,retain)NSString*totalProfit;
@property(nonatomic,retain)NSString*year;
@property(nonatomic,retain)NSMutableArray*colorArr;
@property(nonatomic,retain)NSMutableArray*labNameArr;
@property(nonatomic,retain)NSMutableArray*dataArr;
@property(nonatomic,retain)NSMutableArray*transferdDataArr;
@property(nonatomic,retain)NSMutableArray*transferdLabArr;









@end
