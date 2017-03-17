//
//  DVButton.m
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "DVButton.h"

@implementation DVButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithType:(BtnType)type andimgBounds:(CGRect)imgBounds
{
    self = [super init];
    if (self) {
        
        _btnType = type;
        
        if(imgBounds.size.width){
            
            self.custom_rect = imgBounds;
            
        }
    }
    return self;
}


+(instancetype)buttonWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview andType:(BtnType)type  andCustomimgBounds:(CGRect)imgBounds{
    
    
    DVButton* btn = [[DVButton alloc]initWithType:type andimgBounds:imgBounds];
    
    [btn setTitle:text forState:UIControlStateNormal];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [superview addSubview:btn];
    
    //    [btn sizeToFit];
    
    return btn;
    
}




+(instancetype)buttonWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview andType:(BtnType)type {



    
    DVButton* btn = [[DVButton alloc]initWithType:type andimgBounds:CGRectZero];
    
    [btn setTitle:text forState:UIControlStateNormal];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [superview addSubview:btn];
    
    //    [btn sizeToFit];
    
    return btn;



}

  
    


+(instancetype)buttonWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview {
    
    return [self buttonWithText:text andColor:color andFontSize:fontSize andSuperview:superview andType:BtnTypeDown];
    
}



- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    
    CGFloat inteval = CGRectGetWidth(contentRect)/16.0;
    //取最小值
    inteval = MIN(inteval, 6);
    
    inteval = 8;
    
    
    if (self.btnType == BtnTypeDown) {
        
        
        CGFloat imageW = CGRectGetWidth(contentRect) - 2 * inteval;
        
        //设置图片的宽高为button宽度的7/8;
        
        CGRect rect = CGRectMake(0, inteval*2 + imageW, CGRectGetWidth(contentRect) , CGRectGetHeight(contentRect) - 3*inteval - imageW);
        
        
        return rect;
    }else if (self.btnType == BtnTypeDefault){
        
        return [super titleRectForContentRect:contentRect];
        
    }else if (self.btnType == BtnTypeRight){
        
        CGFloat imageW = CGRectGetHeight(contentRect) - 2 * inteval;
        
//        CGRect rect = CGRectMake(inteval*2 + imageW, 0 ,  CGRectGetWidth(contentRect) - 3*inteval - imageW ,CGRectGetHeight(contentRect));
        
        CGRect rect = CGRectMake(0, 0 ,  CGRectGetWidth(contentRect) - 3*inteval - imageW ,CGRectGetHeight(contentRect));
        
        
        return rect;
    }
        
        
        
        
        
    
    
    
    return CGRectZero;
    
    
}




- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    
    CGFloat inteval = CGRectGetWidth(contentRect)/16.0;
    inteval = MIN(inteval, 6);
    
    inteval = 8;
    
    if (self.btnType == BtnTypeDown) {

        
        if (self.custom_rect.size.width) {
            
            CGRect rect = CGRectMake((contentRect.size.width - self.custom_rect.size.width)/2.0, (contentRect.size.width - self.custom_rect.size.width)/2.0 ,self.custom_rect.size.width, self.custom_rect.size.height);

            return rect;
        }

        
        //设置图片的宽高为button宽度的7/8;
    CGFloat imageW = CGRectGetWidth(contentRect) - 2 * inteval;
        
    
    CGRect rect = CGRectMake(inteval, inteval, imageW, imageW);
    
    return rect;
        
    } else if (self.btnType == BtnTypeDefault){
        
        return [super titleRectForContentRect:contentRect];
        
        
    }else if (self.btnType == BtnTypeRight){
        
        CGFloat imageW = CGRectGetHeight(contentRect) - 2 * inteval;

        
//        CGRect rect = CGRectMake(inteval, inteval, imageW, imageW);

        CGRect rect = CGRectMake(CGRectGetWidth(contentRect) - 3*inteval - imageW + inteval, inteval ,imageW,imageW);
        
        
        return rect;
        
    }


    
    
    return CGRectZero;
}


@end
