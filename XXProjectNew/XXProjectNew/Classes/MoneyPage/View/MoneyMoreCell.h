//
//  MoneyMoreCell.h
//  XXProjectNew
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyMoreCell : UITableViewCell
+ (instancetype)moreTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath imgNameStrArr:(NSMutableArray*)imgArr labelNameArr:(NSMutableArray*)labelArr;

@end
