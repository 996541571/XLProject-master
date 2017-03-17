//
//  UILabel+custom.m
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "UILabel+custom.h"

@implementation UILabel (custom)

+(instancetype)labelWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview {
    
    UILabel* label = [UILabel new];
    
    label.text = text;
    
    label.textColor = color;
    
    label.font = [UIFont systemFontOfSize:fontSize];
    
    [superview addSubview:label];
    
    
    return label;
}

@end
