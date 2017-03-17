//
//  DVRewardAndFlowerCell.m
//  XXProjectNew
//
//  Created by apple on 16/11/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "DVRewardAndFlowerCell.h"
@interface DVRewardAndFlowerCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon_imgV;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;

@end
@implementation DVRewardAndFlowerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
//    
//    self.table.backgroundColor=RGB(233,233,233,1.0f);
//    
//    noDataImageView=[[UIImageView alloc]init];
//    //    noDataImageView.bounds=CGRectMake(0, 0, 291/3, 378/3);
//    //    noDataImageView.center=self.table.center;
//    noDataImageView.frame=CGRectMake(screenWidth/2-291/6, 100, 291/3, 378/3);
//    //    noDataImageView.backgroundColor=[UIColor redColor];
//    noDataImageView.image=[UIImage imageNamed:@"nodata"];
//    nodataLab=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-291/6, 100+378/3+50, 291/3, 40)];
//    nodataLab.text=@"暂无数据";
//    nodataLab.textColor=[UIColor lightGrayColor];
//    nodataLab.textAlignment=NSTextAlignmentCenter;
//    nodataLab.font=[UIFont systemFontOfSize:16];
//
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(NSDictionary *)model{
    
    _model = model;
    
    if (model) {
        
        
        self.name_label.text = [model valueForKey:@"nodeName"];
        
//        self.time_label.text = [model valueForKey:@"sendDate"];
        
           NSString* str  = [model valueForKey:@"sendDate"];
        
        
        NSString* str2 =  [str substringWithRange:NSMakeRange(0, 5)];
        
        NSString* str3 = [str substringWithRange:NSMakeRange(5,5)];
        
        NSString* str4 = [str substringWithRange:NSMakeRange(10, str.length -str2.length-str3.length)];
        
        str2 =  [str2 stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
        str3 = [str3 stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
        
        self.time_label.text = [NSString stringWithFormat:@"%@%@日%@",str2,str3,str4];
        
        
        
        
    }
    
    
    
}



-(void)setKind:(Kind)kind{
    _kind = kind;
    
    self.icon_imgV.image =  kind == KindFlower ? [UIImage imageNamed:@"flower_icon"]:[UIImage imageNamed:@"reward_icon"];
    
    //默认
    self.time_label.text = @"1000";
    self.name_label.text = @"暂无数据";
    
    
}


@end
