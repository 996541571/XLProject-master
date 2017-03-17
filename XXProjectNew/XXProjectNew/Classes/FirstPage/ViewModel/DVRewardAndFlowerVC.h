//
//  DVRewardAndFlowerVC.h
//  XXProjectNew
//
//  Created by apple on 16/11/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    KindFlower,
    KindReward,
} Kind;

@interface DVRewardAndFlowerVC : UITableViewController

-(instancetype)initWithKind:(Kind)kind andNodePartyId:(NSString*)nodePartyId  andNodeManagerPartyId:(NSString*)nodeManagerPartyId andisMine:(BOOL)isMine;

@end
