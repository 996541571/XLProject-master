//
//  MineHeadView.m
//  XXProjectNew
//
//  Created by apple on 11/28/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "MineHeadView.h"
#import "StationAgentViewModel.h"
#import "StationAgentModel.h"

@interface MineHeadView()
@property(nonatomic,weak)UIImageView* backgroundView;
@end

@implementation MineHeadView

-(UIImageView*)headimgV{
    
    
    if (!_headimgV) {
        
        
        UIImageView* imgV = [UIImageView new];
        
        imgV.userInteractionEnabled = YES;
        
        [self addSubview:imgV];
        
        _headimgV = imgV;
        
    }
    
    
    return _headimgV;
}



-(UIImageView*)gender_imgV{
    
    
    if (!_gender_imgV) {
        
        
        UIImageView* temp = [UIImageView new];
        
        [self addSubview:temp];
        
        _gender_imgV = temp;
        
    }
    
    
    return _gender_imgV;
}


-(UILabel*)signature{
    
    
    if (!_signature) {
        
        
        UILabel* temp = [UILabel new];
        
        [self addSubview:temp];
        
        _signature = temp;
        
    }
    
    
    return _signature;
}



-(UIButton*)alias{
    
    
    if (!_alias) {
        
        
        DVButton* temp = [DVButton new];
        
        [self addSubview:temp];
        
        [_alias mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headimgV.mas_bottom).offset(20);
            
            make.centerX.equalTo(self.headimgV);
            
            
        }];
        
        
        
        
        _alias = temp;
        
    }
    
    return _alias;
}


-(UIImageView*)backgroundView{
    
    
    if (!_backgroundView) {
        
        
        UIImageView* temp = [UIImageView new];
        
        [self addSubview:temp];
        
        _backgroundView = temp;
        
    }
    
    
    return _backgroundView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(246, 246, 246, 1);
        [self setup];
        
    }
    return self;
}



-(void)setup{
    
    //设置背景
    
    UIImageView* backgroudimgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_topBackgroud_new"]];
    
    [self addSubview:backgroudimgV];
    
    self.backgroundView = backgroudimgV;
    
    [backgroudimgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        
//        make.bottom.equalTo(self).offset(-double_btn_hight);
        
        make.height.equalTo(@((screenWidth/(1082/642.0))));
        
//        make.height.equalTo(@200);
        
        
    }];
    
    
    
    
    //底线
    UIView* separate_line = [UIView  new];
    
    [self addSubview:separate_line];
    
    separate_line.backgroundColor = RGB(220, 220, 220, 1);
    
    [separate_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@0.6);
        
        make.bottom.equalTo(self);
        
        make.width.mas_equalTo(screenWidth);
        
        
        
    }];
    

    
    
    //身份判别
    
    self.user = [MinePageViewModel model].user;
    


    
    
    //头像
    
#define headRound_diameter (60*(screenWidth/320))
    
    
    self.headimgV.image = [UIImage imageNamed:@"Mine_defaultIcon"];
    
    self.headimgV.layer.cornerRadius = headRound_diameter/2;
    
    self.headimgV.clipsToBounds = YES;
    
    self.headimgV.backgroundColor = [UIColor whiteColor];
    
    [self.headimgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        
        make.centerY.equalTo(backgroudimgV).offset(0);
//         make.centerY.equalTo(self).offset(-4-double_btn_hight/2);
        
        make.size.mas_equalTo(CGSizeMake(headRound_diameter,headRound_diameter));
        
    }];
    
    
    
    //alias
    
    self.alias.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.alias setTitleColor:RGB(118, 118, 118, 1) forState:UIControlStateNormal];
    
    [self.alias setTitleColor:RGB(118, 118, 118, 0.3) forState:UIControlStateHighlighted];

    
    //gender_imgV
    
