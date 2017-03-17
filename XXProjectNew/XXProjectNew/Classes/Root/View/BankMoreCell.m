//
//  BankMoreCell.m
//  XXProjectNew
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "BankMoreCell.h"

@implementation BankMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)bankMoreTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath nameArr:(NSArray*)nameArr imageArr:(NSArray*)imageArr{
    
    NSLog(@"---secton==%ld===row==%ld",(long)indexPath.section,(long)indexPath.row);
    
    NSString *identifier = @"";//对应xib中设置的identifier
    if (indexPath.section==0) {
       identifier=@"bankFirstCell";
    }else
    {
        identifier=@"bankOtherCell";
        
    }

    BankMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    
    
    
    if (!cell) {
        int rowq=indexPath.row;
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BankMoreCell" owner:self options:nil] objectAtIndex:indexPath.section];
        
        
        
    }
    if (indexPath.section!=0) {
        NSLog(@"row==%ld",(long)indexPath.row);

        UIImageView*imgView=(UIImageView*)[cell viewWithTag:2200];
        
        imgView.image=[UIImage imageNamed:imageArr[indexPath.row]];
        UILabel*contentLab= (UILabel*)[cell viewWithTag:2201];
        contentLab.text=nameArr[indexPath.row];
        UILabel*sepLab= (UILabel*)[cell viewWithTag:3543];

        sepLab.backgroundColor = RGB(238,238,238,1.0f);

        
        
        
    }

    
    
    return cell;
    
}



@end
