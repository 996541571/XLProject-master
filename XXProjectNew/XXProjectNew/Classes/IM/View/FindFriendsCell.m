//
//  FindFriendsCell.m
//  XXProjectNew
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "FindFriendsCell.h"
@interface FindFriendsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UIButton *followStatus;

@end
@implementation FindFriendsCell
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_icon sd_setImageWithURL:[NSURL URLWithString:dataDic[@"headImg"]] placeholderImage:[UIImage imageNamed:@"Mine_defaultIcon"]];
    if (dataDic[@"nikerName"] == nil || [dataDic[@"nikerName"] isEqualToString:@""]) {
        _name.text = @"无昵称";
    } else {
        _name.text = dataDic[@"nikerName"];
    }
    if (_isFan) {
        _fans.text = [NSString stringWithFormat:@"粉丝：%@",dataDic[@"fansNumbers"]];
    } else {
        if (dataDic[@"introduce"] && [dataDic[@"introduce"] length]) {
            _fans.text = dataDic[@"introduce"];
        }else{
            _fans.text = @"暂无介绍";
        }
    }
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _icon.layer.cornerRadius = 25.f;
    _icon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
