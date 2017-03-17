//
//  SolarSubView.h
//  XXProjectNew
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADTickerLabel;
@class JTNumberScrollAnimatedView;
@class UICountingLabel;
@interface SolarSubView : UIView
@property(nonatomic,weak)UICountingLabel* numLabel;
@property(nonatomic,weak)UILabel* unit_label;
@property(nonatomic,weak)UIButton* des_btn;
@property(nonatomic,weak)UIImageView* backgroudImgView;
@property(nonatomic,weak)JTNumberScrollAnimatedView* numView;
@property(nonatomic,weak)ADTickerLabel* num_label;
@property(nonatomic,weak)UIImageView * imageView;

@end
