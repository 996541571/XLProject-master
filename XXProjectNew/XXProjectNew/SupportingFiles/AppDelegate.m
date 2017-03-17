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
#import <UMSocialCore/UMSocialCore.h>
#import <WebKit/WebKit.h>
#import "InviteActivityViewController.h"
//#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


//
#import "SimpleMessage.h"
#import "SimpleMessageCell.h"

//极光
static NSString *appKey = @"b14e115eb1efda301fd22cc8";
static NSString *channel = @"Publish channel";
//开发
//static BOOL isProduction = FALSE;
//生产
static BOOL isProduction = TRUE;

//融云 appkey
//开发
//#define RONGCLOUD_IM_APPKEY @"pgyu6atqpgfcu"


//生产
#define RONGCLOUD_IM_APPKEY @"0vnjpoad0v8rz"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate,RCIMReceiveMessageDelegate>
{
    BOOL _isShow; //提示框是否已经弹出
    NSDictionary *_userInfo;
    BOOL _hasPush;
}
@end

@implementation AppDelegate


//程序未启动收到推送，无论是点击推送消息启动应用还是点击了应用图标启动应用都执行此方法；这个方法来启动程序，两者区别在于点击推送消息启动应用会把推送的消息userInfo通过launchOptions参数传递过来
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // 远程通知的内容
NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (launchOptions) {
        
        
        //融云推送
        if (remoteNotificationUserInfo[@"rc"]) {
            
            dispatch_after(
                           
                           dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(),
                           ^{
                               [self localNotificationDidClick:remoteNotificationUserInfo andTitle:remoteNotificationUserInfo[@"aps"][@"alert"]];
                               
                               //remoteNotificationUserInfo[@"aps"][@"alert"]
                           }
                           );
            
            
            
        }else{
        
        //其他推送
        _hasPush = YES;
        NSDictionary* remoteNotification=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [[NSUserDefaults standardUserDefaults]setObject:remoteNotification forKey:remoteNoti];
        if ([remoteNotification[@"msgType"] isEqualToString:@"OFFLINE"]) {
            [[XLPlist sharePlist]deletePlistByPlistRoute:proactiveLogin ];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
        }
            
    }
        
    }
        
    
    [Bugly startWithAppId:@"6d6ac3b52d"];
    UMConfigInstance.appKey = UMAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx4181f82e4f0a3026" appSecret:@"d14c698f345b59e52299306724ed3f96" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
//    [self customUA];
    [self oldCustomUA];
        _isShow = NO;
   
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        application.applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        application.applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
        application.applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
    }
    
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    

        
        
    
    
        //融云初始化
    
        [self initializeForRongYun];
    
    
        //设置代理
        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
        //融云推送
        
        
        /**
         * 推送处理1
         */
    
    
    //iOS 10-----------------------------
    
//    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
//    
//    center.delegate = self;
    
    
    //进行用户权限的申请
//    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        //在block中会传入布尔值granted，表示用户是否同意
//        if (granted) {
//            //如果用户权限申请成功，设置通知中心的代理
//            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        }}];
//    
////    [[RCIM sharedRCIM] setReceiveMessageDelegate:self]
//    
//    
//    //------------------------------------------------
//    
//        if([application
//            respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//            //注册推送, 用于iOS8以及iOS8之后的系统
//            UIUserNotificationSettings *settings = [UIUserNotificationSettings
//                                                    settingsForTypes:(
//                                                                      UIUserNotificationTypeSound |
//                                                                      UIUserNotificationTypeAlert)
//                                                    categories:nil];
//            [application registerUserNotificationSettings:settings];
//            
//        } else {
//            
//            UIRemoteNotificationType myTypes =  
//            UIRemoteNotificationTypeAlert |
//            UIRemoteNotificationTypeSound;
//            [application registerForRemoteNotificationTypes:myTypes];
//        }
    
        
    
    
    
    
    
    return YES;
    
}




///

#pragma mark --
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 红包回调
    
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }

    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark deviceToken
//注册deviceToken
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    NSNotification *notification =[NSNotification notificationWithName:@"registerPush" object:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    /// Required - 注册 DeviceToken
    
    
    
    
    
    /**
     * 推送处理3
     */
    
    //将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书

    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    NSLog(@"------%@",token);
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    


    NSLog(@"%@",[RCIMClient sharedRCIMClient]);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark - JPUSHRegisterDelegate

#pragma mark iOS 10 前台收到推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([userInfo[@"msgType"] isEqualToString:@"FANS"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FANS" object:nil];
        [[XLPlist sharePlist]setObject:@"FANS" forKey:@"FANS"];
    }
    
    NSString *title = userInfo[@"title"];
    NSString *content = userInfo[@"aps"][@"alert"];
    if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
