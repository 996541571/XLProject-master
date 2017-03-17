//
//  ScrollToNextVC.m
//  XXProjectNew
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "WYWebController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UShareUI/UShareUI.h>
@interface WYWebController ()<UIWebViewDelegate>
{
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    UIImageView*nodataImgView;
    UIView*grayView;
    UIButton*nodataBtn;
    UILabel*firstLab;
    UILabel*secondLab;

}

@property (weak, nonatomic) IBOutlet UILabel *headerLab;
@end

@implementation WYWebController
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = YES;
    [self.myWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
    
    
    grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.myWeb.frame.size.width,  self.myWeb.frame.size.height)];
    grayView.backgroundColor=[UIColor lightGrayColor];
    [self.myWeb addSubview:grayView];
    
    
    nodataImgView=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2-69, screenHeight/3, 137,90)];
    nodataImgView.image=[UIImage imageNamed:@"noNet"];
    [self.myWeb addSubview:nodataImgView];
    nodataBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight/3, screenWidth, 120)];
    [self.myWeb addSubview:nodataBtn];
    nodataBtn.userInteractionEnabled=YES;
    [nodataBtn addTarget:self action:@selector(nodataPress:) forControlEvents:UIControlEventTouchUpInside];
    
    firstLab=[[UILabel alloc]initWithFrame:CGRectMake(0, nodataImgView.frame.origin.y+90+20, screenWidth, 16)];
    firstLab.font=[UIFont systemFontOfSize:14];
    firstLab.textAlignment=NSTextAlignmentCenter;
    firstLab.text=@"您的网络太慢了~";
    firstLab.textColor=RGB(238, 238, 238, 1);
    [self.myWeb addSubview:firstLab];
    secondLab=[[UILabel alloc]initWithFrame:CGRectMake(0, firstLab.frame.origin.y+16+20, screenWidth, 16)];
    secondLab.font=[UIFont systemFontOfSize:14];
    secondLab.textAlignment=NSTextAlignmentCenter;
    secondLab.text=@"点击我刷新一下试试吧";
    secondLab.textColor=RGB(238, 238, 238, 1);
    [self.myWeb addSubview:secondLab];

    

    if([CoreStatus isNetworkEnable])
    {
        
        [_progressLayer startLoad];
        [grayView removeFromSuperview];
        [nodataBtn removeFromSuperview];
        [nodataImgView removeFromSuperview];
        [firstLab removeFromSuperview];
        [secondLab removeFromSuperview];
        
    }

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isDelete)
    {
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    }
    
    

    
    NSLog(@"cookieValue====%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"]);
    
    NSArray*arr=[[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"] componentsSeparatedByString:@";"];
    
    NSLog(@"---%@",arr[0]);
    
    if ([arr.firstObject length]) {
        NSString*str= [arr[0] substringFromIndex:12];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 @".xianglin.cn", NSHTTPCookieDomain,
                                 @"/", NSHTTPCookiePath,
                                 @"XLSESSIONID",  NSHTTPCookieName,
                                 str , NSHTTPCookieValue,
                                 nil]];
        
        
        NSLog(@"%@",cookie);
        
        
        // 设定 cookie 到 storage 中
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    
     NSLog(@"cookieValue====%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"]);
    
    
    self.myWeb=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0.1*screenHeight, screenWidth, 0.9*screenHeight)];
    self.myWeb.backgroundColor=RGB(238, 238, 238, 1);
    self.myWeb.delegate=self;
    
    NSLog(@"----------self.urlStr===%@",self.urlstr);
    [self.myWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
    [self.view addSubview:self.myWeb];
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, screenHeight*0.1-2, SCREEN_WIDTH, 2);
    
    [self.view.layer addSublayer:_progressLayer];


}




- (void)webViewDidStartLoad:(UIWebView *)webView {
    
//    if([CoreStatus isNetworkEnable])
//    {
//    
//    [_progressLayer startLoad];
//    [grayView removeFromSuperview];
//    [nodataBtn removeFromSuperview];
//    [nodataImgView removeFromSuperview];
//    [firstLab removeFromSuperview];
//    [secondLab removeFromSuperview];
//        
//    }
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//        if([CoreStatus isNetworkEnable])
//        {
//    
//        [_progressLayer startLoad];
//        [grayView removeFromSuperview];
//        [nodataBtn removeFromSuperview];
//        [nodataImgView removeFromSuperview];
//        [firstLab removeFromSuperview];
//        [secondLab removeFromSuperview];
//            
//        }


    
//    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.headerLab.text=title;
   
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        //定义好JS要调用的方法, statistic_UM_WithEventID就是调用的方法名
        context[@"statistic_UM_WithEventID"] = ^() {
            NSArray *args = [JSContext currentArguments];
            for (JSValue *jsVal in args) {
                NSLog(@"%@", jsVal.toString);
                [MobClick event:jsVal.toString];
            }
        
        };
    context[@"rewardResult"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
            [self.navigationController popViewControllerAnimated:YES];
            self.block(jsVal.toString);
        }
        
    };
