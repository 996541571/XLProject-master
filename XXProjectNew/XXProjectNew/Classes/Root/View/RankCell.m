//
//  RankCell.m
//  XXProjectNew
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)rankTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSLog(@"---secton==%ld===row==%ld",(long)indexPath.section,(long)indexPath.row);
    NSString *identifier = @"";//对应xib中设置的identifier
    switch (indexPath.section) {
        case 0:
            identifier=@"rankFirst";
            break;
            
        case 1:
            identifier = @"rankSecond";
            break;
            
        default:
            break;
    }
    
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    cell.backgroundColor=[UIColor whiteColor];
    
    if (!cell) {
       
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RankCell" owner:self options:nil] objectAtIndex:indexPath.section];
        
    }
    if (indexPath.section==0) {
        UILabel*sep=(UILabel*)[cell viewWithTag:6666];
        sep.backgroundColor=RGB(238, 238, 238, 1);
        
    }else
    {
        UILabel*sep=(UILabel*)[cell viewWithTag:6667];
        sep.backgroundColor=RGB(238, 238, 238, 1);


    }
    
    
    return cell;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
