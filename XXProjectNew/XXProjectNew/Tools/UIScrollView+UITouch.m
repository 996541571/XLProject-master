//
//  UIScrollView+UITouch.m
//  XXProjectNew
//
//  Created by apple on 12/26/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 选其一即可
//    [super touchesBegan:touches withEvent:event];
        [[self nextResponder] touchesBegan:touches withEvent:event];
    
}


//
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    
//    
////        [self touchesMoved:touches withEvent:event];
//    
//    [[self nextResponder] touchesMoved:touches withEvent:event];
//
//    
//}

@end