//    toLogin
    context[@"toLogin"] = ^() {
            LoginController *login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
    };
    context[@"toFirstPage"] = ^() {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
//        UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
//        win.rootViewController=[[BaseTabBarController alloc]init];
//        [self presentViewController:win.rootViewController animated:YES completion:nil];
    };
    context[@"toShare"] = ^() {
        NSArray *args = [JSContext currentArguments];
        if (args.count == 5) {
            UMSocialPlatformType type;
            if ([[args.lastObject toString] isEqualToString:@"WEIXIN"]) {
                type = UMSocialPlatformType_WechatSession;
            } else {
                type = UMSocialPlatformType_WechatTimeLine;
            }
            [self shareWebPageToPlatformType:type url:[args[3] toString] title:[args[0] toString] msg:[args[1] toString] imgStr:[args[2] toString]];
        }

    };
    [_progressLayer finishedLoad];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   [_progressLayer finishedLoad];
    
    
    if(![CoreStatus isNetworkEnable])
    {
        grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.myWeb.frame.size.width,  self.myWeb.frame.size.height)];
        grayView.backgroundColor=[UIColor lightGrayColor];
        [self.myWeb addSubview:grayView];
        nodataImgView=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2-69, screenHeight/3, 137,90)];
        nodataImgView.image=[UIImage imageNamed:@"noNet"];
        [self.myWeb addSubview:nodataImgView];
        nodataBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight/3, screenWidth, 120)];
//        nodataBtn.backgroundColor=[UIColor redColor];
        [self.myWeb addSubview:nodataBtn];
        nodataBtn.userInteractionEnabled=YES;
        [nodataBtn addTarget:self action:@selector(nodataPress:) forControlEvents:UIControlEventTouchUpInside];
        
        firstLab=[[UILabel alloc]initWithFrame:CGRectMake(0, nodataImgView.frame.origin.y+90+20, screenWidth, 16)];
        firstLab.font=[UIFont systemFontOfSize:14];
        firstLab.textAlignment=NSTextAlignmentCenter;
        firstLab.text=@"您的网络太慢了~";
        firstLab.textColor=RGB(238, 238, 238, 1);
        [self.myWeb addSubview:firstLab];
        secondLab=[[UILabel alloc]initWithFrame:CGRectMake(0, firstLab.frame.origin.y+16+20, screenWidth, 16)];
        secondLab.font=[UIFont systemFontOfSize:14];
        secondLab.textAlignment=NSTextAlignmentCenter;
        secondLab.text=@"点击我刷新一下试试吧";
        secondLab.textColor=RGB(238, 238, 238, 1);
        [self.myWeb addSubview:secondLab];
        
    }
    

}
-(void)shareToWechatWithPlatFormType:(UMSocialPlatformType)type Url:(NSString *)url title:(NSString *)title msg:(NSString *)msg imgUrl:(NSString *)imgUrl
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        //微信好友
        [[NoticeTool notice]showTips:@"您未安装微信" onView:self.view];
        return;
    }
    [self shareWebPageToPlatformType:type url:url title:title msg:msg imgStr:imgUrl];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType url:(NSString*)urlStr title:(NSString*)title msg:(NSString*)msg imgStr:(NSString*)imgStr
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = imgStr;
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:msg thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = urlStr;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
    
}
- (void)alertWithError:(NSError *)error
{
    if (!error) {//分享成功
        NSString *jsStr = [NSString stringWithFormat:@"UserShareFun('%@')",@"true"];
        [self.myWeb stringByEvaluatingJavaScriptFromString:jsStr];
    }
    else{
        NSString *jsStr = [NSString stringWithFormat:@"UserShareFun('%@')",@"false"];
        [self.myWeb stringByEvaluatingJavaScriptFromString:jsStr];
    }
    
}
-(void)nodataPress:(UIButton*)sender
{
    if (![CoreStatus isNetworkEnable]) {
        return;
    }
    
    [self.myWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
}
- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    
    NSLog(@"web dealloc");
}

- (IBAction)backPress:(UIButton *)sender {

    if([self.myWeb canGoBack]){
        
        [self.myWeb goBack];
    }else
    {
        if (_isPush) {
            [self dismissViewControllerAnimated:YES completion:^{
                UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
                BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
                tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
                win.rootViewController=tabbar;
            }];            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            
            if(self.close_blcok){
                
                self.close_blcok();
            }

            
        }
        
    }
    
}
- (IBAction)closePress:(UIButton *)sender {
    if (_isPush) {
        [self dismissViewControllerAnimated:YES completion:^{
            UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
            BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
            tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
            win.rootViewController=tabbar;
        }];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    if(self.close_blcok){
        
        self.close_blcok();
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
