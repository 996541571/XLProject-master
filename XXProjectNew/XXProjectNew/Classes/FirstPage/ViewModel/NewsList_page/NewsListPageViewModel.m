//
//  NewsListPageViewModel.m
//  XXProjectNew
//
//  Created by apple on 11/25/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "NewsListPageViewModel.h"
#import "NewsListPageModel.h"
@implementation NewsListPageViewModel
+(instancetype)model{
    
    static id model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        model = [NewsListPageViewModel new];
        
    });
    
    return model;
}

-(NSArray<NSArray*>*)cellModel_arr{
    
    
    if (!_cellModel_arr) {
        
        
        //无奈的懒加载
        
            _cellModel_arr = @[@[],@[],@[],@[]];
        
        
    }
    
    
    return _cellModel_arr;
}

-(NSArray*)random_arr{
    
    
    if (!_random_arr) {
        
        
        
        _random_arr = @[];
        
    }
    
    
    return _random_arr;
}


-(NSArray*)rowCount_arr{
    
    
    return @[@(self.cellModel_arr[0].count),
             @(self.cellModel_arr[1].count),
             @(self.cellModel_arr[2].count),
             @(self.cellModel_arr[3].count)             ];
    
}






-(void)obtainWebDataWithFinished:(void(^)())finished{

    //防止每次下载相同的资料
    
    if (self.cellModel_arr[0].count) {
        
        
        return;
    }
    
    
    void(^finished_blcok)() = nil;
    
    for (int i = 0 ; i < 4;  i ++) {
        
        
//        if (i == 3){
        
            finished_blcok = finished;
            
//        }
        
        [self obtainWebDataWithType:i andCurrentPage:@1 andFinished:finished_blcok];
        
        
    }



}

-(void)obtainWebDataWithType:(NewsType)type andCurrentPage:(NSNumber*)currentPage andFinished:(void(^)())finished{
    
    /*
     gatewayRequest:
     GatewayRequest
     [
     deviceId=708536eb42a64ad19ddb1f29b72ad70d,
     operation=com.xianglin.appserv.common.service.facade.app.IndexService.indexNewsMsg,
     requestData=[{"req":{"msgType":"RMZX","pageSize":10,"startPage":1}}],
     session=com.xianglin.fala.session.RedisSessionRepository$RedisSession@38863e90,
     
     paramMap={
     d=6L3OIzLiyMPLic9YZ4M9ZcOleFgUzr5nNRDv+lJ8597DFvcS5TBS8orpi4aHnGZdYk8mSPur9zDoPKGiEaN+ig==,
     operationType=com.xianglin.appserv.common.service.facade.app.IndexService.indexNewsMsg,
      requestData=[{"req":{"msgType":"RMZX","pageSize":10,"startPage":1}}]}
     ]
     
     */

    //NSDictionary*dic=@{@"d":dReal,@"operationType":operationType,@"requestData":fsgfg};
    
    //RMZX("热门资讯"),SSCL("时尚潮流"),YLXW("娱乐新闻")
    
    
    NSString* msgType ;
    
    switch (type) {
        case 0:
            
            msgType = @"RMZX";
            
            break;
        case 1:
            msgType = @"JKZX";

            
            break;
        case 2:
            msgType = @"SSCL";
            
            break;
        case 3:
            msgType = @"YLXW";
            
            break;
            
        default:
            
            msgType = @"";
            break;
    }
    
    NSArray* arr = @[
                     @{@"req":
                           
                           @{@"msgType":
                                 msgType,
                             @"pageSize":
                                 @10,
                             @"startPage":
                                 currentPage
                             }
                       }
                     ];
    
    
    [NetRequest requetWithParams:arr requestName:@"app.IndexService.indexNewsMsg" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        
        if (error) {
            
            NSLog(@"%@",error);
        }
        
        NSLog(@"%@",responseDicionary);
        
        
        
        
        NSMutableArray<NSArray*>* arr = [self.cellModel_arr mutableCopy];//大数组
        
        //字典转模型
        
        NSArray* array = [responseDicionary valueForKey:@"result"];//字典数组
        
        NSMutableArray* arr_tmep = [NSMutableArray array];//模型数组
        
        for (NSDictionary* dic  in array) {
            
            NewsListPageModel* model = [NewsListPageModel modelWithDictionary:dic];
            
            [arr_tmep addObject:model];
            
            
        }

        //向大数组中添加模型数组
        //        [arr addObject:arr_tmep];

    
        
        //判断是否为空
        

        
        if (!msgType.length) {
            
            self.random_arr = [self.random_arr arrayByAddingObjectsFromArray:arr_tmep];
            
        }else{
            
            arr[type] = [arr[type] arrayByAddingObjectsFromArray:arr_tmep];
        }
        


        
        
    
        
        
        self.cellModel_arr = arr.copy;
        
        
        if (finished) {
            
            finished();
        }
        
        
        
    }];

    
    
    
}

@end
