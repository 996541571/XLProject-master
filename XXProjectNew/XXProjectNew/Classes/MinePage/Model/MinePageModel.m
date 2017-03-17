//
//  MinePageModel.m
//  XXProjectNew
//
//  Created by apple on 12/14/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "MinePageModel.h"

@implementation MinePageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    [super setValue:value forKey:key];
    
    NSInteger index  = 0 ;
    
    NSArray* attribute_arr = @[@"accountRow",@"inviteRow",@"resetPwRow",@"userInfoRow"];
    
    NSMutableArray* unpresent_item_arr = [NSMutableArray array];
    
    for (NSString* attribute_name in attribute_arr) {
        
        if ([[self valueForKey:attribute_name] isEqualToString:@"true"]) {
            
            index++;
            
        }else{
            
            [unpresent_item_arr addObject:attribute_name];
            
        }
        
        
    }
    
    NSDictionary* dic = @{@"count":[NSString stringWithFormat:@"%td",index],@"array":unpresent_item_arr.copy};
    
    self.presentCell_dic = dic;
    
}


@end
