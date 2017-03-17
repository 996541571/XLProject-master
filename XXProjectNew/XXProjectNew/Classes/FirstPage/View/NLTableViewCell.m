//
//  NLTableViewCell.m
//  XXProjectNew
//
//  Created by apple on 11/24/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "NLTableViewCell.h"
#import "NewsListPageModel.h"

@interface NLTableViewCell()



@end

@implementation NLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setup];
    
}




-(void)setup{
    
    
    self.title_lable.textColor = title_Color;
    
    self.source_label.textColor = text_Color;
    
    self.time_label.textColor = text_Color;
    
    self.insideView.layer.cornerRadius = 3;
    
    self.insideView.layer.borderWidth = 0.5;
    
    self.insideView.layer.borderColor = RGB(203, 204, 205, 1).CGColor;
    
    
    self.title_lable.numberOfLines = 2;

    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    // Configure the view for the selected state
}


-(void)setModel:(NewsListPageModel *)model{
    
    _model = model;
    
    self.title_lable.text = model.msgTitle;
    
    self.time_label.text = model.updateTime;
    
    self.source_label.text = model.msgSource;
    
    
    
    if (model.titleImg) {
        
        self.imgView.hidden = NO;
        
        self.title_trailing_constraint.constant = 90;
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.titleImg]];
        
    }else{
        
        self.imgView.hidden = YES;

        self.title_trailing_constraint.constant = 13;
        
        
    }
    
    
    
}




@end
