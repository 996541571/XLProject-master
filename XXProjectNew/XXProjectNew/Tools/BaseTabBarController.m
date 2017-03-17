//
//  BaseTabBarController.m
//  KXTTest222
//
//  Created by 张鹏伟 on 15/8/25.
//  Copyright (c) 2015年 108. All rights reserved.
//

#import "BaseTabBarController.h"
#import "FirstPageController.h"
#import "EarnMoneyController.h"
#import "MineController.h"
#import "ConfigurationTheme.h"








@interface BaseTabBarController ()<UITabBarDelegate>

@end

@implementation BaseTabBarController
{
    NSDictionary *_contentDic;
    NSArray *_tabBarImageArray;
    NSArray *_selectedTabBarImageArray;
    UIColor *_titleColor;
    UIColor *_selectedtitleColor;
    NSString *_tmpString;

}
//创建TabBar单例,防止多次创建
+(BaseTabBarController *) sharedInstance{
    
    static BaseTabBarController *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
   
    
    //设置tabBar的背景颜色
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.077*screenHeight)];
//    _bgView.backgroundColor = [[ConfigurationTheme shareInstance] getThemeColorWithName:@"bgColor"];
    [self.tabBar insertSubview:_bgView atIndex:0];
    self.tabBar.opaque = YES;

    // Do any additional setup after loading the view.
}
-(void)setIsNew:(BOOL)isNew
{
    _isNew = isNew;
    
    if (!isNew) {
        _tabBarImageArray =[NSArray arrayWithObjects:@"firstTab",@"convenience_secondTab",@"thirdTab",nil];
        _selectedTabBarImageArray =[NSArray arrayWithObjects:@"selectFirstTab",@"convenience_selectSecondTab",@"selectThirdTab", nil];
        _titleColor = RGB(128, 128, 128, 1.0f);
        _selectedtitleColor = RGB(47, 150, 255, 1.0f);
    } else {
        _tabBarImageArray =[NSArray arrayWithObjects:@"xin",@"nian",@"hao",nil];
        _selectedTabBarImageArray =[NSArray arrayWithObjects:@"xin_clicked",@"nian_clicked",@"hao_clicked", nil];
        _titleColor = RGB(51, 51, 51, 1.0f);
        _selectedtitleColor = RGB(255, 65 , 65, 1.0f);
    }
    
    //    _selectedtitleColor=[UIColor blueColor];
    
    [self initTabBar];
}
- (void)initTabBar{
    //首页
    FirstPageController *firstVC = [[FirstPageController alloc] init];
    UINavigationController *firstNav = [self navWithVC:firstVC];//[[UINavigationController alloc] initWithRootViewController:firstVC];
    firstNav.navigationBarHidden=YES;

    CGFloat titleSize;
    if (_isNew) {
        titleSize = 10.f;
    } else {
        titleSize = 12.f;
    }
    
    [self setTabBarItem:firstVC.tabBarItem Title:@"首页" withTitleSize:titleSize selectedImage:_selectedTabBarImageArray[0] withTitleColor:_selectedtitleColor unselectedImage:_tabBarImageArray[0] withTitleColor:_titleColor];
    
    
    //便民
    
    ConveniencePageViewController* CPVC = [[ ConveniencePageViewController alloc]init];
        UINavigationController *CP_Nav = [self navWithVC:CPVC];
    CP_Nav.navigationBarHidden=YES;

    [self setTabBarItem:CP_Nav.tabBarItem Title:@"便民" withTitleSize:titleSize selectedImage:_selectedTabBarImageArray[1] withTitleColor:_selectedtitleColor unselectedImage:_tabBarImageArray[1] withTitleColor:_titleColor];
    
    //赚钱
    /*
     
     
    EarnMoneyController * moneyVC = [[EarnMoneyController alloc] init];
    UINavigationController *moneyNav = [self navWithVC:moneyVC];//[[UINavigationController alloc] initWithRootViewController:moneyVC];
    moneyNav.navigationBarHidden=YES;


    [self setTabBarItem:moneyVC.tabBarItem Title:@"便民" withTitleSize:12.0 selectedImage:_selectedTabBarImageArray[1] withTitleColor:_selectedtitleColor unselectedImage:_tabBarImageArray[1] withTitleColor:_titleColor];
     
     
     */

    
    //我的
    
    MineController *mineVC = [[MineController alloc] init];
    UINavigationController *mineNav = [self navWithVC:mineVC];//[[UINavigationController alloc] initWithRootViewController:mineVC];

    [self setTabBarItem:mineVC.tabBarItem Title:@"我的" withTitleSize:titleSize selectedImage:_selectedTabBarImageArray[2] withTitleColor:_selectedtitleColor unselectedImage:_tabBarImageArray[2] withTitleColor:_titleColor];

    //    mineNav.navigationBarHidden=NO;
    
    self.viewControllers = @[firstNav,CP_Nav,mineNav];

}

-(UINavigationController *)navWithVC:(UIViewController *)vc
{
    UINavigationController  * nav = [[UINavigationController
                                      alloc]initWithRootViewController:vc];
    nav.navigationBar.barTintColor = [UIColor whiteColor];// 设置导航栏的背景颜色
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:RGB(0, 122, 255, 1), NSFontAttributeName:[UIFont systemFontOfSize:18]};// 设置title的字体颜色
    return nav;

}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                Title:(NSString *)title
        withTitleSize:(CGFloat)size
        selectedImage:(NSString *)selectedImage
       withTitleColor:(UIColor *)selectColor
      unselectedImage:(NSString *)unselectedImage
       withTitleColor:(UIColor *)unselectColor{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //未选中字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
    
    //选中字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateSelected];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateSelected];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"首页"]) {
        [MobClick event:@"um_main_Homepage_click_event"];
    }else if ([item.title isEqualToString:@"便民"]){
        [MobClick event:@"um_main_Convenient_click_event"];
    }else if ([item.title isEqualToString:@"我的"]){
        [MobClick event:@"um_main_My_click_event"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
