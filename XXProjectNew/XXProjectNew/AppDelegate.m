//
//  AppDelegate.m
//  XXProjectNew
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "UMMobClick/MobClick.h"
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<UNUserNotificationCenterDelegate,UIAlertViewDelegate>
{
    BOOL _isShow; //标记提示框是否已经弹出
    NSDictionary *_userInfo;
}
@end

@implementation AppDelegate


//程序未启动收到推送，无论是点击推送消息启动应用还是点击了应用图标启动应用都执行此方法；这个方法来启动程序，两者区别在于点击推送消息启动应用会把推送的消息userInfo通过launchOptions参数传递过来
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bugly startWithAppId:@"6d6ac3b52d"];
    UMConfigInstance.appKey = @"567138a2e0f55a5aad00184e";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSLog(@"Registering for push notifications...");
    _isShow = NO;
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"notiWebUrl"];
    //点击推送消息启动应用会把推送的消息userInfo通过launchOptions参数传递过来
//    if (launchOptions) {
//        NSDictionary *dicUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if ([dicUserInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
//            [self login];
//        }
//
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];  
    }else if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"8.0")) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
    }else{
        UIRemoteNotificationType type = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:type];
    }
   
    
    
    //自定义UA
    //get the original user-agent of webview
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:@" One Account IOS;Mozilla"];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    
    
    return YES;
    
    
    
    
    
    
}