//    else{
//            //发通知刷新首页公告
////            NSNotification *noti = [NSNotification notificationWithName:@"public" object:nil];
////            [[NSNotificationCenter defaultCenter]postNotification:noti];
//            //前台收到推送，提示用户是否查看
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"查看推送消息详情" delegate:self
//                                                 cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            _userInfo = userInfo;
//            alert.tag = 101;
//            [alert show];
//
//    }
    
    [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"RECEIVE"];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
}
#pragma mark iOS 10 点击消息
// iOS 10 点击消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (_hasPush) {
        _hasPush = NO;
        return;
    }
    NSDictionary * userInfo = response.notification.request.content.userInfo;

    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    if ([userInfo[@"msgType"] isEqualToString:@"DAILY_TIP"]) {
        [MobClick event:@"um_push_daily_tip_click_event"];
    }else if ([userInfo[@"msgType"] isEqualToString:@"NEWS"]){
        [MobClick event:@"um_push_news_click_event"];
    }
    if (response.notification.request.content.userInfo[@"rc"]){
        [self localNotificationDidClick:response.notification.request.content.userInfo andTitle:response.notification.request.content.body];
    }else{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
    //判断是否过期
    if ([[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] isEqualToString:@"0"]) {
        //是否需要登录
        if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
            if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin]) {
                [self jumpToLoginWithUrl:userInfo[@"url"]];
            } else {
                if ([userInfo[@"url"] rangeOfString:@"http"].location != NSNotFound) {
                    [self jumpToWebWithUrl:userInfo[@"url"]];
                }else if ([_userInfo[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
                    [self jumpToInviteActivityView];
                }
            }
        }else if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
                NSString *title = userInfo[@"title"];
                NSString *content = userInfo[@"aps"][@"alert"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
        }
    } else {
        float msgTime = [userInfo[@"msgTime"] floatValue];
        float expiryTime = [[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] floatValue];
        float expire = (now - msgTime)/1000 - expiryTime;
        NSLog(@"%f_%f_%f_%f",now,msgTime,expiryTime,expire);
        if ( expire < 0) {
            if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
                if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin]) {
                    [self jumpToLoginWithUrl:userInfo[@"url"]];
                } else {
                    if ([userInfo[@"url"] rangeOfString:@"http"].location != NSNotFound) {
                        [self jumpToWebWithUrl:_userInfo[@"url"]];
                    }else if ([_userInfo[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
                        [self jumpToInviteActivityView];
                    }
//                    [self jumpToWebWithUrl:userInfo[@"url"]];
                }
            }
            
        }else if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
                NSString *title = userInfo[@"title"];
                NSString *content = userInfo[@"aps"][@"alert"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
        }
    }
    [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"CLICK"];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    }
    completionHandler();  // 系统要求执行这个方法
}
//跳转到web页
-(void)jumpToWebWithUrl:(NSString *)url
{
    WYWebController *web = [[WYWebController alloc]init];
    web.urlstr = url;
    web.isPush = YES;
    [self.window.rootViewController  presentViewController:web animated:YES completion:nil];
}
-(void)jumpToInviteActivityView
{
    InviteActivityViewController* vc = [InviteActivityViewController new];
    
    vc.hidesBottomBarWhenPushed = YES;
    [MainNav pushViewController:vc animated:YES];
}
-(void)jumpToLoginWithUrl:(NSString *)url
{
    LoginController *login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    login.hasBack = YES;
    login.isPush = YES;
    login.pushUrl = url;
    [self.window.rootViewController  presentViewController:login animated:YES completion:nil];
}
#pragma mark iOS 7 ~ iOS 9
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"%@--%f",userInfo,now);
    if (application.applicationState == UIApplicationStateActive) {
        if ([userInfo[@"msgType"] isEqualToString:@"FANS"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FANS" object:nil];
            [[XLPlist sharePlist]setObject:@"FANS" forKey:@"FANS"];
        }
        NSString *title = userInfo[@"title"];
        NSString *content = userInfo[@"aps"][@"alert"];
        if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"RECEIVE"];
        }
