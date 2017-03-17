//
//  MoreMesAccounceCell.m
//  XXProjectNew
//
//  Created by apple on 16/9/24.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "MoreMesAccounceCell.h"

@implementation MoreMesAccounceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)MoreMesAccounceCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath msgVoListArr:(NSMutableArray*)msgVoListArr {
    NSLog(@"---secton==%ld===row==%ld",(long)indexPath.section,(long)indexPath.row);
    NSString *identifier = @"moreCell";//对应xib中设置的identifier
    
    MoreMesAccounceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor=[UIColor whiteColor];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreMesAccounceCell" owner:self options:nil] objectAtIndex:indexPath.section];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    UILabel*downLab=(UILabel*)[cell viewWithTag:2233];
    downLab.backgroundColor=RGB(249, 249, 249, 1);
    
    
    if (msgVoListArr.count!=0) {
        MsgVoModal*modal=msgVoListArr[indexPath.row];
        NSLog(@"------modal.url===%@",modal.url);
        
                //                UILabel*contentLab= (UILabel*)[cell viewWithTag:5001];
        UILabel*contentLab=[[UILabel alloc]init];
        contentLab.text=modal.msgTitle;
        NSLog(@"-------contentlabel.text===%@",contentLab.text);
        contentLab.numberOfLines=1;
        contentLab.font=[UIFont systemFontOfSize:14];
        contentLab.textColor=RGB(51, 51, 51, 1);
//        CGSize size=CGSizeMake(0.70*screenWidth, 5);
//        CGSize expectSize=[contentLab sizeThatFits:size];
        //        label.textColor=RGB(47, 150, 255, 1);
        contentLab.frame=CGRectMake(0.2*screenWidth, 10, screenWidth*0.7, 15);
        [cell addSubview:contentLab];
    
        UILabel*timeLab= (UILabel*)[cell viewWithTag:3335];
        timeLab.text=[NetRequest dealThevideoTime:([modal.createTime doubleValue]/1000)];
        timeLab.textColor=RGB(170, 170, 170, 1);
        
        UILabel *isRead = (UILabel *)[cell viewWithTag:232];
        if ([modal.msgStatus isEqualToString:@"1"]) {//未读
            isRead.layer.cornerRadius = 3;
            isRead.clipsToBounds = YES;
            isRead.hidden = NO;
        } else {
            isRead.hidden = YES;
        }
        
    }
    
    
    
    
    return cell;
}


@end
