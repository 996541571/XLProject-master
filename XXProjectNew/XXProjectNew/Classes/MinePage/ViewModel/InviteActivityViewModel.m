//
//  InviteActivityViewModel.m
//  XXProjectNew
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "InviteActivityViewModel.h"

#import "InviteActivityModel.h"
@interface InviteActivityViewModel()

@property(nonatomic,assign)NSInteger currentPage;

@end
@implementation InviteActivityViewModel
+(instancetype)model{
    
    static id model;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        model = [InviteActivityViewModel new];
        
        
    });
    
    return model;
}



-(void)obtainWebDataWithSuccess:(void (^)())success {
    
    
    self.currentPage = 1;
    
//    @"app.ActivityInviteService.inviteRanking"
    
    NSArray* request_arr = @[
                             @"app.ActivityInviteService.inviteRanking",
                             @"app.ActivityInviteService.inviteInfo",
                             @"app.ActivityInviteService.inviteUserRanking"];
    
    
    
    for (int i  = 0 ; i < 3; i++) {
        
        
        NSArray* arr = @[];

        if (i == 0) {
            
            arr = @[@{@"curPage":@1,@"pageSize":@10}];
        }
       

    
    [NetRequest requetWithParams:arr requestName:request_arr[i] finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        NSLog(@"%@",responseDicionary);
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {

        
        switch (i) {
                //排行榜
            case 0:
            {
                
                NSArray* arr = [responseDicionary valueForKey:@"result"];
                
                NSMutableArray* array = [NSMutableArray array];
                
                for (NSDictionary* dic  in arr) {
                    
                    InviteActivityModel* model = [InviteActivityModel new];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [array addObject:model];
                    
                }
                
                self.rank_arr = array.copy;
                
                self.currentPage ++;
                
                
            }
                break;
                
            case 1:
                //个人信息
            {
             
                NSDictionary* dic = [responseDicionary valueForKey:@"result"];
                
                NSDictionary* wxContent = [dic valueForKey:@"wxContent"];
                
                self.qrCode = [dic valueForKey:@"qrCode"];
                
                self.title = [wxContent valueForKey:@"title"];
                
                self.img = [wxContent valueForKey:@"img"];
                
                self.msg = [wxContent valueForKey:@"msg"];
                
                
                NSString* wxHref = [wxContent valueForKey:@"wxHref"];
                
                self.wxHref = wxHref;
                
                NSString* pyqHref = [wxContent valueForKey:@"pyqHref"];
                
                self.pyqHref = pyqHref;
                
                NSDictionary* cfContent =  [dic valueForKey:@"cfContent"];
                
                //个人账户
                NSString* amt = [cfContent valueForKey:@"amt"];
                
                self.amt = amt;
                
                //个人金额
                NSString* detail = [cfContent valueForKey:@"detail"];
                
                self.detail = detail;
                
                //活动介绍
                NSString* desc = [cfContent valueForKey:@"desc"];
                
                self.desc = desc;

                
                
                
                
            }
                break;
            case 2:
                //我的排名
            {
                
                if ([responseDicionary valueForKey:@"result"]) {
                    
                    
                    InviteActivityModel* model = [InviteActivityModel new];
                    
                    [model setValuesForKeysWithDictionary:[responseDicionary valueForKey:@"result"]];
                    
                    
                    self.myRank = model;
                    
                    self.recCount  = model.recCount;
                    
                    self.recAmtStr = model.recAmtStr;
                }
                
                
                
            }
                
                break;


                
            default:
                break;
        }
        
        
        if (success) {
            success();
        }
        
    }
        
    }];
    
    
    
    
    }
    
    
    
}


-(void)obtaininviteUserRankingDataWithSuccess:(void(^)())success{
    
    
    if (self.currentPage > 10) {
        
        return;
    }
    
    NSArray* arr = @[@{@"curPage":@(self.currentPage),@"pageSize":@10}];
    
    [NetRequest requetWithParams:arr requestName:@"app.ActivityInviteService.inviteRanking" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        NSLog(@"%@",responseDicionary);
        

        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {
            

            NSArray* arr = [responseDicionary valueForKey:@"result"];
            
            NSMutableArray* array = [NSMutableArray array];
            
            for (NSDictionary* dic  in arr) {
                
                InviteActivityModel* model = [InviteActivityModel new];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [array addObject:model];
                
            }
            
            
            NSMutableArray* temp_arr = self.rank_arr.mutableCopy;
            
             [temp_arr addObjectsFromArray:array];
            
            self.rank_arr = temp_arr.copy;
            
            self.currentPage ++;


            if (success) {
                success();
            }

            
        
        }

    
    }
    
        ];
    
}
    

@end
