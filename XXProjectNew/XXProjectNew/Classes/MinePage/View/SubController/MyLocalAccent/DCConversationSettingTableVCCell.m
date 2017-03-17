//
//  DCConversationSettingTableVCCell.m
//  XXProjectNew
//
//  Created by apple on 1/5/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DCConversationSettingTableVCCell.h"

@implementation DCConversationSettingTableVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UILabel*)cell_label{
    
    
    if (!_cell_label) {
        
        
        UILabel* temp = [UILabel new];
        
        temp.textColor = title_Color;
        
        [self addSubview:temp];
        
        _cell_label = temp;
        
    }
    
    
    return _cell_label;
}


-(UISwitch*)cell_switch{
    
    
    if (!_cell_switch) {
        
        
        UISwitch* temp = [UISwitch new];
        
        [self addSubview:temp];
        
        _cell_switch = temp;
        
    }
    
    
    return _cell_switch;
}

-(UIImageView *)head_imgV{
    
    
    if (!_head_imgV) {
        
        
        UIImageView* temp = [UIImageView new];
        
        [self addSubview:temp];
        
        _head_imgV = temp;
        
    }
    
    
    return _head_imgV;
}


-(UILabel*)detail_label{
    
    
    if (!_detail_label) {
        
        

        
        UILabel* temp = [UILabel new];
        
        temp.textColor = text_Color;
        
        [self addSubview:temp];
        
        _detail_label = temp;
        
    }
    
    
    return _detail_label;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    [self setup];
    
   return  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
}

-(void)setup{
    
    
}


-(void)setCellType:(cellType)cellType{
    
    _cellType = cellType;
    
    if (cellType == 0) {
        
        self.cell_label.font = [UIFont systemFontOfSize:15];
        
        [self.cell_label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);

        }];
        
        
        [self.cell_switch mas_makeConstraints:^(MASConstraintMaker *make) {
           
            
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);

        }];
        
        
    }else if(cellType == 1){
         self.cell_label.font = [UIFont systemFontOfSize:15];
        
        [self.cell_label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //用contentView 有问题
            make.center.equalTo(self);
            
        }];

        
        
        
    }else{
        
        //headV
        
        self.head_imgV.image = [UIImage imageNamed:@"Mine_defaultIcon"];
        
        self.head_imgV.layer.cornerRadius = 25;
        
        self.head_imgV.clipsToBounds = YES;
        
        [self.head_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.height.width.equalTo(self.mas_height).offset(-30);

            
        }];
        
//        self.head_imgV.backgroundColor = [UIColor redColor];
        
        
        //label
        [self.cell_label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self).offset(-10);
            
            make.left.equalTo(self.head_imgV.mas_right).offset(10);
            
            make.width.lessThanOrEqualTo(@100);

        }];
        
        
        
        //detail
        
        self.detail_label.font = [UIFont systemFontOfSize:12];
        
        [self.detail_label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.head_imgV.mas_right).offset(10);

            make.top.equalTo(self.cell_label.mas_bottom).offset(5);
            
            make.width.lessThanOrEqualTo(@200);
            
        }];
        
        
        //
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        
        
        
    }
    
    

    
    
}

    
    
    


    
    
    





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