//        else{
//
//            if ([[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                //发通知刷新首页公告
//                NSNotification *noti = [NSNotification notificationWithName:@"public" object:nil];
//                [[NSNotificationCenter defaultCenter]postNotification:noti];
//                //前台收到推送，提示用户是否查看
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"查看推送消息详情" delegate:self
//                                                     cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                _userInfo = userInfo;
//                alert.tag = 101;
//                [alert show];
//            }
//            
//        }
    }else if (application.applicationState == UIApplicationStateInactive){
        if (_hasPush) {
            _hasPush = NO;
            return;
        }
        if ([userInfo[@"msgType"] isEqualToString:@"DAILY_TIP"]) {
            [MobClick event:@"um_push_daily_tip_click_event"];
        }else if ([userInfo[@"msgType"] isEqualToString:@"NEWS"]){
            [MobClick event:@"um_push_news_click_event"];
        }
        if ([[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] isEqualToString:@"0"]) {
            if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
                NSString *title = userInfo[@"title"];
                NSString *content = userInfo[@"aps"][@"alert"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
                if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin]) {
                    [self jumpToLoginWithUrl:userInfo[@"url"]];
                } else {
                    if ([userInfo[@"url"] rangeOfString:@"http"].location != NSNotFound) {
                        [self jumpToWebWithUrl:userInfo[@"url"]];
                    }else if ([userInfo[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
                        [self jumpToInviteActivityView];
                    }

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
                    NSString *title = userInfo[@"title"];
                    NSString *content = userInfo[@"aps"][@"alert"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }else if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
                    
                    if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin]) {
                        
                        [self jumpToLoginWithUrl:userInfo[@"url"]];
                    } else {
                        if ([userInfo[@"url"] rangeOfString:@"http"].location != NSNotFound) {
                            [self jumpToWebWithUrl:userInfo[@"url"]];
                        }else if ([userInfo[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
                            [self jumpToInviteActivityView];
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
    [JPUSHService handleRemoteNotification:userInfo];
}

//自定义UA
-(void)customUA
{
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    // 获取默认
   [wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *oldAgent = result;
        
        // 给User-Agent添加额外的信息
       NSString *newAgent = [oldAgent stringByAppendingString:@" One Account IOS;Mozilla"];
        // 设置global User-Agent
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
    }];
    
}

-(void)oldCustomUA
{
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
}

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
                if ([_userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin]) {
                    [self jumpToLoginWithUrl:_userInfo[@"url"]];
                } else {
                    if ([_userInfo[@"url"] rangeOfString:@"http"].location != NSNotFound) {
                        [self jumpToWebWithUrl:_userInfo[@"url"]];
                    }else if ([_userInfo[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
                        [self jumpToInviteActivityView];
                    }

                }
            }
        }
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[XLPlist sharePlist]deletePlistByPlistRoute:proactiveLogin ];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
        [self login];
    }
    
}
-(void)login
{
    LoginController *login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    login.hidesBottomBarWhenPushed = YES;
    login.isExit = YES;
    [((UINavigationController*)[(BaseTabBarController *)self.window.rootViewController selectedViewController]) pushViewController:login animated:YES];
//    [self.window.rootViewController presentViewController:login animated:YES completion:nil];
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
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:isRegisterAPNS] && [[NSUserDefaults standardUserDefaults]objectForKey:@"did"] && [[NSUserDefaults standardUserDefaults]objectForKey:APNSTokenKey]) {
//        
//        [NetRequest registerAPNS:^(NSDictionary *responseDicionary, NSError *error) {
//            NSLog(@"-----%@--",responseDicionary);
//            if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
//                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isRegisterAPNS];
//            }
//        }];
//    }
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



#pragma mark 融云初始化

-(void)initializeForRongYun{
    
    
    //融云
    
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    
    /*
     
     获取token
     
     */

    
//    [RCIM sharedRCIM]
    
    
    //成为代理
    [RCIM sharedRCIM].userInfoDataSource=self;
    
    
    //发送消息时携带个人信息(针对安卓端)
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
    
    //红包
    
    //设置红包扩展的Url Scheme。
    [[RCIM sharedRCIM] setScheme:@"rongcloudRedPacket" forExtensionModule:@"JrmfPacketManager"];

    //注册红包消息
    
    //[[RCIMClient sharedRCIMClient] registerMessageType:[RCMessage class]];
    //SDK 初始化方法 initWithAppKey 之后后注册消息类型
    [[RCIMClient sharedRCIMClient]registerMessageType:SimpleMessage.class];
    
    
    
    
    //监听未读消息的代理-------已转移
//    RCIMReceiveMessageDelegate
    
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    
    
    
    
    
}


/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */








    //协议方法
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {

}


/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}



