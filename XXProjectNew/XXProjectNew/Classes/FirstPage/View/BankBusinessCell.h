//
//  BankBusinessCell.h
//  XXProjectNew
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankModel;
@interface BankBusinessCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dataDic;//数据源
@property (weak, nonatomic) IBOutlet UIButton *rewardCount;//打赏数量
@property (weak, nonatomic) IBOutlet UIButton *flowerIcon;//献花图标
@property (weak, nonatomic) IBOutlet UIButton *fowerCount;//献花数量
@property (weak, nonatomic) IBOutlet UIButton *rewordIcon;//打赏图标
@property(nonatomic,strong)RankModel *model;
@end
