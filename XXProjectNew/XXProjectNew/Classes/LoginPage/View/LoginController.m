//
//  LoginController.m
//  XXProjectNew
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "LoginController.h"
#import "ViewController.h"
@interface LoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberTextF;
@property (weak, nonatomic) IBOutlet UITextField *snsTextF;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;

@end

@implementation LoginController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    if (!_hasBack) {
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
        
        imgView.userInteractionEnabled = true;
        
        imgView.image = [UIImage imageNamed:@"back"];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
        
        [imgView addGestureRecognizer:singleTapGestureRecognizer];
    }
    
    [self initUI];
    
}
-(void)initUI
{
    [self view:self.numberView setCornerRadioWithValue:5.f hasBorderColor:YES];
    [self view:self.codeView setCornerRadioWithValue:5.f hasBorderColor:YES];
    [self view:self.loginBtn setCornerRadioWithValue:17.f hasBorderColor:NO];
}
- (IBAction)snsCode:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *phoneNum = self.numberTextF.text;
    NSString *first;
    if (phoneNum.length) {
        first = [phoneNum substringToIndex:1];
    }
    if ([phoneNum isEqualToString:@""] ||![first isEqualToString:@"1"]||phoneNum.length != 11) {
        [[NoticeTool notice]showTips:@"请输入正确的手机号" onController:self];
        return;
    }
    NSArray *params = @[@{@"mobilePhone":phoneNum}];
    [NetRequest requetWithParams:params requestName:@"AppLoginService.smsCodeSend" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            [[XLPlist sharePlist]reGetIdentityCode:sender];
            self.noticeView.hidden = NO;
            if ([responseDicionary[@"result"] integerValue] == 1) {
                self.noticeLab.text = @"该号码尚未注册，验证通过将自动注册并登录。";
            }else{
                self.noticeLab.text = @"验证码偶尔会延迟2分钟到达，请注意查收手机短信。";
            }
        }else{
            [[NoticeTool notice]showTips:responseDicionary[@"tips"] onController:self];
        }
    }];
}
- (IBAction)login:(UIButton *)sender {
    if (![CoreStatus isNetworkEnable]) {
        [[NoticeTool notice]showTips:@"网络无法连接" onController:self];
        return;
        
    }
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"whetherActivate"]) {
        
        [NetRequest ActivateDevide:^(NSDictionary *responseDicionary, NSError *error) {
            
            if(responseDicionary!=nil&&[[responseDicionary objectForKey:@"resultStatus"]intValue]==1000)
            {
                NSLog(@"-----激活设备返回数据==%@",responseDicionary);
                [[NSUserDefaults standardUserDefaults] setObject:[responseDicionary objectForKey:@"result"] forKey:@"did"];
                UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
                [keychainStore setString:responseDicionary[@"result"] forKey:XLDeviceID];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"whetherActivate"];
                [self loginRequest];
            }
        }];
        
    }else{
        [self loginRequest];
    }

    
}
-(void)loginRequest
{
    if ([self.numberTextF.text isEqualToString:@""]||[self.snsTextF.text isEqualToString:@""]) {
        [[NoticeTool notice]showTips:@"输入不能为空" onController:self];
        return;

    }
    [XLProgressHUD showOnView:self.view message:@"登录中..." animated:YES];
    [NetRequest ProactiveLoginByPhoneNum:self.numberTextF.text identityCode:self.snsTextF.text block:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"登录成功后返回的值＝＝%@",responseDicionary);
        if ([[NSString stringWithFormat:@"%@",[responseDicionary objectForKey:@"resultStatus"]]isEqualToString:@"1000"]) {
            [[XLPlist sharePlist] saveToPlistByAppendPlisRouteStr:proactiveLogin ByJsonDic:[responseDicionary objectForKey:@"result"]];
            NSDictionary *result = responseDicionary[@"result"];
            [[NSUserDefaults standardUserDefaults]setObject:result[@"userType"] forKey:USERTYPE];
            [self loginRongCloudWithToken:result[@"ryToken"]];
            if (_isPush) {
                WYWebController *web = [[WYWebController alloc]init];
                web.urlstr = _pushUrl;
                web.isPush = _isPush;
                [self presentViewController:web animated:YES completion:nil];
            } else {
                UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
                BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
                tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
                win.rootViewController= tabbar;
                [self presentViewController:win.rootViewController animated:YES completion:nil];
            }
            if (![[NSUserDefaults standardUserDefaults] boolForKey:isRegisterAPNS]) {
                [self registAPNs];
            }
            [MobClick event:@"um_login_page_success_event"];
        }else{
            [[NoticeTool notice]showTips:responseDicionary[@"tips"] onController:self];
            [MobClick event:@"um_login_page_failure_event"];
        }
        [XLProgressHUD hideOnView:self.view];
    }];
    
}
-(void)view:(UIView *)setView setCornerRadioWithValue:(float)value hasBorderColor:(BOOL)hasLayer
{
    setView.layer.cornerRadius = value;
    setView.clipsToBounds = YES;
    if (hasLayer) {
        setView.layer.borderColor = RGB(204, 204, 204, 1).CGColor;
        setView.layer.borderWidth = 0.5;
    }
}
-(void)loginRongCloudWithToken:(NSString *)token
{
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
             NSLog(@"登录成功 ,登录用户为 %@",userId);
        [[XLPlist sharePlist]setObject:userId forKey:RC_UserID];
        
        
        
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
        }];
        
        
        
        
        
        
        
        
    } error:^(RCConnectErrorCode status) {
        [[XLPlist sharePlist]removeObjectForKey:RC_UserID];
    } tokenIncorrect:^{
        
    }];
}
-(void)backToLastView{
    if (_isExit) {
//        [self exitApplication];
        ViewController *vc = [[ViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)exitApplication {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)registAPNs
{
    [NetRequest registerAPNS:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"-----%@--",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isRegisterAPNS];
        }
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger length = textField.text.length + string.length - range.length;
    if(textField==self.numberTextF)
    {
        return length <= 11;
        
    }else
    {
        return length <= 6;
        
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
