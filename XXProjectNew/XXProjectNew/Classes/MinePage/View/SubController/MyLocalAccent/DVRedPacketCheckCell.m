//
//  DVRedPacketCheckCell.m
//  XXProjectNew
//
//  Created by apple on 1/12/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DVRedPacketCheckCell.h"

@implementation DVRedPacketCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconhead_imgV.layer.cornerRadius  = 15;
    
    self.iconhead_imgV.clipsToBounds = YES;
    
    
    self.selectionStyle = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
