//
//  PersonalView.m
//  XXProjectNew
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "PersonalView.h"

@implementation PersonalView
#define BtnHeight 50.f
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(246, 246, 246, 1);
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    //背景图
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_topBackgroud"]];
    [self addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-BtnHeight - 0.6);
    }];
    
    UIView *line = [UIView new];
    [self addSubview:line];
    line.backgroundColor = RGB(220, 220, 220, 1);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.6);
    }];
 
    //头像
#define headRound_diameter (60*(screenWidth/320))
    self.icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Mine_defaultIcon"]];
    [self addSubview:self.icon];
    self.icon.layer.cornerRadius = headRound_diameter/2;
    self.icon.clipsToBounds = YES;
    self.icon.backgroundColor = [UIColor whiteColor];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-4-BtnHeight/2);
        make.size.mas_equalTo(CGSizeMake(headRound_diameter, headRound_diameter));
    }];
    
    //昵称
    self.nikerName = [UILabel new];
    [self addSubview:self.nikerName];
    self.nikerName.font = [UIFont systemFontOfSize:13];
    self.nikerName.textColor = RGB(118, 118, 118, 1);
    
    [self.nikerName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.icon.mas_bottom).offset(20);
        
        make.centerX.equalTo(self.icon).offset(-10);
    }];
    
    UIImageView* temp = [UIImageView new];
    
    [self addSubview:temp];
    
    self.genderIV = temp;
    
    [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.nikerName);
        
        make.left.equalTo(self.nikerName.mas_right).offset(5);
        
    }];
    
    //简介
    self.introduction = [UILabel new];
    [self addSubview:self.introduction];
    self.introduction.font = [UIFont systemFontOfSize:13];
    
    self.introduction.textColor = RGB(165, 165, 165, 1);
    
    [self.introduction mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (screenWidth > 375) {
        
//            make.top.equalTo(self.nikerName.mas_bottom).offset(-5);
//        } else {
            make.top.equalTo(self.nikerName.mas_bottom).offset(5);
//        }
        
        make.centerX.equalTo(self.icon);
        
    }];
    
    
    
    self.follow = [UIButton new];
    
    [self addSubview:self.follow];
    
    [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@100);
        make.centerX.equalTo(self).multipliedBy(0.5);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(bgIV.mas_bottom).offset(10);
        
    }];
    
    
    UILabel* label_left_text = [UILabel labelWithText:@"" andColor:RGB(51, 51, 51, 1) andFontSize:13 andSuperview:_follow];
    self.followCount = label_left_text;
    [label_left_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_follow).offset(-10);
        make.centerX.equalTo(_follow);
    }];
    
    UILabel* label_left_num = [UILabel labelWithText:@"关注" andColor:RGB(153, 153, 153, 1) andFontSize:13 andSuperview:_follow];
    
    [label_left_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_follow).offset(10);
        make.centerX.equalTo(_follow);
    }];
    
    UIButton* btn_right = [UIButton new];
    
    
    self.fan = btn_right;
    
    btn_right.tag = 1;
    
    [self addSubview:btn_right];
    
    [btn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@100);
        make.centerX.equalTo(self).multipliedBy(1.5);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(bgIV.mas_bottom).offset(10);
        
    }];

    UILabel* btn_right_text = [UILabel labelWithText:@"" andColor:RGB(51, 51, 51, 1) andFontSize:13 andSuperview:btn_right];
    self.fanCount = btn_right_text;
    [btn_right_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn_right).offset(-10);
        make.centerX.equalTo(btn_right);
    }];
    
    UILabel* btn_right_num = [UILabel labelWithText:@"粉丝" andColor:RGB(153, 153, 153, 1) andFontSize:13 andSuperview:btn_right];
    
    [btn_right_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn_right).offset(10);
        make.centerX.equalTo(btn_right);
    }];
    
}























/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
