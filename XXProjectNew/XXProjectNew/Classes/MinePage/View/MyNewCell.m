//
//  MyNewCell.m
//  XXProjectNew
//
//  Created by apple on 2016/11/15.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "MyNewCell.h"
@interface MyNewCell ()


@end
@implementation MyNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dot.layer.cornerRadius = 2;
    self.dot.clipsToBounds = YES;
    
    self.selectionStyle = 2;
    
    [self setupSeparate_Line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
