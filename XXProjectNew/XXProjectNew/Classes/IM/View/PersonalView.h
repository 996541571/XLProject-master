//
//  PersonalView.h
//  XXProjectNew
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalView : UIView
@property(nonatomic,strong)UIImageView *icon;//头像
@property(nonatomic,strong)UILabel *nikerName;//昵称
@property(nonatomic,strong)UIImageView *genderIV;//性别
@property(nonatomic,strong)UILabel *introduction;//简介
@property(nonatomic,strong)UIButton *follow;//关注
@property(nonatomic,strong)UILabel *followCount;//关注数量
@property(nonatomic,strong)UIButton *fan;//粉丝
@property(nonatomic,strong)UILabel *fanCount;//粉丝数量
@end
