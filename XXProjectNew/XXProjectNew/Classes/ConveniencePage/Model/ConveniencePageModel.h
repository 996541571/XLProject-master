//
//  ConveniencePageModel.h
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPCellModel;
@interface ConveniencePageModel : NSObject
@property(nonatomic,assign)NSInteger item_count;
//Max_WidCount
@property(nonatomic,assign)NSInteger Max_WidCount;
//动态行高的计算
@property(nonatomic,assign)NSInteger cellRowHeight;
//标题组
@property(nonatomic,strong)NSArray* title_arr;
//图片组
@property(nonatomic,strong)NSArray* img_arr;
@property(nonatomic,strong)NSArray* imgUrl_arr;
//cell标题
@property(nonatomic,copy)NSString* title;

//-----------------------------

@property(nonatomic,strong)NSArray<CPCellModel*>* smallCell_arr;


@end
