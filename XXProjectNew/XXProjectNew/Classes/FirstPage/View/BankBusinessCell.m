//
//  BankBusinessCell.m
//  XXProjectNew
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "BankBusinessCell.h"
#import "RankModel.h"
@interface BankBusinessCell()
@property (weak, nonatomic) IBOutlet UIButton *medal;//奖牌
@property (weak, nonatomic) IBOutlet UILabel *stationBalance;//站点余额
@property (weak, nonatomic) IBOutlet UILabel *cardCount;//开卡数量
@property (weak, nonatomic) IBOutlet UILabel *stationAgent;//站长
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end
@implementation BankBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _icon.layer.cornerRadius = 17.5f;
    _icon.clipsToBounds = YES;
}
-(void)setModel:(RankModel *)model
{
    _model = model;

    NSString *balance = [NSString stringWithFormat:@"%.2lf",model.balance];
    if ([balance rangeOfString:@"."].location != NSNotFound) {
        NSArray *arr = [balance componentsSeparatedByString:@"."];
        NSMutableString *str1 = (NSMutableString *)[self countNumAndChangeformat:arr.firstObject];
        [str1 appendString:[NSString stringWithFormat:@".%@",arr.lastObject]];
        balance = str1;
    }else{
        NSMutableString *str = (NSMutableString *)[self countNumAndChangeformat:balance];
        [str appendString:@".00"];
        balance = str;
    }
    _stationBalance.text = [NSString stringWithFormat:@"站点余额：%@元",balance];
    _cardCount.text = [NSString stringWithFormat:@"开卡数量：%ld张",model.cardCount];
    _stationAgent.text = [NSString stringWithFormat:@"%@",model.nodeName];
    [_rewardCount setTitle:[NSString stringWithFormat:@"%ld人打赏",model.rewards] forState:UIControlStateNormal];
    [_fowerCount setTitle:[NSString stringWithFormat:@"%ld人献花",model.flowers] forState:UIControlStateNormal];
    if ([[NSString stringWithFormat:@"%ld",model.mark] isEqualToString:@"-1"]) {
        [_flowerIcon setImage:[UIImage imageNamed:@"bank_flowerColor"] forState:UIControlStateNormal];
        [_fowerCount setTitleColor:blueColor forState:UIControlStateNormal];
    } else {
        [_flowerIcon setImage:[UIImage imageNamed:@"bank_flower"] forState:UIControlStateNormal];
        [_fowerCount setTitleColor:gray forState:UIControlStateNormal];
    }
    if ([[NSString stringWithFormat:@"%ld",model.rewardsMark] isEqualToString:@"-1"]) {
        [_rewordIcon setImage:[UIImage imageNamed:@"bank_rewordColor"] forState:UIControlStateNormal];
        [_rewardCount setTitleColor:blueColor forState:UIControlStateNormal];
    } else {
        [_rewordIcon setImage:[UIImage imageNamed:@"bank_reword"] forState:UIControlStateNormal];
        [_rewardCount setTitleColor:gray forState:UIControlStateNormal];
    }
    if ([[NSString stringWithFormat:@"%ld",model.balanceRank] isEqualToString:@"1"]) {
        [_medal setBackgroundImage:[UIImage imageNamed:@"bank_gold"] forState:UIControlStateNormal];
    }else if ([[NSString stringWithFormat:@"%ld",model.balanceRank] isEqualToString:@"2"]){
        [_medal setBackgroundImage:[UIImage imageNamed:@"bank_silver"] forState:UIControlStateNormal];
    }else if ([[NSString stringWithFormat:@"%ld",model.balanceRank] isEqualToString:@"3"]){
        [_medal setBackgroundImage:[UIImage imageNamed:@"bank_copper"] forState:UIControlStateNormal];
    }else{
        [_medal setTitle:[NSString stringWithFormat:@"%ld",model.balanceRank] forState:UIControlStateNormal];
    }
    if ([model.hasLogin isEqualToString:@"yes"]) {
        self.arrow.hidden = NO;
    } else {
        self.arrow.hidden = YES;
    }
    
//    if (model.headImg.length) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"invite_default_icon"]];
//    }
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString *balance = [NSString stringWithFormat:@"%.2lf",[dataDic[@"balance"] floatValue]];
    if ([balance rangeOfString:@"."].location != NSNotFound) {
        NSArray *arr = [balance componentsSeparatedByString:@"."];
        NSMutableString *str1 = (NSMutableString *)[self countNumAndChangeformat:arr.firstObject];
        [str1 appendString:[NSString stringWithFormat:@".%@",arr.lastObject]];
        balance = str1;
    }else{
        NSMutableString *str = (NSMutableString *)[self countNumAndChangeformat:balance];
        [str appendString:@".00"];
        balance = str;
    }
    _stationBalance.text = [NSString stringWithFormat:@"站点余额：%@元",balance];
    _cardCount.text = [NSString stringWithFormat:@"开卡数量：%@张",dataDic[@"cardCount"]];
    _stationAgent.text = [NSString stringWithFormat:@"%@",dataDic[@"nodeName"]];
    [_rewardCount setTitle:[NSString stringWithFormat:@"%@人打赏",dataDic[@"rewards"]] forState:UIControlStateNormal];
    [_fowerCount setTitle:[NSString stringWithFormat:@"%@人献花",dataDic[@"flowers"]] forState:UIControlStateNormal];
    if ([[NSString stringWithFormat:@"%@",dataDic[@"mark"]] isEqualToString:@"-1"]) {
        [_flowerIcon setImage:[UIImage imageNamed:@"bank_flowerColor"] forState:UIControlStateNormal];
        [_fowerCount setTitleColor:blueColor forState:UIControlStateNormal];
    } else {
        [_flowerIcon setImage:[UIImage imageNamed:@"bank_flower"] forState:UIControlStateNormal];
        [_fowerCount setTitleColor:gray forState:UIControlStateNormal];
    }
    if ([[NSString stringWithFormat:@"%@",dataDic[@"rewardsmark"]] isEqualToString:@"-1"]) {
        [_rewordIcon setImage:[UIImage imageNamed:@"bank_rewordColor"] forState:UIControlStateNormal];
        [_rewardCount setTitleColor:blueColor forState:UIControlStateNormal];
    } else {
        [_rewordIcon setImage:[UIImage imageNamed:@"bank_reword"] forState:UIControlStateNormal];
        [_rewardCount setTitleColor:gray forState:UIControlStateNormal];
    }
    if ([[NSString stringWithFormat:@"%@",dataDic[@"balanceRank"]] isEqualToString:@"1"]) {
        [_medal setBackgroundImage:[UIImage imageNamed:@"bank_gold"] forState:UIControlStateNormal];
    }else if ([[NSString stringWithFormat:@"%@",dataDic[@"balanceRank"]] isEqualToString:@"2"]){
        [_medal setBackgroundImage:[UIImage imageNamed:@"bank_silver"] forState:UIControlStateNormal];
    }else if ([[NSString stringWithFormat:@"%@",dataDic[@"balanceRank"]] isEqualToString:@"3"]){
        [_medal setBackgroundImage:[UIImage imageNamed:@"bank_copper"] forState:UIControlStateNormal];
    }else{
        [_medal setTitle:[NSString stringWithFormat:@"%@",dataDic[@"balanceRank"]] forState:UIControlStateNormal];
    }
}
    
-(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
