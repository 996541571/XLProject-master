//
//  NewUserView.m
//  XXProjectNew
//
//  Created by apple on 2016/10/24.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "NewUserView.h"

@implementation NewUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    _bgView.layer.cornerRadius = 5.f;
    _bgView.clipsToBounds = YES;
    _claim.layer.cornerRadius = 5.f;
    _claim.clipsToBounds = YES;
//    _content.adjustsFontSizeToFitWidth = YES;
}
+(instancetype)userView
{
    return [[NSBundle mainBundle] loadNibNamed:@"NewUserView" owner:nil options:nil].lastObject;
}
@end