//    self.gender_imgV.image = [UIImage imageNamed:@"girl_icon"];
    
    [self.gender_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.alias);
        
        make.left.equalTo(self.alias.mas_right).offset(5);
        
    }];
    
    
    
    //signature
    
    
    self.signature.font = [UIFont systemFontOfSize:13];
    
    self.signature.textColor = RGB(165, 165, 165, 1);
    
    [self.signature mas_makeConstraints:^(MASConstraintMaker *make) {
        if (screenWidth > 375 && self.user == 2) {
            
            make.top.equalTo(self.alias.mas_bottom).offset(-5);
        } else {
            make.top.equalTo(self.alias.mas_bottom).offset(5);
        }
        
         make.centerX.equalTo(self.headimgV);
        
    }];
    
    
    
    //double_btn
    
    
    
    UIView* container = [UIView new];
    
    container.backgroundColor = RGB(245, 246, 247, 1);
    
    [self addSubview:container];
    
    self.container = container;
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(self);
        
        make.height.equalTo(@(double_btn_hight));
        
        make.left.right.equalTo(self);
        
        make.top.equalTo(backgroudimgV.mas_bottom);
        
        
    }];
    
    
    
    UIButton* btn_left = [UIButton new];
    btn_left.backgroundColor = [UIColor clearColor];
    self.left_btn = btn_left;

    btn_left.tag = 0;
    
    [container addSubview:btn_left];
    
    [btn_left mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@100);
        make.centerX.equalTo(container).multipliedBy(0.5);
        make.bottom.equalTo(container).offset(-10);
        make.top.equalTo(container).offset(10);
        
        
        
    }];
    
    
    UILabel* label_left_text = [UILabel labelWithText:@"" andColor:RGB(51, 51, 51, 1) andFontSize:13 andSuperview:btn_left];
    self.btn_left_text = label_left_text;
    [label_left_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn_left).offset(-10);
        make.centerX.equalTo(btn_left);
    }];
    
    UILabel* label_left_num = [UILabel labelWithText:@"关注" andColor:RGB(153, 153, 153, 1) andFontSize:13 andSuperview:btn_left];
    
    [label_left_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn_left).offset(10);
        make.centerX.equalTo(btn_left);
    }];

    
    //----
    
    
    
    UIButton* btn_right = [UIButton new];
    
    btn_right.backgroundColor = [UIColor clearColor];
    self.right_btn = btn_right;
    
    btn_right.tag = 1;
    
//    [btn_right addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:btn_right];
    
    [btn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@100);
        make.centerX.equalTo(container).multipliedBy(1.5);
        make.bottom.equalTo(container).offset(-10);
        make.top.equalTo(container).offset(10);

        
    }];
    
    
    UILabel* btn_right_text = [UILabel labelWithText:@"" andColor:title_Color andFontSize:13 andSuperview:container];
    self.btn_right_text =  btn_right_text;
    [btn_right_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn_right).offset(-10);
        make.centerX.equalTo(btn_right);
    }];
    
    UILabel* btn_right_num = [UILabel labelWithText:@"粉丝" andColor:RGB(153, 153, 153, 1) andFontSize:13 andSuperview:btn_right];
    
    [btn_right_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn_right).offset(10);
        make.centerX.equalTo(btn_right);
    }];
    
    
    self.dot = [[UIView alloc]init];
    _dot.backgroundColor = [UIColor redColor];
    _dot.layer.cornerRadius = 3.f;
    _dot.clipsToBounds = YES;
//    _dot.hidden = YES;
    [self.container addSubview:_dot];
    [_dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn_right.mas_top);
        make.right.equalTo(self.mas_right).offset(-52);
        make.height.width.equalTo(@6);
    }];
    ///
    
    self.backgroundColor = [UIColor whiteColor];
    
}


