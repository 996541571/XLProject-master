//
//  StationAgentCell.m
//  XXProjectNew
//
//  Created by apple on 2016/11/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "StationAgentCell.h"
#define thirdCellHeight   0.0885*screenHeight

@implementation StationAgentCell

-(UIImageView*)icon_imgV{
    
    if (!_icon_imgV) {
        
        
        UIImageView* imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invite_default_icon"]];
        
        [self.contentView addSubview:imgV];
        
        self.icon_imgV = imgV;
        
        [self.icon_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView);
            
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
            
            make.right.equalTo(self.contentView).offset(0);
            
        }];
        

        
        
    }
    
    
    return _icon_imgV;
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupSeparate_Line];
    
    [self setupUI];

}

-(void)setupUI{
    
    
    self.spot.layer.cornerRadius = 6;
    

    
    UILabel* log_label = [UILabel new];
    
    self.log_label  = log_label;
    
    log_label.hidden = YES;
    
    //        [self.logLabel_arr addObject:log_label];
    
    
    log_label.font = [UIFont systemFontOfSize:13];
    
    log_label.textColor = RGB(140, 140, 140, 1);
    
    log_label.numberOfLines = 0 ;
    
    log_label.lineBreakMode = NSLineBreakByCharWrapping;
    
    [self.contentView addSubview:log_label];
    
    
    [log_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(5);
        
        make.left.equalTo(self).offset(50);
        
        make.right.equalTo(self).offset(-20);
        
    }];

    
    
    

    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)setupSeparate_Line{
    
//    self.separate_line = [[UIView alloc]initWithFrame:CGRectMake(0, thirdCellHeight - 0.25, screenWidth, 0.5)];
    
    
    
    self.separate_line = [[UIView alloc]init];
    
    _separate_line.backgroundColor = RGB(218, 218, 218, 1);
    
    self.separate_line.hidden = true;
    
    [self addSubview:_separate_line];
    
    [self.separate_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@0.5);
        
        make.bottom.equalTo(self.contentView);
        
        make.width.mas_equalTo(screenWidth);
        
        make.left.equalTo(self.contentView).offset(15);
        
        
        
    }];

    
}




-(void)setLogStr:(NSString *)logStr{
    
    
    self.log_label.hidden = NO;
    
    self.log_label.text = logStr;
    
    
}






@end
