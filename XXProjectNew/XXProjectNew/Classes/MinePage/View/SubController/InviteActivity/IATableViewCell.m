//
//  IATableViewCell.m
//  XXProjectNew
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "IATableViewCell.h"
#import "InviteActivityModel.h"

@implementation IATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}


-(NSArray*)fontIcon_arr{
    
    
    if (!_fontIcon_arr) {
        

        _fontIcon_arr = @[@"invite_champion_icon",@"invite_runnerup_icon",@"invite_thirdPlace_icon"];
        
    }
    
    
    return _fontIcon_arr;
}



-(void)setup{
    
    
    self.prize_label.textColor = title_Color;
    
    self.name_label.textColor = title_Color;
    
    self.rankNum_label.textColor = title_Color;
    
    self.head_icon.layer.cornerRadius = self.head_icon.frame.size.width/2.0;
    
    self.head_icon.clipsToBounds = YES;
    
}

-(void)setCellModel:(InviteActivityModel *)cellModel{
    
    _cellModel = cellModel;
    
    [self.head_icon sd_setImageWithURL:[NSURL URLWithString:cellModel.headImg]];
    
    if (!cellModel.headImg.length) {
        
        self.head_icon.image = [UIImage imageNamed:@"invite_default_icon"];

    }
    self.name_label.text = cellModel.commentName;
    
    self.rankNum_label.text = [NSString stringWithFormat:@"%d",[cellModel.ranking intValue]];
    
    
    if ([self.rankNum_label.text integerValue] < 4 && [self.rankNum_label.text integerValue] != 0 ) {
        
        self.Font_icon.image = [UIImage imageNamed:self.fontIcon_arr[[self.rankNum_label.text integerValue] - 1]];
        
    }else{
        
        
        self.Font_icon.image = nil;
        
        
    }

    
    self.prize_label.text = [NSString stringWithFormat:@"已获得%.1lf元",[cellModel.recAmtStr floatValue]];
    
    [self LabelFactory:self.prize_label.text andLabel:self.prize_label];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)LabelFactory:(NSString*)text andLabel:(UILabel*)label{
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//     
//                          value:[UIColor redColor]
//     
//                          range:NSMakeRange(3, text.length - 1)];
    
    [AttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}
                           range:NSMakeRange(3, label.text.length - 3)];
    
    
    label.attributedText = AttributedStr;
    
    
    
}


@end
