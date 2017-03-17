//
//  NewsListPageViewModel.h
//  XXProjectNew
//
//  Created by apple on 11/25/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define barHight 64
#define headViewHight 50
#define itemCount 4
//RMZX("热门资讯"),SSCL("时尚潮流"),YLXW("娱乐新闻")
@class NewsListPageModel;

typedef enum : NSUInteger {
    NewsTypeRMZX,
    NewsTypeJKZX,
    NewsTypeSSCL,
    NewsTypeYLXW,
} NewsType;

@interface NewsListPageViewModel : NSObject
@property(nonatomic,strong)NSArray<NSNumber*>* rowCount_arr;
@property(nonatomic,strong)NSArray<NSArray*>* cellModel_arr;
@property(nonatomic,strong)NSArray<NewsListPageModel*>* random_arr;

//定义一个数组来记录cell的是否选中的状态

@property (nonatomic, strong) NSMutableArray *arrCellSelect;
-(void)obtainWebDataWithFinished:(void(^)())finished;

-(void)obtainWebDataWithType:(NewsType)type andCurrentPage:(NSNumber*)currentPage andFinished:(void(^)())finished;


+(instancetype)model;
@end
