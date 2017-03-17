//
//  DVTextField.m
//  XXProjectNew
//
//  Created by apple on 1/14/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DVTextField.h"

@implementation DVTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    if(action ==@selector(paste:))//禁止粘贴
        
        return NO;
    
    if(action ==@selector(select:))// 禁止选择
        
        return NO;
    
    if(action ==@selector(selectAll:))// 禁止全选
        
        return NO;
    
    return[super canPerformAction:action withSender:sender];
    
}
@end
