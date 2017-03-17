//
//  SolarSubView.m
//  XXProjectNew
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "SolarSubView.h"
#import "UICountingLabel.h"
#import "JTNumberScrollAnimatedView.h"
#import "ADTickerLabel.h"

@interface SolarSubView()


@end

@implementation SolarSubView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeForView];
    }
    return self;
}


-(UILabel*)unit_label{
    
    
    if (!_unit_label) {
        
        
        UILabel* label = [UILabel new];
    
        _unit_label = label;
        
        [self addSubview:label];
        
    }
    
    return _unit_label;
    
}


-(JTNumberScrollAnimatedView*)numView{
    
    if (!_numView) {
        
        JTNumberScrollAnimatedView* n = [JTNumberScrollAnimatedView new];
        
        _numView = n;
        
        [self addSubview:n];
    }
    
    return _numView;

    
    
}

-(UICountingLabel*)numLabel{
    
    
    if (!_numLabel) {
        
        UICountingLabel* label = [UICountingLabel new];
        
        _numLabel = label;
        
        [self addSubview:label];
    }
    
    return _numLabel;
    
}


-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        
        UIImageView* imgV = [UIImageView new];
        
        _imageView = imgV;
        
        [self addSubview:imgV];
    }
    
    
    return _imageView;
    
    
}
-(UIButton*)des_btn{
    
    
    if (!_des_btn) {
        
        
        UIButton* btn = [UIButton new];
        
        _des_btn = btn;
        
        [self addSubview:btn];
    }
    
    
    return _des_btn;
}


-(void)initializeForView{
    
    [self setupUI];
    
//    self.title.format = @"1000000万";
    
    self.numLabel.font = [UIFont systemFontOfSize:16];
    
    self.unit_label.font = [UIFont systemFontOfSize:13];
    
    self.unit_label.textColor = [UIColor whiteColor];
    

    self.numLabel.textColor = [UIColor whiteColor];
    
    self.des_btn.imageView.frame = CGRectMake(0, 0, 50, 50);
    
    self.des_btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.des_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 10;
    
}



-(ADTickerLabel*)num_label{
    
    
    if (!_num_label) {
        
        ADTickerLabel* label  = [ADTickerLabel new];
        
        [self addSubview:label];
        
        _num_label =label;

        
    }

    return  nil;
    
    
}

-(UIImageView*)backgroudImgView{
    
    if (!_backgroudImgView) {
        
        UIImageView* imgV = [UIImageView new];
        
        _backgroudImgView = imgV;
        
//        imgV.contentMode = UIViewContentModeScal;
        
        [self addSubview:imgV];
    }
    
    return _backgroudImgView;
}

-(void)setupUI{
    
    
    [self.backgroudImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        
        make.size.equalTo(self);
    }];
    
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.des_btn.mas_bottom).offset(5);
        make.left.equalTo(_des_btn);
        
    }];
    
    
    
    self.numView.frame = CGRectMake(10, 30, 100, 20);
    
//    self.numView.backgroundColor = [UIColor redColor];
    self.numView.minLength = 1;
    self.numView.textColor = [UIColor whiteColor];
    self.numView.font = [UIFont systemFontOfSize:15];
    

    [self.numView setValue:@1000];

    [self.numView startAnimation];
    

    
//    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.des_btn.mas_bottom).offset(5);
//        make.left.equalTo(_des_btn);
//        make.size.mas_equalTo(CGSizeMake(100, 20));
//        
//    }];
    

    
    [self.unit_label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.numView.mas_right).offset(5);
        
//        make.left.equalTo(self.numLabel.mas_right);
        
//        make.centerY.equalTo(self.numLabel);
        
        make.centerY.equalTo(self.numView);
        
    }];
    
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(10);
        
          make.top.equalTo(self).offset(10);
        
        make.size.mas_equalTo(CGSizeMake(15, 15));
        
        
        
    }];
    
    [self.des_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.equalTo(self).offset(25).priorityLow;

//        make.center.equalTo(self.imageView);
        
        make.top.equalTo(self).offset(5);
        
        make.left.equalTo(self).offset(25);
        

        
    }];
    

    

    
    self.num_label.backgroundColor = [UIColor whiteColor];
    
    self.num_label.textColor = [UIColor blackColor];
    
//    self.num_label.text = @"0";
    
    self.num_label.animationDuration = 2;
    
    self.num_label.scrollDirection = ADTickerLabelScrollDirectionUp;
    
    
    
    
    [self.num_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        
        make.left.equalTo(self).offset(10);
        
        make.right.equalTo(self).offset(-10);
        
        make.top.equalTo(self).offset(10);
        
    }];
    
    
    
    
}


@end
