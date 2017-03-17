//
//  ViewController.m
//  XXProject
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#import "ViewController.h"
#import "XLProgressHUD.h"
#import "FMDB.h"
#import "FMDBTools.h"
#import "NetRequest.h"
#import "XLEncryptionManager.h"
#import "StartUpLoginVC.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
@interface ViewController ()<UIScrollViewDelegate,CoreStatusProtocol,UIAlertViewDelegate>
{
    UIScrollView* _scrollView;
    UIPageControl*_pageControl;
    NSMutableArray*_picArr;
}

@property (weak, nonatomic)  UILabel *labFilePath;
@property (nonatomic, copy) NSString *filePath;



@end

@implementation ViewController

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage=_scrollView.contentOffset.x/screenWidth;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *image = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    image.image = [UIImage imageNamed:@"lanch"];
    [self.view addSubview:image];
    [self examine];
}

#pragma mark  -- 检查是否首次进入应用，是否激活设备
-(void)examine
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@",currentVersion);
    // 获取沙盒存储的应用版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:SaveVersion];
    if ([currentVersion isEqualToString:saveVersion]) {//不是首次进入应用
        if ((![[NSUserDefaults standardUserDefaults] boolForKey:@"whetherActivate"])) {//设备未激活
            [self activateDeviceIsFirst:NO];
        }else{//设备已激活
            [self autoLogin];
        }
    }
    else{//首次进入应用
        [self activateDeviceIsFirst:YES];
        [self setupIntroducePage];//展示引导页
        [[XLPlist sharePlist] setObject:currentVersion forKey:SaveVersion];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isNotFirst"];
    }
