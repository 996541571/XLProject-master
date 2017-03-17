//
//  WKWebVC.m
//  XXProjectNew
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "WKWebVC.h"
#import <WebKit/WebKit.h>
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
@interface WKWebVC ()
<
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler
>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,assign)CGFloat delayTime;
@property(nonatomic,strong)UIImageView  *nodataImgView;
@property(nonatomic,strong)UIView       *grayView;
@property(nonatomic,strong)UIButton     *nodataBtn;
@property(nonatomic,strong)UILabel      *firstLab;
@property(nonatomic,strong)UILabel      *secondLab;
@property(nonatomic,strong)NSMutableURLRequest *request;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation WKWebVC

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self initNav];
    
    if (![CoreStatus isNetworkEnable]) {
        [self noData];
        return;
    }
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.urlstr);
    self.automaticallyAdjustsScrollViewInsets = NO;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    //支持内嵌视频播放
    config.allowsInlineMediaPlayback = YES;
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
//    window.webkit.messageHandlers.NativeMethod.postMessage("传参");
    [userContentController addScriptMessageHandler:self name:@"statistic_UM_WithEventID"];
    [userContentController addScriptMessageHandler:self name:@"rewardResult"];
    [userContentController addScriptMessageHandler:self name:@"toLogin"];
    [userContentController addScriptMessageHandler:self name:@"toFirstPage"];
    config.userContentController = userContentController;
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
//    preferences.minimumFontSize = 40.0;
    config.preferences = preferences;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64) configuration:config];

    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    //右滑返回手势
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self loadRequest];
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, 5)];
    self.progressView.progressTintColor = [UIColor greenColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];

}
-(void)loadRequest
{
    [self.webView loadRequest:self.request];
}
-(NSMutableURLRequest *)request
{
    if (!_request) {
        _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]];
        NSString *cookie = [[NSUserDefaults standardUserDefaults]objectForKey:@"cookie" ];
        if (![cookie isEqualToString:@""]) {
            [_request setValue:cookie forHTTPHeaderField:@"Cookie"];
            NSLog(@"---cookie=====%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie" ]);
        }
    }
    return _request;
}
-(NSString *)setCookie
{
    NSMutableString *cookieStr = [[NSMutableString alloc] init];

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
        
        [cookieStr appendFormat:@"%@=%@",cookie.name,cookie.value];
        NSLog(@"%@",cookieStr);
        // 设定 cookie 到 storage 中
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    NSLog(@"cookieValue====%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"]);
    return cookieStr;
}
-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress < 1.0) {
            self.delayTime = 1 - self.webView.estimatedProgress;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 0;
        });
    }else if ([keyPath isEqualToString:@"title"]){
        self.titleLab.text = self.webView.title;
    }
}
#pragma mark -- WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    
    if ([message.name isEqualToString:@"statistic_UM_WithEventID"]) {
        NSLog(@"%@", message.body);
        [MobClick event:message.body];
    } else if ([message.name isEqualToString:@"rewardResult"]) {
//        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@", message.body);
        self.block(message.body);
    }else if ([message.name isEqualToString:@"toLogin"]) {
        NSLog(@"%@", message.body);
        LoginController *login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        
    }else if ([message.name isEqualToString:@"toFirstPage"]){
        [self toFirstPage];
    }
}
#pragma mark - WKNavigationDelegate
//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"didStartProvisionalNavigation == %@",navigation);
}

//页面加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"didFinishNavigation == %@",navigation);
}

//内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"didCommitNavigation == %@",navigation);
}

