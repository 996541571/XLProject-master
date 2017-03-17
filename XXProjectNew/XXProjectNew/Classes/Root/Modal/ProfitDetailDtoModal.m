//
//  profitDetailDtoModal.m
//  XXProjectNew
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "ProfitDetailDtoModal.h"

@implementation ProfitDetailDtoModal
- (id)init
{
    
    if (self=[super init]) {
        
        self.labNameArr=[NSMutableArray arrayWithCapacity:0];
        self.dataArr=[NSMutableArray arrayWithCapacity:0];
        self.colorArr=[NSMutableArray arrayWithCapacity:0];
        self.transferdDataArr=[NSMutableArray arrayWithCapacity:0];
        self.transferdLabArr=[NSMutableArray arrayWithCapacity:0];
        
    }
    return self;
}


@end
