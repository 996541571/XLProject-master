//
//  UITextField+Custom.m
//  XXProjectNew
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "UITextField+Custom.h"

@implementation UITextField (Custom)
-(void)customPlaceholderColor:(UIColor*)color{
    
      [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    
}


@end
