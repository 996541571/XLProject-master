//
//  CustomMoneyCell.h
//  XXProjectNew
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMoneyCell : UITableViewCell
@property(nonatomic,strong)UIView* separate_line;



+ (instancetype)FillTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath imgNameStrArr:(NSMutableArray*)imgArr labelNameArr:(NSMutableArray*)labelArr ProfitDtoArr:(NSMutableArray*)ProfitDtoArr;
//@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//@property (weak, nonatomic) IBOutlet UILabel *label;


@end
