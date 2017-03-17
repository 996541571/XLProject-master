//
//  ConveniecePageViewModel.m
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "ConveniecePageViewModel.h"
#import "ConveniencePageModel.h"
#import "CPCellModel.h"
@implementation ConveniecePageViewModel


+(instancetype)model{
    
    static id model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        model = [ConveniecePageViewModel new];
        
    });
    
    return model;
}



-(NSArray*)cellModel_arr{
    
    
    if (!_cellModel_arr) {
        
/*
        
        NSMutableArray* arr = [NSMutableArray array];
        
        NSArray* array = @[@"便民服务",@"便民生活",@"便民查询"];
        
        for (int i = 0 ; i<3 ; i++) {
            
            
            ConveniencePageModel* model = [ConveniencePageModel new];
            
            model.item_count = 10;
            

            
            model.title_arr = @[@"点",@"我",@"开",@"心",@"天",@"天",@"开",@"心",@"哈",@"😁"];
            
            model.img_arr = @[@"item_expressage",@"item_trainTicket",@"item_live",@"item_cooking",@"item_drive",@"item_illegal",@"item_dream",@"item_shopping",@"item_mobile",@"item_QQcharge"];
            
            model.title = array[i];
            

            
            [arr addObject:model];
            
            
        }
        
        _cellModel_arr = arr.copy;
 
        
        */
        
//          [self obtainWebDataWithSuccess:^(NSArray * arr) {
//             
//              _cellModel_arr = arr;
//              
//          }];
        
        
    }
    
    
  
    
    
    return _cellModel_arr;
}




-(void)obtainWebDataWithSuccess:(void (^)(NSArray*))success{
    
//    AppMenuService.getAppMenus
    
    
    [NetRequest requetWithParams:@[@{@"requestData":@"1"}] requestName:@"AppMenuService.getAppMenus" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
       
        NSLog(@"%@",responseDicionary);
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {

        
        NSArray* arr = [responseDicionary valueForKey:@"result"];
        
        NSMutableArray* array = [NSMutableArray array];
        
        
        for (NSDictionary* dic in arr) {
            
            CPCellModel* cellModel = [CPCellModel new];
            
            [cellModel setValuesForKeysWithDictionary:dic];
            
            [array addObject:cellModel];
            
        }
        
        
        
        NSMutableArray* arr1 = [NSMutableArray array];
        
        NSMutableArray* arr2 = [NSMutableArray array];

        NSMutableArray* arr3 = [NSMutableArray array];

        
           ConveniencePageModel* model1 = [ConveniencePageModel new];
           ConveniencePageModel* model2 = [ConveniencePageModel new];
           ConveniencePageModel* model3 = [ConveniencePageModel new];
        
        
        for (CPCellModel* cellModel in array.copy) {
            
            
            if ([cellModel.mlevel integerValue] == 1) {
                
                self.PageTitle= cellModel.mname ;
                
            }else if ([cellModel.mlevel integerValue] == 2){
                
                
                if ([cellModel.morder integerValue] == 0) {
                    
                      model1.title = cellModel.mname;
                    

                }else if ([cellModel.morder integerValue] == 1) {
                    
                      model2.title = cellModel.mname;
                    
                }else{
                    
                      model3.title = cellModel.mname;
                    
                    
                }
                
                
                
            // cell
            }else if([cellModel.mlevel integerValue] == 3){
                
                
                
                //第一组
                if ([cellModel.pid integerValue] == 0) {
                    
                    
//                    [arr1 insertObject:cellModel atIndex:[cellModel.morder integerValue]];
                    
                    [arr1 addObject:cellModel];
                    
                    
                //第二组
                }else if([cellModel.pid integerValue] == 1){
                    
//                    [arr2 insertObject:cellModel atIndex:[cellModel.morder integerValue]];
                    
                    [arr2 addObject:cellModel];

                    
                //第三组
                }else if ([cellModel.pid integerValue] == 2){
                    
                    
//                    [arr3 insertObject:cellModel atIndex:[cellModel.morder integerValue]];
                    
//                    [arr3 insertObject:cellModel atIndex:0];
                    
                        [arr3 addObject:cellModel];


                    
                    
                    
                }
                    
                    
                    
                
                
                
                
            }
            
            
        }
        //循环完成
        NSLog(@"%@",arr1);
        
        
        
     

        model1.smallCell_arr = arr1;
        
        
        
        model2.smallCell_arr = arr2;
        
        
        model3.smallCell_arr = arr3;
        

        NSMutableArray* array_ = [NSMutableArray array];
        
        
        for (ConveniencePageModel* model in @[model1,model2,model3]) {
            
            if (model.smallCell_arr.count) {
                
                [array_ addObject:model];
                
            }
        
        }
        
        
        if (success) {
            
            success(array_.copy);
        }
        
    }
        
        
    }];
    
    
    
}


@end