//// 本地通知 ios 10 的点击方法
//
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED{
//    
//    NSLog(@"----------%@",response.notification.request.content.userInfo);
//    
//    NSLog(@"----------%@",response.notification.request.content.body);
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    //融云推送
//    if (response.notification.request.content.userInfo[@"rc"]){
//        [self localNotificationDidClick:response.notification.request.content.userInfo andTitle:response.notification.request.content.body];
//    }else{
//        if (_hasPush) {
//            _hasPush = NO;
//            return;
//        }
//        NSDictionary * userInfo = response.notification.request.content.userInfo;
//        
//        NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
//        if ([userInfo[@"msgType"] isEqualToString:@"DAILY_TIP"]) {
//            [MobClick event:@"um_push_daily_tip_click_event"];
//        }else if ([userInfo[@"msgType"] isEqualToString:@"NEWS"]){
//            [MobClick event:@"um_push_news_click_event"];
//        }else if ([userInfo[@"msgType"] isEqualToString:@"FANS"]){
//            //新增粉丝
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"FANS" object:nil];
//            [[XLPlist sharePlist]setObject:@"FANS" forKey:@"FANS"];
//        }
//        NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
//        //判断是否过期
//        if ([[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] isEqualToString:@"0"]) {
//            //是否需要登录
//            if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
//                if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                    [self jumpToLoginWithUrl:userInfo[@"url"]];
//                } else {
//                    if ([userInfo[@"url"] rangeOfString:@"http"].location != NSNotFound) {
//                        [self jumpToWebWithUrl:userInfo[@"url"]];
//                    }else if ([_userInfo[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
//                        [self jumpToInviteActivityView];
//                    }
//                }
//            }else if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
//                NSString *title = userInfo[@"title"];
//                NSString *content = userInfo[@"aps"][@"alert"];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//        } else {
//            float msgTime = [userInfo[@"msgTime"] floatValue];
//            float expiryTime = [[NSString stringWithFormat:@"%@",userInfo[@"expiryTime"]] floatValue];
//            float expire = (now - msgTime)/1000 - expiryTime;
//            NSLog(@"%f_%f_%f_%f",now,msgTime,expiryTime,expire);
//            if ( expire < 0) {
//                if (![userInfo[@"msgType"] isEqualToString:@"OFFLINE"] && [userInfo[@"url"] length]) {
//                    if ([userInfo[@"loginCheck"] isEqualToString:@"Y"] && ![[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin]) {
//                        [self jumpToLoginWithUrl:userInfo[@"url"]];
//                    } else {
//                        if ([userInfo[@"url"] rangeOfString:@"http"].location != NSNotFound) {
//                            [self jumpToWebWithUrl:_userInfo[@"url"]];
//                        }else if ([_userInfo[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
//                            [self jumpToInviteActivityView];
//                        }
//                        //                    [self jumpToWebWithUrl:userInfo[@"url"]];
//                    }
//                }
//                
//            }else if ([userInfo[@"msgType"] isEqualToString:@"OFFLINE"]) {
//                NSString *title = userInfo[@"title"];
//                NSString *content = userInfo[@"aps"][@"alert"];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//        }
//        [self pushMsgStatisticWithMsyID:userInfo[@"msgId"] pushStatus:@"CLICK"];
//    }
//    
//   
//
//    completionHandler();
//    
//}


//本地通知 ios 10 以下的点击方法

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
// notification为本地通知的内容
    
    NSLog(@"本地通知------------------");
    
    
    NSLog(@"%@",notification.alertBody);
    //融云推送

    
    [self localNotificationDidClick:notification.userInfo andTitle:notification.alertBody];
    
    
}

/**
 * 本地用户信息改变，调用此方法更新kit层用户缓存信息
 * @param userInfo 要更新的用户实体
 * @param userId  要更新的用户Id
 
 - (void)refreshUserInfoCache:(RCUserInfo *)userInfowithUserId:(NSString *)userId;
 
 */


//本地通知必须实现用户信息的代理方法
/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */


