//
//  FollowsAndFansVM.m
//  XXProjectNew
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "FollowsAndFansVM.h"
static FollowsAndFansVM *_model;
@implementation FollowsAndFansVM
+(instancetype)shareModel{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _model = [FollowsAndFansVM new];
        
    });
    
    return _model;
}
//我的粉丝和关注
-(void)getMyFollowsOrFansWithType:(NSString *)type page:(NSNumber *)page pageSize:(NSNumber *)pageSize isALL:(NSString *)isAll  vc:(UIViewController *)vc success:(void (^)(NSArray *dataArr))block
{
    NSDictionary *dict = [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSArray *parms = @[@{@"bothStatus":type,@"partyId":dict[@"nodeManagerPartyId"],@"startPage":page,@"pageSize":pageSize,@"queryAll":isAll}];
    [NetRequest requetWithParams:parms requestName:@"UserRelationService.queryFollowsOrFans" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            block(responseDicionary[@"result"]) ;
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice] expireNoticeOnController:vc];
        }else{
            [[NoticeTool notice] showTips:@"网络异常" onController:vc];
        }
        
    }];
}
//TA的关注和粉丝
-(void)getOthersFollowsOrFansWithType:(NSString *)type toPartyId:(NSNumber *)toPartyId page:(NSNumber *)page pageSize:(NSNumber *)pageSize vc:(UIViewController *)vc success:(void(^)(NSArray *dataArr))block
{
    NSArray *parms = @[@{@"bothStatus":type,@"partyId":ManagerPartyId,@"fromPartyId":toPartyId,@"startPage":page,@"pageSize":pageSize}];
    [NetRequest requetWithParams:parms requestName:@"UserRelationService.queryRelationList" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            block(responseDicionary[@"result"]) ;
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice] expireNoticeOnController:vc];
        }else{
            [[NoticeTool notice] showTips:@"网络异常" onController:vc];
        }
    }];
}





@end
