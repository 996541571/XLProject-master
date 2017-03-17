//
//  MyCell.h
//  XXProjectNew
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property(nonatomic,strong)UIView* separate_line;

+ (instancetype)myTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath imgNameStrArr:(NSMutableArray*)imgArr labelNameArr:(NSMutableArray*)labelArr;

@end
