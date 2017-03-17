//
//  ContactsCell.m
//  XXProjectNew
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "ContactsCell.h"
#import "ContactsModel.h"
@interface ContactsCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _icon.layer.cornerRadius = 18.f;
    _icon.clipsToBounds = YES;
}
-(void)setModel:(ContactsModel *)model
{
    _model = model;
    _nameLab.text = model.nikerName;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"Mine_defaultIcon"]];
}
+(CGFloat)rowHeight
{
    return 50.f;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
