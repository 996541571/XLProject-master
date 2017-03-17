//
//  BankMoreCell.h
//  XXProjectNew
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankMoreCell : UITableViewCell
+ (instancetype)bankMoreTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath nameArr:(NSArray*)nameArr imageArr:(NSArray*)imageArr;

@end