//在发送请求之前，决定是否跳转
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"decidePolicyForNavigationResponse   ====    %@", navigationAction.request.URL);
    
    if ([navigationAction.request.URL isEqual:[NSURL URLWithString:@"https://kyfw.12306.cn/otn/appDownload/init"]]) {
        NSURL* url = [[NSURL alloc]initWithString:@"itms-apps://kyfw.12306.cn/otn/appDownload/iosdownload"];

        [[UIApplication sharedApplication]openURL:url];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
//收到响应后，决定是否跳转
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"decidePolicyForNavigationResponse   ====    %@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//加载HTTPS的链接，需要权限认证时调用
-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
        }
    }else{
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

#pragma mark - WKUIDelegate

// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}


-(void)nodataPress:(UIButton*)sender
{
    if ([CoreStatus isNetworkEnable]) {
        [self loadRequest];
        [self removeSubviews];
    }
    
}

-(void)noData
{
    [self.webView addSubview:self.grayView];
    [self.webView addSubview:self.nodataImgView];
    [self.webView addSubview:self.nodataBtn];
    [self.webView addSubview:self.firstLab];
    [self.webView addSubview:self.secondLab];
}
-(void)removeSubviews
{
    [self.grayView removeFromSuperview];
    [self.nodataBtn removeFromSuperview];
    [self.nodataImgView removeFromSuperview];
    [self.firstLab removeFromSuperview];
    [self.secondLab removeFromSuperview];
}
-(UIImageView *)nodataImgView
{
    if (!_nodataImgView) {
        _nodataImgView=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2-69, screenHeight/3, 137,90)];
        _nodataImgView.image=[UIImage imageNamed:@"noNet"];
    }
    return _nodataImgView;
}
-(UIButton *)nodataBtn
{
    if (!_nodataBtn) {
        _nodataBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight/3, screenWidth, 120)];
        _nodataBtn.userInteractionEnabled=YES;
        [_nodataBtn addTarget:self action:@selector(nodataPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nodataBtn;
}
-(UIView *)grayView
{
    if (!_grayView) {
        _grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth,  screenHeight - 64)];
        _grayView.backgroundColor=[UIColor lightGrayColor];
    }
    return _grayView;
}
-(UILabel *)firstLab
{
    if (!_firstLab) {
        _firstLab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.nodataImgView.frame.origin.y+90+20, screenWidth, 16)];
        _firstLab.font=[UIFont systemFontOfSize:14];
        _firstLab.textAlignment=NSTextAlignmentCenter;
        _firstLab.text=@"您的网络太慢了~";
        _firstLab.textColor=RGB(238, 238, 238, 1);
    }
    return _firstLab;
}
-(UILabel *)secondLab
{
    if (!_secondLab) {
        _secondLab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.firstLab.frame.origin.y+16+20, screenWidth, 16)];
        _secondLab.font=[UIFont systemFontOfSize:14];
        _secondLab.textAlignment=NSTextAlignmentCenter;
        _secondLab.text=@"点击我刷新一下试试吧";
        _secondLab.textColor=RGB(238, 238, 238, 1);
    }
    return _secondLab;
}
-(void)initNav
{
//    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
//    
//    imgView.userInteractionEnabled = true;
//    
//    imgView.image = [UIImage imageNamed:@"back"];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
//    
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
//    [imgView addGestureRecognizer:singleTapGestureRecognizer];

    UIButton *close = [[UIButton alloc]init];
    if ([self.urlstr containsString:@"/home/nodeManager/topNews"]) {//新闻
        self.titleLab.textColor = [UIColor redColor];
        
        close.frame = CGRectMake(screenWidth - 47, 27, 36, 36);
        [close setTitle:@"" forState:UIControlStateNormal];
        [close addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [close setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [close setContentEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    } else {
        close.frame = CGRectMake(screenWidth - 50, 37, 40, 15);
        [close setTitle:@"关闭" forState:UIControlStateNormal];
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        close.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [close setTitleColor:RGB(153, 153, 153, 1) forState:UIControlStateNormal];
    }
    [self.headView addSubview:close];

}
- (IBAction)back:(UIButton *)sender {
    if([self.webView canGoBack]){
        
        [self.webView goBack];
    }else
    {
        if (_isPush) {
                UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
            BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
            tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
                win.rootViewController=tabbar;
            
                [self presentViewController:win.rootViewController animated:YES completion:nil];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

-(void)backToLastView{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        if (_isPush) {
            [self toFirstPage];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (IBAction)close:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
-(void)close
{
    if (_isPush) {
        [self toFirstPage];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }


}
-(void)toFirstPage
{
    UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
    BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
    tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
    win.rootViewController=tabbar;
    [self presentViewController:win.rootViewController animated:YES completion:nil];
}
- (void)share:(UIButton *)sender {
    [MobClick event:@"um_main_news_share_click_event"];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        //微信
        [[NoticeTool notice]showTips:@"您未安装微信" onView:self.view];
        return;
    }
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UIImage *titleImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.msgImage]]];
    
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.msgTitle descr:self.message thumImage:titleImg];
        //设置网页地址
        shareObject.webpageUrl = self.urlstr;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];
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
