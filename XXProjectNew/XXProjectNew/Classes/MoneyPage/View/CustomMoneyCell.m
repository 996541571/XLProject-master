//
//  CustomMoneyCell.m
//  XXProjectNew
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "CustomMoneyCell.h"
#import "RoundView.h"


@implementation CustomMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSeparate_Line];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)FillTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath imgNameStrArr:(NSMutableArray*)imgArr labelNameArr:(NSMutableArray*)labelArr ProfitDtoArr:(NSMutableArray*)ProfitDtoArr{
    NSLog(@"---secton==%ld===row==%ld",(long)indexPath.section,(long)indexPath.row);
    NSString *identifier = @"";//对应xib中设置的identifier
    switch (indexPath.section) {
            
        case 0:
            identifier = @"firstCell";
            break;
        case 1:

                identifier = @"secondCell";

            //}
            break;
            
        default:
            break;
    }
    
    CustomMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor=[UIColor whiteColor];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomMoneyCell" owner:self options:nil] objectAtIndex:indexPath.section];
        
    }
    if (indexPath.section==0) {
        UIView*upView=(UIView*)[cell viewWithTag:5789];
        upView.backgroundColor=RGB(114, 212, 255, 1);
        UILabel*sepOnUpViewLab= (UILabel*)[cell viewWithTag:1113];
        sepOnUpViewLab.backgroundColor=RGB(17, 170, 239, 1);
        UILabel*moreLab= (UILabel*)[cell viewWithTag:1001];
        moreLab.textColor=RGB(170, 170, 170, 1);
        UILabel*noOpenLab= (UILabel*)[cell viewWithTag:1222];
        noOpenLab.textColor=RGB(170, 170, 170, 1);
        noOpenLab.hidden=YES;
        


        UILabel*horizonLab= (UILabel*)[cell viewWithTag:2002];
        horizonLab.backgroundColor=RGB(235, 235, 235, 1);
        //四个小方块
        UIView*downView=(UIView*)[cell viewWithTag:4321];

        UILabel*imageLab= (UILabel*)[downView viewWithTag:1200];
        imageLab.backgroundColor=RGB(156, 207, 253, 1);
        
        UILabel*imageLab1= (UILabel*)[downView viewWithTag:1201];
        imageLab1.backgroundColor=RGB(255, 166, 165, 1);
        UILabel*imageLab2= (UILabel*)[downView viewWithTag:1202];
        imageLab2.backgroundColor=RGB(255, 237, 184, 1);
        UILabel*imageLab3= (UILabel*)[downView viewWithTag:1203];
        imageLab3.backgroundColor=RGB(186, 244, 227, 1);

    }else
    {
        if (indexPath.row==0) {
            
          CGRect rect =CGRectMake(0, 0, screenWidth, 0.1*screenHeight);
            UIImageView*imageView=(UIImageView*) [cell viewWithTag:5676];
            if (!imageView) {
                imageView=[[UIImageView alloc]initWithFrame:rect];
                imageView.tag=5676;
                NSLog(@"--%@",NSStringFromCGRect(cell.frame));
                imageView.image=[UIImage imageNamed:@"rain.jpg"];
                [cell addSubview:imageView];
                UILabel*contentLab=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-150, 0.1*screenHeight/2-15, 300, 30)];
                contentLab.textAlignment=NSTextAlignmentCenter;
                contentLab.text=@"业务明细";
                contentLab.font=[UIFont systemFontOfSize:15.0];
                [imageView addSubview:contentLab];
            }
        }else{
            UILabel*sepLab= (UILabel*)[cell viewWithTag:3366];
            sepLab.backgroundColor=RGB(233, 233, 233, 1);

                    UIImageView*imgView=(UIImageView*)[cell viewWithTag:2000];
            if (imgArr.count) {
                imgView.image=[UIImage imageNamed:imgArr[indexPath.row-1]];
            }
            UILabel*contentLab= (UILabel*)[cell viewWithTag:2001];
            if (labelArr.count) {
                contentLab.text=labelArr[indexPath.row-1];
            }
            
        }
        
    }

    
    
    return cell;
}

-(void)setupSeparate_Line{
    
    self.separate_line = [UIView  new];
    
    [self addSubview:_separate_line];
    
    _separate_line.backgroundColor = [UIColor lightGrayColor];
    
    self.separate_line.hidden = true;
    
    
    
    [self.separate_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@0.5);
        
        make.bottom.equalTo(self.contentView);
        
        make.width.mas_equalTo(screenWidth);
        
        
        
    }];
    
    //    self.separate_line.frame = CGRectMake(0,viewHight*2+10, screenWidth, 2);
    
}


@end