//    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isNotFirst"]) {//首次进入应用
//        [self activateDeviceIsFirst:YES];
//        [self setupIntroducePage];//展示引导页
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isNotFirst"];
//    }else{//不是首次进入应用
//        if ((![[NSUserDefaults standardUserDefaults] boolForKey:@"whetherActivate"])) {//设备未激活
//            [self activateDeviceIsFirst:NO];
//        }else{//设备已激活
//            [self autoLogin];
////            [self isLogined];
//        }
//    }
    
    
    
}
#pragma mark -- 激活设备
-(void)activateDeviceIsFirst:(BOOL)isFirst
{
    //激活设备
    [NetRequest ActivateDevide:^(NSDictionary *responseDicionary, NSError *error) {
        if(responseDicionary!=nil&&[[responseDicionary objectForKey:@"resultStatus"]intValue]==1000)
        {
            
            NSLog(@"-----激活设备返回数据==%@",responseDicionary[@"result"]);
            [[NSUserDefaults standardUserDefaults] setObject:[responseDicionary objectForKey:@"result"] forKey:@"did"];
            UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
            [keychainStore setString:responseDicionary[@"result"] forKey:XLDeviceID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"whetherActivate"];
            if (isFirst) {
                [[NSUserDefaults standardUserDefaults]setObject:VISITOR forKey:USERTYPE];
            }else{
                [self autoLogin];
            }
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            //激活设备，登录极光后，上传别名
            [defaultCenter addObserver:self
                              selector:@selector(networkDidLogin:)
                                  name:kJPFNetworkDidLoginNotification
                                object:nil];
            //
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerPush:) name:@"registerPush" object:nil];
        }
        
    }];

}
#pragma mark -- 自动登录
- (void)autoLogin{

    [NetRequest AutoLogin:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"自动成功后返回的值＝＝%@",responseDicionary);
        
        if (error) {
            [[NSUserDefaults standardUserDefaults]setObject:VISITOR forKey:USERTYPE];
        } else {
            if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
                if (!responseDicionary[@"result"]) {
                    [[NSUserDefaults standardUserDefaults]setObject:VISITOR forKey:USERTYPE];
                } else {
                    NSDictionary *result = responseDicionary[@"result"];
                    [[NSUserDefaults standardUserDefaults]setObject:result[@"userType"] forKey:USERTYPE];
                    [self loginRongCloudWithToken:result[@"ryToken"]];
                }
                
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:VISITOR forKey:USERTYPE];
            }
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isNotFirst"]) {
            [self enterApp];
        }
    }];

    
}
-(void)loginRongCloudWithToken:(NSString *)token
{
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        [[XLPlist sharePlist]setObject:userId forKey:RC_UserID];
        
        NSLog(@"登录成功 ,登录用户为 %@",userId);
        
    } error:^(RCConnectErrorCode status) {
        [[XLPlist sharePlist]removeObjectForKey:RC_UserID];
    } tokenIncorrect:^{
        
    }];
}
#pragma mark -- 上传推送别名
-(void)registerPush:(NSNotification*)noti
{
    
    NSString*str=noti.userInfo[@"apns"];
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:APNSTokenKey];
    
    [NetRequest registerAPNS:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"-----%@--",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isRegisterAPNS];
        }
    }];
    
}
- (void)networkDidLogin:(NSNotification *)notification
{
    NSString *did = [[NSUserDefaults standardUserDefaults]objectForKey:@"did"];
    NSLog(@"%@",did);
    [JPUSHService setTags:nil alias:did fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"iResCode:%d  \n tags:%@  \niAlias:%@",iResCode,iTags,iAlias);
    }];
}
-(void)setupIntroducePage{
    NSArray *imageArr = @[@"introduce0.jpg",@"introduce1.jpg",@"introduce2.jpg"];
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.frame=self.view.frame;
    _scrollView.contentSize = CGSizeMake(imageArr.count * screenWidth, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(screenWidth* 0.5, screenHeight - 20);
    pageControl.bounds = CGRectMake(0, 0, 150, 50);
    pageControl.currentPage=0;
    pageControl.numberOfPages = imageArr.count; // 一共显示多少个圆点（多少页）
    // 设置非选中页的圆点颜色
    pageControl.pageIndicatorTintColor = RGB(243, 243, 243, 1);
    // 设置选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    
    // 禁止默认的点击功能
    pageControl.enabled = NO;
    
    [self.view addSubview:pageControl];
    _pageControl = pageControl;
    
    for (int i = 0; i< imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 1.设置frame
        imageView.frame = CGRectMake(i * screenWidth, 0, screenWidth, screenHeight);
        
        // 2.设置图片
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [_scrollView addSubview:imageView];
    }
    
    //Btn
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_scrollView addSubview:btn];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pageControl.mas_top).offset(-20);
        make.centerX.equalTo(_scrollView.mas_left).offset(2.5*screenWidth);
        make.size.mas_equalTo(CGSizeMake(75*KScale, 17.5*KScale));
    }];
    
    btn.layer.cornerRadius=9*KScale;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = RGB(73, 145, 240, 1).CGColor;
    
    [btn setTitle:@"立即开始" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:18];
    [btn setTitleColor:RGB(73, 145, 240, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)isLogined
{
    if (![[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin]) {
        
        NSLog(@"unloginDic====%@",[[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin]);
        
        [self performSelectorOnMainThread:@selector(login) withObject:nil waitUntilDone:NO];
        
    }else
    {
        NSLog(@"loginDic====%@",[[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin]);
        
        UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
        BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
        tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
        win.rootViewController=tabbar;
        
    }
}

-(void)enterClick:(UIButton*)sender
{
//    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults]setObject:VISITOR forKey:USERTYPE];
    [self enterApp];
}
//进入应用
-(void)enterApp
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:isRegisterAPNS]) {
        [self registerPush:nil];

    }
    UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
    BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
    [NetRequest requetWithParams:@[] requestName:@"app.IndexService.themeSwitch" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            if ([responseDicionary[@"result"] isEqualToString:@"DEFAULT"]) {//默认图
                tabbar.isNew = NO;
                [self setIsNewWith:NO];
            } else {//新年图
                tabbar.isNew = YES;
                [self setIsNewWith:YES];
            }
        }else{
            tabbar.isNew = NO;
            [self setIsNewWith:NO];
        }
        win.rootViewController= tabbar;

    }];
    
}
-(void)setIsNewWith:(BOOL)isNew
{
    [[NSUserDefaults standardUserDefaults]setBool:isNew forKey:@"isNewYear"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)login{
    PhoneNumLoginVC *login=[[PhoneNumLoginVC alloc]init];
    [self presentViewController:login animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    //    [XLProgressHUD showOnWindowMessage:@"jibin"];/
//    //     [XLProgressHUD showOnWindowMessage:@"niaho" autoHide:2.0f];
//    [XLProgressHUD showOnView:self.view message:nil animated:YES];
//    //    [XLProgressHUD showOnView:self.view message:@"nihao" animated:NO autoHide:2.0f];
//    [self performSelector:@selector(click) withObject:nil afterDelay:2.f];
}

//- (void)click{
//    //    [XLProgressHUD hideOnWindow];
//    [XLProgressHUD hideOnView:self.view];
//}


//获取手机号
//-(void)getPNumByNodeCodeClick:(id)sender
//{
//    [NetRequest getPNumByNodeCode:^(NSDictionary *responseDicionary, NSError *error) {
//        NSLog(@"根据nodecode返回的电话号码是%@",responseDicionary);
//    }];
//}

@end
