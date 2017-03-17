//
//  UILabel+custom.h
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (custom)

+(instancetype)labelWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview;
@end
