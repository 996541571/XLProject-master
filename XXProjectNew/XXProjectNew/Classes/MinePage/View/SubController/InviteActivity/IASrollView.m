//
//  IASrollView.m
//  XXProjectNew
//
//  Created by apple on 12/26/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "IASrollView.h"

@implementation IASrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    
    NSLog(@"-----");
    
    NSLog(@"%@", NSStringFromCGPoint(point));

    
    if (point.y < 695 && point.y > 400 && self.own_table) {
        
        return self.own_table;
    }

    
//    if ([self.own_table pointInside:point withEvent:nil]) {
//        
//        
//        return self.own_table;
//    }
    
    
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        
//            UIView *hitTestView;
        
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            
            UIView* hitTestView = [subview hitTest:convertedPoint withEvent:event];
            
            if (hitTestView) {
                
                
                return hitTestView;
                
            }
        }
        
        
        
        return self;
        
        
        
        
        
    }
    
    
    
    
    return nil;

    
    
}

@end
