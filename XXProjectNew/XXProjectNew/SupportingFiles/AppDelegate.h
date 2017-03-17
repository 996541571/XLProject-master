//
//  AppDelegate.h
//  XXProjectNew
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate,RCIMUserInfoDataSource>
{
    
}


@property (strong, nonatomic) UIWindow *window;

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion;

@end