/*    
      根据userId访问你们服务器取昵称和头像赋值，
      如果取到过数据后会直接缓存下来就不走这个代理方法了，下次直接从缓存中取的
      内存缓存
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    
    
    NSString* requestName = @"UserService.getUserByPartyId";
    
    NSDictionary* dic = @{@"partyId":userId};
    
    
    
//        onRCIMCustomAlertSound
    
//    [RCIM sharedRCIM];
    
    
    [NetRequest requetWithParams:@[dic] requestName:requestName finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        //如果报错
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSLog(@"%@",responseDicionary);
        
        
        
        
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {
            
            NSDictionary* dic = [responseDicionary valueForKey:@"result"];
            
            
            NSString* nickname = [dic[@"nikerName"] length] > 0 ? dic[@"nikerName"]:[NSString stringWithFormat:@"%@",dic[@"loginName"]];
            
            
            if ([nickname rangeOfString:@"user"].location == NSNotFound &&
                [nickname rangeOfString:@"<"].location == NSNotFound &&
                [nickname rangeOfString:@">"].location == NSNotFound
                ) {
                
                
                
                [NetRequest requetWithParams:@[dic] requestName:requestName finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
                    
                    
                    NSDictionary* dic = [responseDicionary valueForKey:@"result"];
                    
                    
                    NSString* nickname = [dic[@"nikerName"] length] > 0 ? dic[@"nikerName"]:[NSString stringWithFormat:@"%@",dic[@"loginName"]];
                    
                    NSString* headImg = dic[@"headImg"];
                    
                    
                    RCUserInfo* user = [[RCUserInfo alloc]initWithUserId:userId name:nickname portrait:headImg];
                    
                    return completion(user);
                    

                }];
                
            }
            
            
            NSString* headImg = dic[@"headImg"];
            
            
            RCUserInfo* user = [[RCUserInfo alloc]initWithUserId:userId name:nickname portrait:headImg];
            
            //如果是登录的用户
            //这是为发送信息时携带个人信息做准备
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:RC_UserID] isEqualToString:userId]) {
                
                [RCIM sharedRCIM].currentUserInfo = user;
                
            }

            return completion(user);
        }
        
        
        
    }];
        
        
        
        

    
}

-(void)localNotificationDidClick:(NSDictionary*)userInfo andTitle:(NSString*)title{
    if (!userInfo[@"rc"]) {
        return;
    }
    NSRange range = [title rangeOfString:@":"];
    
    title = [title substringToIndex:range.location];

    
    NSDictionary *msgDic = [userInfo objectForKey:@"rc"];
    
    NSString *cType = [msgDic objectForKey:@"cType"];//会话类型。PR 指单聊、 DS 指讨论组、
    //GRP 指群组、 CS 指客服、SYS 指系统会话、 MC 指应用内公众服务、 MP 指跨应用公众服务。
    
    NSString *fId = [msgDic objectForKey:@"fId"];//消息发送者的用户 ID。
    
    NSString *oName = [msgDic objectForKey:@"oName"];//消息类型，参考融云消息类型表.消息标志；
    //可自定义消息类型。
    
    NSString *targetId = [msgDic objectForKey:@"tId"];//Target ID 。
    
    /*
     cType根据得到字段转换成相应的conversationType
     其余信息可根据需求进行相应的操作
     */
    
    //跳转相应聊天会话View Controller对象
    DVConversationVC *chat = [[DVConversationVC alloc]init];
    
    chat.hidesBottomBarWhenPushed = YES;
    
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等,为转换后的值
    //目前只有单聊
    chat.conversationType = ConversationType_PRIVATE;
    
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = targetId;
    
    //设置聊天会话界面要显示的标题
    chat.title = title;
    
    //显示聊天会话界面
    if ([self.window.rootViewController isKindOfClass:
         [BaseTabBarController class]]) {
    
        if([((UINavigationController*)[(BaseTabBarController *)self.window.rootViewController selectedViewController]).topViewController isKindOfClass:[DVConversationVC class]]){
            
            
        }else{
            
            [((UINavigationController*)[(BaseTabBarController *)self.window.rootViewController selectedViewController]) pushViewController:chat animated:YES];
        }
        
        
        
        
    } else {
        
    }
    
    
}




//前台收到消息
-(BOOL)onRCIMCustomAlertSound:(RCMessage *)message{
    
    return YES;
    
}
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    
}


//红包函数

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
//    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
//        return YES;
//    }
//    return YES;
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
//        return YES;
//    }
//    return YES;
//}
@end
