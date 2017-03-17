//
//  FirstPageViewModel.m
//  XXProjectNew
//
//  Created by apple on 12/8/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "FirstPageViewModel.h"
#import "BusinessModel.h"
@implementation FirstPageViewModel
+(instancetype)model{
    
    static id model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        model = [FirstPageViewModel new];
        
    });
    
    return model;
}

-(void)queryBusinessModulWithSuccess:(void(^)())success{
    
  //  operationType：com.xianglin.appserv.common.service.facade.app.IndexService.indexBusiness

    NSArray *params = @[sysVersion];
    [NetRequest requetWithParams:params requestName:@"app.IndexService.indexBusinessV2" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
       
        NSLog(@"%@",responseDicionary);
        
        
        
        if([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 1000){
            
            //[5]	(null)	@"busiActive" : @"HTML"
            //[6]	(null)	@"busiCode" : @"PHONE"
        
        NSArray* arr = [responseDicionary valueForKey:@"result"];
        
        NSMutableArray* array = [NSMutableArray array];
            
            
        
        for (NSDictionary* dic in arr) {
            
            BusinessModel* bus =  [BusinessModel new];
            
            [bus setValuesForKeysWithDictionary:dic];
        
            [array addObject:bus];
            
            if ([bus.busiName isEqualToString:@"乡邻购"]) {
                
                bus.busiNewYearImageName = @"NY_shop";
                
            }else if ([bus.busiName isEqualToString:@"手机充值"]){
                
                bus.busiNewYearImageName = @"NY_mobileCharge";

            }else if ([bus.busiName isEqualToString:@"我的光伏"]){
                bus.busiNewYearImageName = @"NY_guangfu";

            }else if ([bus.busiName isEqualToString:@"赚钱"]){
                bus.busiNewYearImageName = @"NY_money";

            }else if ([bus.busiName isEqualToString:@"我的借款"]){
                bus.busiNewYearImageName = @"NY_guyu";

            }else if ([bus.busiName isEqualToString:@"银行业务"]){
                bus.busiNewYearImageName = @"NY_bankBusiness";
            }
                
        }
            
            
            
        
        self.business_arr = array.copy;
        
        
        if (success) {
            success();
        }
        
    }
        
    }];
    
    //
//    [self queryForSolarDataWithSuccess:nil];
    
}



-(void)queryForSolarDataWithSuccess:(void (^)())block{
    
    
//    com.xianglin.appserv.common.service.facade.app.XLAppIndexPageService.getTotalSolarData
    
    [NetRequest requetWithParams:@[] requestName:@"app.XLAppIndexPageService.getTotalSolarData" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
    
        
        NSLog(@"%@",responseDicionary);
        
        if([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 1000){
            
            
            self.solarDic = [responseDicionary valueForKey:@"result"];
            
            
            if (block) {
                
                block();
            }
            
            
        }
        
    }];
    
    
    

    
}

-(void)obtainInvitePeopleNum:(void (^)(NSString* str))success{
    
    [NetRequest requetWithParams:@[] requestName:@"app.ActivityInviteService.inviteAlert" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        NSLog(@"%@",responseDicionary);
        
        
        if([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 1000){
            
            
            
            
            if (success) {
                success([responseDicionary valueForKey:@"result"]);
                
      //success(@"5");
            }
            
            
            
            }
            

        
        
    }];

    
    
}


@end
