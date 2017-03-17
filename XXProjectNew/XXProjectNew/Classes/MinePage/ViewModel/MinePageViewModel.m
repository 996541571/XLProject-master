//
//  MinePageViewModel.m
//  XXProjectNew
//
//  Created by apple on 11/28/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "MinePageViewModel.h"
#import "MinePageModel.h"

@interface MinePageViewModel()
@end
@implementation MinePageViewModel
+(instancetype)model{
    
    static id model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        model = [MinePageViewModel new];
        
    });
    
    return model;
}


-(identity)user{
    
    
    
//#define MANAGER @"MANAGER"
    //村民
//#define USER @"USER"
    //游客
//#define VISITOR @"VISITOR"

    NSString* userTypeStr ;
    
    userTypeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:USERTYPE];
    
    if ([userTypeStr isEqualToString:MANAGER]) {
        
        _user = 2;
    } else if ([userTypeStr isEqualToString:USER]){
        
        _user = 1;
        
    }else{
        
        _user = 0;
    }
    
//        _user = 1;
    
    return _user;
}


-(void)prepareToPresentWithSuccess:(void(^)())success{
    
    [NetRequest requetWithParams:@[] requestName:@"app.PersonInfoService.getRowInfo" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        NSLog(@"%@",responseDicionary);
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {
        
            NSDictionary* dic = [responseDicionary valueForKey:@"result"];
            
            MinePageModel* model = [MinePageModel new];
            
            [model setValuesForKeysWithDictionary:dic];
            
            self.model = model;
            
            
            if (success) {
                success();
            }
        
        }
        

        
        
        
    }];
    
}



@end
