//
//  NoticeTool.m
//  XXProjectNew
//
//  Created by apple on 2016/10/28.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "NoticeTool.h"

@interface NoticeTool ()
@property(nonatomic,strong)UILabel *myAlertLabel;
@end

@implementation NoticeTool
static id _instance;
+(instancetype)notice
{
    @synchronized(self){
        if(_instance == nil){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
-(id)copyWithZone:(struct _NSZone *)zone{
    return _instance;
}

-(void)expireNoticeOnController:(UIViewController *)vc
{
    [[XLPlist sharePlist] deletePlistByPlistRoute:proactiveLogin ];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    LoginController *start=[[LoginController alloc]init];
    start.isExit = YES;
    start.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:start animated:YES];
//    [vc presentViewController:start animated:NO completion:^{
        self.myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake((screenWidth-150)/2, screenHeight-49-94, 150, 30)];  //起始高度设的大点
        self.myAlertLabel.text=@"会话过期，请重新登录";
        self.myAlertLabel.layer.cornerRadius=6;
        self.myAlertLabel.layer.masksToBounds = YES;
        self.myAlertLabel.font=[UIFont systemFontOfSize:14];
        self.myAlertLabel.textAlignment=NSTextAlignmentCenter;
        [start.view addSubview:self.myAlertLabel];
        self.myAlertLabel.textColor=[UIColor whiteColor];
        self.myAlertLabel.backgroundColor=[UIColor blackColor];
        [UIView animateWithDuration:1  //动画时间
                              delay:3  //开始延迟时间
                            options: UIViewAnimationOptionCurveEaseInOut  //弹入弹出
                         animations:^{
                             self.myAlertLabel.alpha=0;
                         }
                         completion:^(BOOL finished){
                             if (finished)
                                 [self.myAlertLabel removeFromSuperview];  //移动后隐藏
                         }];

//    }];

}

-(void)showTips:(NSString *)tips onController:(UIViewController *)vc
{
    self.myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake((screenWidth-150)/2, screenHeight-49-100, 180, 30)];  //起始高度设的大点
    self.myAlertLabel.text= tips;
    self.myAlertLabel.layer.cornerRadius=6;
    self.myAlertLabel.layer.masksToBounds = YES;
    self.myAlertLabel.font=[UIFont systemFontOfSize:14];
    self.myAlertLabel.textAlignment=NSTextAlignmentCenter;
    self.myAlertLabel.adjustsFontSizeToFitWidth = YES;
    [vc.view addSubview:self.myAlertLabel];
    self.myAlertLabel.textColor=[UIColor whiteColor];
    self.myAlertLabel.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:1  //动画时间
                          delay:3  //开始延迟时间
                        options: UIViewAnimationOptionCurveEaseInOut  //弹入弹出
                     animations:^{
                         self.myAlertLabel.alpha=0;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.myAlertLabel removeFromSuperview];  //移动后隐藏
                     }];

}
-(void)showTips:(NSString *)tips onView:(UIView *)view
{
    self.myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake((screenWidth-150)/2, screenHeight-49-100, 150, 30)];  //起始高度设的大点
    self.myAlertLabel.text= tips;
    self.myAlertLabel.layer.cornerRadius=6;
    self.myAlertLabel.layer.masksToBounds = YES;
    self.myAlertLabel.font=[UIFont systemFontOfSize:14];
    self.myAlertLabel.textAlignment=NSTextAlignmentCenter;
    self.myAlertLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:self.myAlertLabel];
    self.myAlertLabel.textColor=[UIColor whiteColor];
    self.myAlertLabel.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:1  //动画时间
                          delay:3  //开始延迟时间
                        options: UIViewAnimationOptionCurveEaseInOut  //弹入弹出
                     animations:^{
                         self.myAlertLabel.alpha=0;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.myAlertLabel removeFromSuperview];  //移动后隐藏
                     }];
}
@end
