//
//  MoneyMoreCell.m
//  XXProjectNew
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "MoneyMoreCell.h"

@implementation MoneyMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)moreTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath imgNameStrArr:(NSMutableArray*)imgArr labelNameArr:(NSMutableArray*)labelArr{
    NSLog(@"---secton==%ld===row==%ld",(long)indexPath.section,(long)indexPath.row);
    NSString *identifier = @"moreCell";//对应xib中设置的identifier
    
    MoneyMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor=[UIColor whiteColor];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyMoreCell" owner:self options:nil] objectAtIndex:indexPath.section];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        
        }
    UILabel*downLab=(UILabel*)[cell viewWithTag:2233];
    downLab.backgroundColor=RGB(249, 249, 249, 1);
  

    if (imgArr.count!=0) {
           MoreMonthModal*modal=imgArr[indexPath.row];
        UILabel*monthLab=(UILabel*)[cell viewWithTag:2345];

        monthLab.text= [NSString stringWithFormat:@"%@月",modal.month];
        if(modal.eshopProfit==NULL)
        {
            modal.eshopProfit=@"0.00";
        }
        if(modal.mobileEchargeProfit ==NULL)
        {
            modal.mobileEchargeProfit=@"0.00";
            
        }
        UILabel*Lab2=(UILabel*)[cell viewWithTag:5202];
        UILabel *liveLab = (UILabel*)[cell viewWithTag:5102];
        if (modal.liveEchargeProfit == NULL) {
            Lab2.hidden = YES;
            liveLab.hidden = YES;
            modal.liveEchargeProfit = @"0.00";
        }
        float total =[modal.eshopProfit floatValue] + [modal.mobileEchargeProfit floatValue]  + [modal.liveEchargeProfit floatValue];
        modal.total = [NSString stringWithFormat:@"%.2f",total];
        UILabel*totalLab=(UILabel*)[cell viewWithTag:5432];
        totalLab.text= [NSString stringWithFormat:@"%@元",[cell resetString:[NSString stringWithFormat:@"%@",modal.total]]];//[NSString stringWithFormat:@"%@元",modal.total];
        UILabel*Lab=(UILabel*)[cell viewWithTag:5200];
        Lab.text=[NSString stringWithFormat:@"%@元",[cell resetString:[NSString stringWithFormat:@"%@",modal.eshopProfit]]];//[NSString stringWithFormat:@"%@元",modal.bankProfit];
        UILabel*Lab1=(UILabel*)[cell viewWithTag:5201];
        Lab1.text=[NSString stringWithFormat:@"%@元",[cell resetString:[NSString stringWithFormat:@"%@",modal.mobileEchargeProfit]]];//[NSString stringWithFormat:@"%@元",modal.eshopProfit];
        
        Lab2.text=[NSString stringWithFormat:@"%@元",[cell resetString:[NSString stringWithFormat:@"%@",modal.liveEchargeProfit]]];//[NSString stringWithFormat:@"%@元",modal.loanProfit];
    }

    return cell;
}

-(NSString *)resetString:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"."];
    if (arr.count == 2) {
        NSString *last = arr.lastObject;
        
        if (last.length >= 2) {
            last = [last substringToIndex:2];
            str = [NSString stringWithFormat:@"%@.%@",arr.firstObject,last];
        }else if (last.length == 1){
            str = [NSString stringWithFormat:@"%@.%@0",arr.firstObject,last];
        }
        else{
            str = [str stringByAppendingString:@".00"];
        }
        
    }else{
        str = [str stringByAppendingString:@".00"];
    }
    return str;
}
@end
