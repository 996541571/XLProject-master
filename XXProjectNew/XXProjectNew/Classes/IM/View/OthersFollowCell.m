//
//  OthersFollowCell.m
//  XXProjectNew
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "OthersFollowCell.h"
@interface OthersFollowCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property(nonatomic,strong)DVButton *followBtn;
@end
@implementation OthersFollowCell

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_icon sd_setImageWithURL:[NSURL URLWithString:dataDic[@"headImg"]] placeholderImage:[UIImage imageNamed:@"Mine_defaultIcon"]];
    _name.text = dataDic[@"nikerName"];
    if (dataDic[@"introduce"] && [dataDic[@"introduce"] length]) {
        _introduce.text = dataDic[@"introduce"];
    }else{
        _introduce.text = @"暂无介绍";
    }
    if ([dataDic[@"partyId"] isEqual:ManagerPartyId]) {
        _followBtn.hidden = YES;
    } else {
        _followBtn.hidden = NO;
    }
    if ([dataDic[@"bothStatus"] isEqualToString:@"BOTH"]) {
        [self setFollowWithTitle:@"互相关注" image:@"Both"];
        
    }else if ([dataDic[@"bothStatus"] isEqualToString:@"FOLLOW"]){
        [self setFollowWithTitle:@"已关注" image:@"Followed"];
    }else {
        _followBtn.enabled = YES;
        [self setFollowWithTitle:@"加关注" image:@"addF"];
        [_followBtn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    }

}

-(void)setFollowWithTitle:(NSString *)title image:(NSString *)image
{
    [_followBtn setTitle:title forState:UIControlStateNormal];
    [_followBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if ([title isEqualToString:@"加关注"]) {
        [_followBtn setTitleColor:RGB(47, 150, 255, 1) forState:UIControlStateNormal];
    }else{
        [_followBtn setTitleColor:RGB(153, 153, 153, 1) forState:UIControlStateNormal];
    }
}

-(void)follow:(UIButton *)sender
{
    NSArray *params = @[@{@"toPartyId":_dataDic[@"partyId"],@"fromPartyId":ManagerPartyId,@"bothStatus":@"FOLLOW"}];
    [NetRequest requetWithParams:params requestName:@"UserRelationService.follow" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            sender.enabled = NO;
            if ([responseDicionary[@"result"] isEqualToString:@"FOLLOW"]) {
                [self setFollowWithTitle:@"已关注" image:@"Followed"];
            }else if ([responseDicionary[@"result"] isEqualToString:@"BOTH"]){
                [self setFollowWithTitle:@"互相关注" image:@"Both"];
            }
            self.block(_row,responseDicionary[@"result"]);
            
        }
    }];
}
-(void)setBlock:(OthersFollowBlock)block
{
    _block = block;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _icon.layer.cornerRadius = 25.f;
    _icon.clipsToBounds = YES;
    _followBtn = [DVButton buttonWithText:@"" andColor:RGB(170, 170, 170, 1) andFontSize:10 andSuperview:self.contentView andType:BtnTypeDown andCustomimgBounds:CGRectMake(0, 0, 18, 20)];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(42, 45));
        
    }];
    _followBtn.enabled = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end