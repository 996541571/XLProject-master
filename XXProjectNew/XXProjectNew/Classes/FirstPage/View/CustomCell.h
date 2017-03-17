//
//  CustomCell.h
//  XXProjectNew
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 xianglin. All rights reserved.
//
//#define firstCellTotalHeight 0.3229*screenHeight
//#define firstScrollHeight 0.548*firstCellTotalHeight

#import <UIKit/UIKit.h>
#import "WHScrollAndPageView.h"


@interface CustomCell : UITableViewCell<SDCycleScrollViewDelegate>
//@property(nonatomic,copy)void(^rankPress)(int tag);


//自定义分割线__指引

//@property(nonatomic,strong)NSIndexPath* index;
@property(nonatomic,assign)BOOL isLast;
@property(nonatomic,strong)UIView* separate_line;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath arr:(NSArray*)arr;




@end
