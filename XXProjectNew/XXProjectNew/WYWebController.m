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
-(void)viewWillAppear:(BOOL)animated
{
    [self.myWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        // 设定 cookie 到 storage 中
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
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
    [_progressLayer startLoad];
    [grayView removeFromSuperview];
    [nodataBtn removeFromSuperview];
    [nodataImgView removeFromSuperview];
    [firstLab removeFromSuperview];
    [secondLab removeFromSuperview];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
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
        };;
    
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
            if ([XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
                UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
                win.rootViewController=[[BaseTabBarController alloc]init];
                [self presentViewController:win.rootViewController animated:YES completion:nil];
            } else {
//                UIViewController *start;
//                if ([[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
//                    start=[[StartUpLoginVC alloc]init];
//                } else {
                  PhoneNumLoginVC *start=[[PhoneNumLoginVC alloc]init];
//                }
                __weak WYWebController *weakSelf = self;
//                PhoneNumLoginVC *vc = [[PhoneNumLoginVC alloc]init];
                [weakSelf presentViewController:start animated:YES completion:nil];
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}
- (IBAction)closePress:(UIButton *)sender {
    if (_isPush) {
        if ([XLPlist getPlistDicByAppendPlistRoute:proactiveLogin]) {
            UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
            win.rootViewController=[[BaseTabBarController alloc]init];
            [self presentViewController:win.rootViewController animated:YES completion:nil];
        } else {
//            UIViewController *start;
//            if ([[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
//                start=[[StartUpLoginVC alloc]init];
//            } else {
               PhoneNumLoginVC *start=[[PhoneNumLoginVC alloc]init];
//            }
            __weak WYWebController *weakSelf = self;
//            PhoneNumLoginVC *vc = [[PhoneNumLoginVC alloc]init];
            [weakSelf presentViewController:start animated:YES completion:nil];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
