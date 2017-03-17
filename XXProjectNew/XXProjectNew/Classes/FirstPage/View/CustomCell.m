//
//  CustomCell.m
//  XXProjectNew
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define NUM 4

#import "CustomCell.h"
#define thirdCellHeight   0.0885*screenHeight
@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [self setupSeparate_Line];

}

-(void)setupSeparate_Line{
    
    self.separate_line = [[UIView alloc]initWithFrame:CGRectMake(0, thirdCellHeight - 0.25, screenWidth, 0.5)];
    
    _separate_line.backgroundColor = [UIColor lightGrayColor];
    
    self.separate_line.hidden = true;
    
    [self addSubview:_separate_line];

    
}





//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        
//        
//    }
//    return self;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath arr:(NSArray*)arr{
    
    NSLog(@"---secton==%ld===row==%ld",(long)indexPath.section,(long)indexPath.row);
    NSString *identifier = @"";//对应xib中设置的identifier
    switch (indexPath.section) {
            case 0:
            identifier=@"TempTableViewCellFirst";
            break;
            
        case 1:
            identifier = @"TempTableViewCellSecond";
            break;
        case 2:
            identifier = @"TempTableViewCellThird";
            break;
       
            
        default:
            break;
    }
   
    
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    cell.backgroundColor=[UIColor whiteColor];

           if (!cell) {
               int rowq=indexPath.row;
               int sec=indexPath.section;
              cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil] objectAtIndex:indexPath.section];

       
               
        }
   
    if (indexPath.section==2) {
        UILabel*contentLab=[[UILabel alloc]init];
        contentLab.tag=5566;
        [cell addSubview:contentLab];

        
    }

    
     return cell;
    
}
//-(void)rankClick:(UIButton*)sender
//{
//    self.rankPress(sender.tag);
//}

//- (void)drawRect:(CGRect)rect
//{
//    
//    if (self.isLast) {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    
//        
//        //下分割线
//        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//        CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
//        
//    }
//    //上分割线，
////    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
////    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
//    
//}



@end
