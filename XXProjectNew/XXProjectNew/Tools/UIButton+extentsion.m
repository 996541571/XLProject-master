//
//  UIButton+extentsion.m
//  GitTest
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIButton+extentsion.h"

@implementation UIView (extentsion)
-(void)setCornerRadiusWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}
@end
