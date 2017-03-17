//
//  StartUpLoginVC.m
//  XXProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "PhoneNumLoginVC.h"
#import "AuthcodeView.h"
#import "ForgetSecretVC.h"




@interface PhoneNumLoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *stationFld;

@property (weak, nonatomic) IBOutlet UITextField *identityField;
@property(nonatomic,strong)dispatch_source_t timer;
@property(nonatomic,strong)UILabel *myAlertLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation PhoneNumLoginVC

- (IBAction)getIdenfityCodePress:(UIButton *)sender {
    
    if (![CoreStatus isNetworkEnable]) {
        
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];
        return ;
        
    }
    if ([self.stationFld.text length]!=11) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];
        return ;
    }
    NSLog(@"-----self.stationFld.text===%@",self.stationFld.text);
    [self.view endEditing:YES];
    [NetRequest getIdentityCodeByPhoneNum:self.stationFld.text block:^(NSDictionary *responseDicionary, NSError *error){
        NSLog(@"验证码====%@",responseDicionary);
        if (![[NSString stringWithFormat:@"%@",responseDicionary[@"resultStatus"]] isEqualToString:@"1000"]) {
            [self notice:responseDicionary[@"tips"]];
            dispatch_source_cancel(self.timer);
            UIButton *button = (UIButton *)[self.view viewWithTag:320];
            button.userInteractionEnabled = YES;
            button.alpha = 1;
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    }];
    [self startTimer];
}

- (IBAction)loginPress:(id)sender {
    if (![CoreStatus isNetworkEnable]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];

        
        return;
        
    }
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"whetherActivate"]) {
        
        [NetRequest ActivateDevide:^(NSDictionary *responseDicionary, NSError *error) {
            
            if(responseDicionary!=nil&&[[responseDicionary objectForKey:@"resultStatus"]intValue]==1000)
            {
                NSLog(@"-----激活设备返回数据==%@",responseDicionary);
                [[NSUserDefaults standardUserDefaults] setObject:[responseDicionary objectForKey:@"result"] forKey:@"did"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"whetherActivate"];
                if ([self.stationFld.text isEqualToString:@""]||[self.identityField.text isEqualToString:@""]) {
                    UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alview show];
                    return;
                    
                    
                }
                [self loginRequest];
            }
            
            
        }];
        
    }else{
        [self loginRequest];
    }

}

-(void)loginRequest
{
    if ([self.stationFld.text isEqualToString:@""]||[self.identityField.text isEqualToString:@""]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];
        return;
        
        
    }
    [NetRequest ProactiveLoginByPhoneNum:self.stationFld.text identityCode:self.identityField.text block:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"login----%@",responseDicionary);
        if ([[NSString stringWithFormat:@"%@",[responseDicionary objectForKey:@"resultStatus"]]isEqualToString:@"1000"]) {
            [[XLPlist sharePlist] saveToPlistByAppendPlisRouteStr:proactiveLogin ByJsonDic:[responseDicionary objectForKey:@"result"]];
            if (_isPush) {
                WYWebController *web = [[WYWebController alloc]init];
                web.urlstr = _pushUrl;
                web.isPush = _isPush;
                [self presentViewController:web animated:YES completion:nil];
            } else {
                UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
                BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
                tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
                win.rootViewController=tabbar;
                [self presentViewController:win.rootViewController animated:YES completion:nil];
            }
            if (![[NSUserDefaults standardUserDefaults] boolForKey:isRegisterAPNS]) {
                [self registAPNs];
            }
            
            [MobClick event:@"um_login_page_success_event"];
            //                [self.navigationController pushViewController:win.rootViewController animated:YES];
            //                    [self dismissViewControllerAnimated:NO completion:^{
            //                        UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
            //                        win.rootViewController=[[BaseTabBarController alloc]init];
            //                    }];
            //                }
            
            //                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLogin];
            
        }else{
            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:[NSString stringWithFormat:@"%@",[responseDicionary objectForKey:@"tips"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alview show];
            [MobClick event:@"um_login_page_failure_event"];
        }
        
        
    }];
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
//倒计时
- (void)startTimer {
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *button = (UIButton *)[self.view viewWithTag:320];
                button.userInteractionEnabled = YES;
                button.alpha = 1;
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
//                self.reGetCodeLabel.text = @"59s后重新获取";
            });
        } else {
//            int second = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *button = (UIButton *)[self.view viewWithTag:320];
                button.userInteractionEnabled = NO;
                button.alpha = 0.5;
                [button setTitle:[NSString stringWithFormat:@"%d秒",timeout] forState:UIControlStateNormal];
//                self.reGetCodeLabel.text = [NSString stringWithFormat:@"%ds后重新获取", second];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
-(void)pushMsg:(NSNotification *)noti
{
    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
    web.urlstr = noti.userInfo[@"url"];
    web.isPush = YES;
    [self  presentViewController:web animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMsg:) name:@"pushMsg" object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    //注册键盘隐藏通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    self.stationFld.delegate=self;
    self.identityField.delegate=self;
    self.stationFld.keyboardType = UIKeyboardTypeNumberPad;

    self.identityField.keyboardType = UIKeyboardTypeNumberPad;



   
   
    
    

    // Do any additional setup after loading the view from its nib.
}


-(void)setupUI{
    
    self.loginBtn.backgroundColor=RGB(114, 211, 255, 1);
    self.loginBtn.layer.cornerRadius= 17 ;
    
    [self.stationFld customPlaceholderColor:RGB(195, 215, 241, 1)];
    [self.identityField customPlaceholderColor:RGB(195, 215, 241, 1)];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger length = textField.text.length + string.length - range.length;
    if(textField==self.stationFld)
    {
        return length <= 11;

    }else
    {
        return length <= 6;

    }
}
//键盘弹出后将视图向上移动
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.identityField.frame;

    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(y > 0)
    {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//键盘隐藏后将视图恢复到原始状态
-(void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)notice:(NSString *)noti
{
    self.myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake((screenWidth-200)/2, screenHeight-49-60, 200, 30)];  //起始高度设的大点
    self.myAlertLabel.text=noti;
    self.myAlertLabel.layer.cornerRadius=6;
    self.myAlertLabel.layer.masksToBounds = YES;
    
    
    self.myAlertLabel.font=[UIFont systemFontOfSize:14];
    self.myAlertLabel.textAlignment=NSTextAlignmentCenter;
    self.myAlertLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.myAlertLabel];
    self.myAlertLabel.textColor=[UIColor whiteColor];
    self.myAlertLabel.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:1  //动画时间
                          delay:3  //开始延迟时间
                        options: UIViewAnimationCurveEaseOut  //弹入弹出
                     animations:^{
                         //                             self.myAlertLabel.frame = CGRectMake(100, self.view.frame.size.height, 200, 15);  //终止高度设的小于起始高度
                         self.myAlertLabel.alpha=0;
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.myAlertLabel removeFromSuperview];  //移动后隐藏
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
