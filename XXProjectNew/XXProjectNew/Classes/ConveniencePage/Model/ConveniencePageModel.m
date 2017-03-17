//
//  ConveniencePageModel.m
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "ConveniencePageModel.h"
#import "ConveniecePageViewModel.h"
#import "CPCellModel.h"
@implementation ConveniencePageModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}




-(void)setSmallCell_arr:(NSArray<CPCellModel *> *)smallCell_arr{
    
    _smallCell_arr = smallCell_arr;
    
    //设置
    
    self.item_count = smallCell_arr.count;
    
    
    NSMutableArray* arr_title = [NSMutableArray array];
    
    NSMutableArray* arr_imgUrl = [NSMutableArray array];
    
    for (int i = 0 ; i < smallCell_arr.count; i++) {
        
        
        [arr_title addObject:smallCell_arr[i].mname];
        
        [arr_imgUrl addObject:smallCell_arr[i].imgurl];
        
    }
    
    
    self.title_arr = arr_title.copy;
    
    self.imgUrl_arr = arr_imgUrl.copy;
    
    
}




-(NSInteger)Max_WidCount{
    
    
    return 4;
}

-(NSInteger)cellRowHeight{
    
    
    if (!self.smallCell_arr) {
        
        
        return 0;
    }
    
    // btn高+空隙+title高+10低距
    
    return _cellRowHeight = (_item_count == 0 ? 0: (_item_count-1)/ self.Max_WidCount+1)*btnHeight+10+(_item_count == 0 ? 0: (_item_count-1)/ self.Max_WidCount+2)*10 + title_height;
    
}


@end
