//
//  MineHeadView.h
//  XXProjectNew
//
//  Created by apple on 11/28/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MineHeadView : UIView

#define double_btn_hight (50)

@property(nonatomic,weak)UIImageView* headimgV;
@property(nonatomic,weak)UILabel* signature;
@property(nonatomic,weak)UIButton* alias;
@property(nonatomic,assign)identity user;
@property(nonatomic,strong)UIImageView* gender_imgV;
@property(nonatomic,weak)UIButton* left_btn;
@property(nonatomic,weak)UIButton* right_btn;
@property(nonatomic,strong)UILabel *btn_right_text;
@property(nonatomic,strong)UILabel *btn_left_text;
@property(nonatomic,strong)UIView *dot;

@property(nonatomic,weak)UIView* container;


@end