//是ios7新加入的方法，当程序在前台运行时，收到远程推送，会立刻调用此方法，但是如果程序在后台挂起，收到消息（未点击推送消息时）并不会执行方法
// 在此方法中一定要调用completionHandler这个回调，告诉系统是否处理成功
//UIBackgroundFetchResultNewData, // 成功接收到数据
//UIBackgroundFetchResultNoData,  // 没有接收到数据
//UIBackgroundFetchResultFailed   // 接受失败
#pragma mark -- ios7
-(void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"%@--%f",userInfo,now);
    if (application.applicationState == UIApplicationStateActive) {
        NSString *title = userInfo[@"title"];
        NSString *content = userInfo[@"aps"][@"alert"];
        if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            _isShow = YES;
            [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"RECEIVE"];
        }else{
            
            if ([XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
                //发通知刷新首页公告
                NSNotification *noti = [NSNotification notificationWithName:@"public" object:nil];
                [[NSNotificationCenter defaultCenter]postNotification:noti];
                //前台收到推送，提示用户是否查看
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"查看推送消息详情" delegate:self
                                                     cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                _userInfo = userInfo;
                alert.tag = 101;
                [alert show];
            }
            
        }
    }else if (application.applicationState == UIApplicationStateInactive){
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        if ([[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] isEqualToString:@"0"]) {
            if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
                if (!_isShow && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {//
                    NSString *title = userInfo[@"title"];
                    NSString *content = userInfo[@"aps"][@"alert"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }else if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
                
                if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                    if (![[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
                        PhoneNumLoginVC *login = [[PhoneNumLoginVC alloc]initWithNibName:@"PhoneNumLoginVC" bundle:nil];
                        login.isPush = YES;
                        login.pushUrl = userInfo[@"url"];
                        [[self getPresentedViewController] presentViewController:login animated:YES completion:nil];
//                    }
                    
                } else {
                    if ([XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
                        WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
                        web.urlstr = userInfo[@"url"];
                        web.isPush = YES;
                        [[self getPresentedViewController] presentViewController:web animated:YES completion:nil];
                    } else {
                        WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
                        
                        __weak WYWebController *weakVC = web;
                        weakVC.urlstr = userInfo[@"url"];
                        weakVC.isPush = YES;
                        [[self getPresentedViewController]  presentViewController:weakVC animated:YES completion:nil];
                        
                    }
                }
            }
        } else {
            float msgTime = [userInfo[@"msgTime"] floatValue];
            float expiryTime = [[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] floatValue];
            float expire = (now - msgTime)/1000 - expiryTime;
            NSLog(@"%f_%f_%f_%f",now,msgTime,expiryTime,expire);
            if (expire > 0) {
                if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
                    if (!_isShow && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {//
                        NSString *title = userInfo[@"title"];
                        NSString *content = userInfo[@"aps"][@"alert"];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                }else if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
                    
                    if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                        if (![[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
                            PhoneNumLoginVC *login = [[PhoneNumLoginVC alloc]initWithNibName:@"PhoneNumLoginVC" bundle:nil];
                            login.isPush = YES;
                            login.pushUrl = userInfo[@"url"];
                            [[self getPresentedViewController] presentViewController:login animated:YES completion:nil];
//                        }
                        
                    } else {
                        WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
//                        web.urlstr = userInfo[@"url"];
//                        web.isPush = YES;
                        __weak WYWebController *weakVC = web;
                        weakVC.urlstr = userInfo[@"url"];
                        weakVC.isPush = YES;
                        [[self getPresentedViewController] presentViewController:weakVC animated:YES completion:nil];
                    }
                }
            }
        }
        
        [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"CLICK"];
    }
    
    if (userInfo) {
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}
//注册失败
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"+++%@",str);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
}
//iOS3.0以后
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
        [self login];
    }
    NSLog(@"--------------userInfo===%@",userInfo);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
}

//====================For iOS 10====================

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSString *title = userInfo[@"title"];
    NSString *content = userInfo[@"aps"][@"alert"];
    if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        _isShow = YES;
    }else{
        //发通知刷新首页公告
        NSNotification *noti = [NSNotification notificationWithName:@"public" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:noti];
        
    }
    
    [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"RECEIVE"];
    //功能：可设置是否在应用内弹出通知
    completionHandler(UNNotificationPresentationOptionAlert);
}
//点击推送消息后回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
        withCompletionHandler:(void(^)())completionHandler{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
    //判断是否过期
    if ([[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] isEqualToString:@"0"]) {
        //是否需要登录
        if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
            if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                if (![[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
                    PhoneNumLoginVC *login = [[PhoneNumLoginVC alloc]initWithNibName:@"PhoneNumLoginVC" bundle:nil];
                    login.isPush = YES;
                    login.pushUrl = userInfo[@"url"];
                    [[self getPresentedViewController] presentViewController:login animated:YES completion:nil];
//                }
                
            } else {
                WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
                
                __weak WYWebController *weakVC = web;
                weakVC.urlstr = userInfo[@"url"];
                weakVC.isPush = YES;
                [[self getPresentedViewController]  presentViewController:weakVC animated:YES completion:nil];
//                WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
//                web.urlstr = userInfo[@"url"];
//                web.isPush = YES;
//                [[self getPresentedViewController] presentViewController:web animated:YES completion:nil];
            }
        }else if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
            if (!_isShow && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
                NSString *title = userInfo[@"title"];
                NSString *content = userInfo[@"aps"][@"alert"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    } else {
        float msgTime = [userInfo[@"msgTime"] floatValue];
        float expiryTime = [[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] floatValue];
        float expire = (now - msgTime)/1000 - expiryTime;
        NSLog(@"%f_%f_%f_%f",now,msgTime,expiryTime,expire);
        if ( expire < 0) {
            if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
                if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                    if (![[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
                        PhoneNumLoginVC *login = [[PhoneNumLoginVC alloc]initWithNibName:@"PhoneNumLoginVC" bundle:nil];
                        login.isPush = YES;
                        login.pushUrl = userInfo[@"url"];
                        [[self getPresentedViewController] presentViewController:login animated:YES completion:nil];
//                    }
                } else {
                    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
                    
                    __weak WYWebController *weakVC = web;
                    weakVC.urlstr = userInfo[@"url"];
                    weakVC.isPush = YES;
                    [[self getPresentedViewController]  presentViewController:weakVC animated:YES completion:nil];
//                    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
//                    web.urlstr = userInfo[@"url"];
//                    web.isPush = YES;
//                    [[self getPresentedViewController] presentViewController:web animated:YES completion:nil];
                }
            }
            
        }else if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
            if (!_isShow && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {//

                NSString *title = userInfo[@"title"];
                NSString *content = userInfo[@"aps"][@"alert"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }
    [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"CLICK"];
    completionHandler();
}
//====================For iOS 10====================
-(void)pushMsgStatisticWithMsyID:(NSString *)msgID pushStatus:(NSString *)pushStatus
{
    [NetRequest updatePushMsgWithMsgId:msgID deviceid:deviceId pushStatus:pushStatus block:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"PushMsg-%@--%@---%@",pushStatus,responseDicionary,error.localizedDescription);
    }];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
#pragma mark -- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [alertView setHidden:YES];
        if (buttonIndex == 1) {
            if (![_userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [_userInfo[@"url"] length]) {
                
                if ([_userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                    if (![[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
                        PhoneNumLoginVC *login = [[PhoneNumLoginVC alloc]initWithNibName:@"PhoneNumLoginVC" bundle:nil];
                        login.isPush = YES;
                        login.pushUrl = _userInfo[@"url"];
                        [self.window.rootViewController presentViewController:login animated:YES completion:nil];
//                    }
                    
                } else {
                    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
                    web.urlstr = _userInfo[@"url"];
                    web.isPush = YES;
                    web.hidesBottomBarWhenPushed = YES;
                    [self.window.rootViewController presentViewController:web animated:YES completion:nil];
                }
            }
        }
    } else {
        [XLPlist deletePlistByPlistRoute:proactiveLogin ];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
        [self login];
    }
    
}
-(void)login
{
//    UIViewController *start;
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
//        start=[[StartUpLoginVC alloc]init];
//    } else {
//        start=[[PhoneNumLoginVC alloc]init];
//    }
    PhoneNumLoginVC *login=[[PhoneNumLoginVC alloc]init];
    [self.window.rootViewController presentViewController:login animated:YES completion:nil];
}
//注册deviceToken
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken -- >> %@",deviceToken);
//    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:APNSTokenKey];
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[NSUserDefaults standardUserDefaults]setObject:pushToken forKey:APNSTokenKey];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:@{@"apns":pushToken}];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:isRegisterAPNS] && [[NSUserDefaults standardUserDefaults]objectForKey:@"did"] && [[NSUserDefaults standardUserDefaults]objectForKey:APNSTokenKey]) {
        
        [NetRequest registerAPNS:^(NSDictionary *responseDicionary, NSError *error) {
            NSLog(@"-----%@--",responseDicionary);
            if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isRegisterAPNS];
            }
        }];
    }
//    [NetRequest getOpenService:^(NSDictionary *responseDicionary, NSError *error) {
//        NSLog(@"%@",responseDicionary);
//    }];
//    if (!_isShow) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
//            if (notifications.count) {
//                for (UNNotification *noti in notifications) {
//                    NSDictionary *userInfo = noti.request.content.userInfo;
//                    NSString *title = userInfo[@"title"];
//                    NSString *content = userInfo[@"aps"][@"alert"];
//                    if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                        [alert show];
//                        _isShow = YES;
//                    }
//                }
//            }
//        }];
//
//    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
