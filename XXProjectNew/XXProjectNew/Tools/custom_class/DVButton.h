//
//  DVButton.h
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BtnType) {
    BtnTypeDefault,
    BtnTypeRight,
    BtnTypeDown,
    BtnTypeUp,
};

@interface DVButton : UIButton

- (instancetype)initWithType:(BtnType)type andimgBounds:(CGRect)imgBounds;

+(instancetype)buttonWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview andType:(BtnType)type ;

+(instancetype)buttonWithText:(NSString*)text andColor:(UIColor*)color andFontSize:(CGFloat)fontSize andSuperview:(UIView*)superview andType:(BtnType)type  andCustomimgBounds:(CGRect)imgBounds;
@property(nonatomic,assign)CGRect custom_rect;
@property(nonatomic,assign)BtnType btnType;
@end
