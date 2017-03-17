//
//  MyCell.m
//  XXProjectNew
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "MyCell.h"
@interface MyCell ()
@property (weak, nonatomic) IBOutlet UILabel *notice;
@end
@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.notice.layer.cornerRadius = 2;
    self.notice.clipsToBounds = YES;
    
    [self setupSeparate_Line];
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue ;
    
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



#pragma mark "view隐藏的真相"
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}
+ (instancetype)myTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath imgNameStrArr:(NSMutableArray*)imgArr labelNameArr:(NSMutableArray*)labelArr{
    NSLog(@"---secton==%ld===row==%ld",(long)indexPath.section,(long)indexPath.row);
    NSString *identifier = @"";//对应xib中设置的identifier
    switch (indexPath.section) {
            
        case 0:
            identifier = @"myFirst";
            break;
        case 1:
            
            identifier = @"mySecond";
            break;
//        case 2:
//            identifier = @"myForth";
//            break;
//        case 3:
//            identifier = @"Fifth";
//            break;
        default:
            break;
    }
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor=[UIColor whiteColor];
    
    if (!cell) {
        int rowq=indexPath.row;
        int sec=indexPath.section;
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:self options:nil] objectAtIndex:indexPath.section];
        
        #pragma mark "当section等于0"
        if (indexPath.section==0) {
            
            
            UIView*underView=(UIView*)[cell viewWithTag:2222];
           underView.layer.cornerRadius= 5;

            NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
            UIImageView*headerImgView=(UIImageView*)[cell viewWithTag:1221];
            NSLog(@"----class%@",[loginInfodic objectForKey:@"avatar"]);
            if (![[NSString stringWithFormat:@"%@",[loginInfodic objectForKey:@"avatar"]] isEqualToString:@""]) {
                 headerImgView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[loginInfodic objectForKey:@"avatar" ]]]]];
            }

            headerImgView.layer.masksToBounds=YES;
            headerImgView.layer.cornerRadius= 5;
            
            UILabel*nameLab= (UILabel*)[cell viewWithTag:9000];
            nameLab.text=[loginInfodic objectForKey:@"nodeName"];
            nameLab.textColor=RGB(255, 255, 255, 1);

            UILabel*contentLab= (UILabel*)[cell viewWithTag:9001];
            
            contentLab.text=[NSString stringWithFormat:@"编号：%@",[loginInfodic objectForKey:@"nodeCode"]];
            contentLab.textColor=RGB(238, 238, 238, 1);

        }

    }
    
    
    return cell;
}



@end
