//
//  FollowsAndFansVM.h
//  XXProjectNew
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowsAndFansVM : NSObject
+(instancetype)shareModel;
-(void)getMyFollowsOrFansWithType:(NSString *)type page:(NSNumber *)page pageSize:(NSNumber *)pageSize isALL:(NSString *)isAll  vc:(UIViewController *)vc success:(void (^)(NSArray *dataArr))block;
-(void)getOthersFollowsOrFansWithType:(NSString *)type toPartyId:(NSNumber *)toPartyId page:(NSNumber *)page pageSize:(NSNumber *)pageSize vc:(UIViewController *)vc success:(void(^)(NSArray *dataArr))block;
@end