-(void)setUser:(identity)user{
    
    
    _user = user;
    
    // 数据更新---------成功才走
    // 我的页面每次展现就调用
    if (self.user != visitor) {
        
//        //头像根系
//        
        [self.headimgV mas_updateConstraints:^(MASConstraintMaker *make) {
            
//            make.centerX.equalTo(self);
            
            make.centerY.equalTo(self.backgroundView).offset(-4);
            
//            make.size.mas_equalTo(CGSizeMake(headRound_diameter,headRound_diameter));
            
        }];

        
        
        
        [[StationAgentViewModel model] obtainWebDataWithSuccess:^{
            
            //头像
            
            NSURL *url = [NSURL URLWithString:[StationAgentViewModel model].dataModel.headImg];
            
            if (url || [StationAgentViewModel model].dataModel.headImg.length) {
                
                [self.headimgV sd_setImageWithURL:url];
                
            }
            
            
            self.btn_right_text.text = [NSString stringWithFormat: @"%@",[StationAgentViewModel model].dataModel.fansNumber];
            
            self.btn_left_text.text = [NSString stringWithFormat: @"%@",[StationAgentViewModel model].dataModel.followsNumber];

            
            //如果有性别
            
            if ([StationAgentViewModel model].dataModel.sex.length && ![[StationAgentViewModel model].dataModel.sex isEqualToString:@"请设置性别"]){
                
                
                if ([[StationAgentViewModel model].dataModel.sex isEqualToString:@"男"]) {
                    
                    self.gender_imgV.image = [UIImage imageNamed:@"boy_icon"];
                    
                }else{
                    
                    
                    self.gender_imgV.image = [UIImage imageNamed:@"girl_icon"];
                    
                }
                
                
            }else{
                
                
//                [self.gender_imgV removeFromSuperview];
                
                self.gender_imgV.image = nil;
                
            }
            
            
            
            
            
            if(self.user == administrator){
                //如果是站长
                
                NSDictionary*proactiveLoginDic =  [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
                
                
                NSString* nodeName = [proactiveLoginDic valueForKey:@"nodeName"];
                
                NSString* nodeManagerPartyId = [proactiveLoginDic valueForKey:@"nodeManagerPartyId"];
                
                self.signature.text = @"河马村河姆渡";
                
                //如果没有设置昵称
                if ([[StationAgentViewModel model].dataModel.nikerName  isEqualToString:@"请设置昵称"]) {
                    
                    [self.alias setTitle:nodeName forState:UIControlStateNormal];
                    
                    self.signature.text = [NSString stringWithFormat:@"小站编号:%@",nodeManagerPartyId];
                    

                    
                    
                }else{
                    
                    [self.alias setTitle:[StationAgentViewModel model].dataModel.nikerName forState:UIControlStateNormal];
                    
                    self.signature.text = nodeName;
                    
                }
                
                

                
            }else{
                
                //如果是村民
                
                [self.alias setTitle:[StationAgentViewModel model].dataModel.nikerName forState:UIControlStateNormal];
                
                self.signature.text = [StationAgentViewModel model].dataModel.introduce;
                
                //如果有个性签名
                if (self.signature.text.length && ![self.signature.text isEqualToString:@"用一句话来介绍你自己"]) {
                    
                    self.signature.hidden = NO;
                    
                    [self.alias mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(self.headimgV.mas_bottom).offset(8);
                        
                        make.centerX.equalTo(self.headimgV).offset(-5);
                        
                    }];
                    
                }else{
                    self.signature.hidden = YES;
                    
                    [self.alias mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(self.headimgV.mas_bottom).offset(20);
                        
                        make.centerX.equalTo(self.headimgV).offset(-5);
                        
                    }];
                    
                    
                    
                    
                }
            }
            

            
            
        } andFinished:nil];
        
    }
        
        
        
    
    
    
    
    
    //其他需要更新的信息
    
    if (self.user == visitor) {
        
        [self.alias setTitle:@"请点击登录" forState:UIControlStateNormal];
        
        self.signature.hidden = YES;
        
        [self.alias mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headimgV.mas_bottom).offset(20);
        
            make.centerX.equalTo(self.headimgV);

            
            
        }];

        
        
        
    } else if(self.user == villager) {
        
//        self.signature.hidden = NO;
//        
//        [self.alias mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.headimgV.mas_bottom).offset(8);
//            
//            make.centerX.equalTo(self.headimgV);
//
//            
//        }];

        
        
    } else if(self.user == administrator){

//        [self.alias setTitle:@"网点编号" forState:UIControlStateNormal];

        self.signature.hidden = NO;
        
        
        [self.alias mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headimgV.mas_bottom).offset(8);
            
            make.centerX.equalTo(self.headimgV).offset(-5);

            
        }];

        
        
    }
    
    
    
    
    
}


//-(void)btnDidClick:(UIButton*)btn{
//    
//    NSLog(@"%td",btn.tag);
//    
//    MyFollowController* VC= [MyFollowController new];
//    
//    
//    
//    VC.type = btn.tag;
//    
//}


@end
