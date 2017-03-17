//
//  StartUpLoginVC.m
//  XXProject
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "StartUpLoginVC.h"
#import "AuthcodeView.h"
#import "ForgetSecretVC.h"




@interface StartUpLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *stationFld;
@property (weak, nonatomic) IBOutlet UITextField *secretFid;
@property (weak, nonatomic) IBOutlet AuthcodeView *authCodeView;

@property (weak, nonatomic) IBOutlet UITextField *identityField;

@property (weak, nonatomic) IBOutlet UIButton *stationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *stationOrVillagersImgView;
@property (weak, nonatomic) IBOutlet UIButton *villagerBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetSecretBtn;
@end

@implementation StartUpLoginVC

- (IBAction)stationClick:(UIButton *)sender {

    NSLog(@"我是站长");
    self.stationOrVillagersImgView.image=[UIImage imageNamed:@"left"];
//    self.infoView.hidden=NO;
    [self .stationBtn setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
    [self .villagerBtn setTitleColor:RGB(47, 172, 255, 1) forState:UIControlStateNormal];


    
    

    
}


-(void)setupUI{
    
    //    [self.view addSubview:self.loginBtn];
    self.secretFid.secureTextEntry=YES;
    self.forgetSecretBtn.hidden=YES;
    
    self.infoView.layer.cornerRadius=5;
    //    self.infoView.backgroundColor=RGB(255, 255, 255, 0.2);
    self.infoView.backgroundColor=[UIColor clearColor];
    self.loginBtn.backgroundColor=RGB(114, 211, 255, 1);
    self.loginBtn.layer.cornerRadius=17;
    
    
    [self.stationFld customPlaceholderColor:RGB(195, 215, 241, 1)];
    [self.secretFid customPlaceholderColor:RGB(195, 215, 241, 1)];


    
    
}

- (IBAction)villagerClick:(id)sender {
    NSLog(@"我是村民");
//    self.infoView.hidden=YES;

    [self .villagerBtn setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
    [self .stationBtn setTitleColor:RGB(47, 172, 255, 1) forState:UIControlStateNormal];
    self.stationOrVillagersImgView.image=[UIImage imageNamed:@"right"];
    

}
- (IBAction)loginPress:(id)sender {
    
    if (![CoreStatus isNetworkEnable]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];
        
        
        return;
        
    }

    if ([self.stationFld.text isEqualToString:@""]||[self.identityField.text isEqualToString:@""]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];
        return;
        
        
    }
    NSLog(@"----%@---%@",self.stationFld.text,self.secretFid.text);
         [NetRequest ProactiveLoginByNode:self.stationFld.text passwordStr:self.secretFid.text block:^(NSDictionary *responseDicionary, NSError *error) {
      
      if ([[NSString stringWithFormat:@"%@",[responseDicionary objectForKey:@"resultStatus"]]isEqualToString:@"1000"]) {
          
          [[XLPlist sharePlist] saveToPlistByAppendPlisRouteStr:proactiveLogin ByJsonDic:[responseDicionary objectForKey:@"result"]];
          
          [self dismissViewControllerAnimated:NO completion:^{
              UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
              BaseTabBarController *tabbar = [[BaseTabBarController alloc]init];
              tabbar.isNew = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
              win.rootViewController=tabbar;
              
              
              
          }];
          
      }else
      {
          UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:[NSString stringWithFormat:@"%@",[responseDicionary objectForKey:@"tips"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
          [alview show];

      }
      
  }];
    //正确弹出警告款提示正确
//    UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"恭喜您 ^o^" message:@"验证成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alview show];

}

- (IBAction)forgetSecretPress:(UIButton *)sender {
    NSLog(@"首次登录/忘记密码");
    ForgetSecretVC*forget=[[ForgetSecretVC alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   
   
    
    

    // Do any additional setup after loading the view from its nib.
}
//键盘弹出后将视图向上移动
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.infoView.frame;
//    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    float y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height) - 100;
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
