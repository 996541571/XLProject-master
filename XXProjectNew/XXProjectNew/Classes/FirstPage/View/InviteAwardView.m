//
//  InviteAwardView.m
//  XXProjectNew
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "InviteAwardView.h"

@implementation InviteAwardView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.check.layer.cornerRadius = 20.f;
    self.check.clipsToBounds = YES;
}
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (touch.view == self.bgView) {
            return;
        }
    }
    [self removeFromSuperview];
}
+(instancetype)awardView
{
    return [[NSBundle mainBundle] loadNibNamed:@"InviteAwardView" owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
