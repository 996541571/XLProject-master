//
//  UIButton+Custom.m
//  XXProjectNew
//
//  Created by apple on 12/2/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)
+(instancetype)buttonWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview {
    
    
    UIButton* btn = [UIButton new];
    
    [btn setTitle:text forState:UIControlStateNormal];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    [superview addSubview:btn];
    
//    [btn sizeToFit];
    
    return btn;
    
    
}

@end
