//
//  ForgetSecretVC.m
//  XXProject
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "ForgetSecretVC.h"

@interface ForgetSecretVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *identityBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *stationFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneFld;
@property (weak, nonatomic) IBOutlet UITextField *secretFld;
@property (weak, nonatomic) IBOutlet UITextField *confirmFld;
@property (weak, nonatomic) IBOutlet UITextField *identityFld;
@end

@implementation ForgetSecretVC
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView.backgroundColor=RGB(246, 246, 246, 1);
    self.infoView.backgroundColor=RGB(255, 255, 255, 0.2);
    self.loginBtn.backgroundColor=RGB(114, 211, 255, 1);
    self.loginBtn.layer.cornerRadius=20;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    




}
//键盘弹出后将视图向上移动
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.infoView.frame;
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


- (IBAction)backPress:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)handOverClick:(UIButton *)sender {
    if ([self.stationFld.text isEqualToString:@""]||[self.phoneFld.text isEqualToString:@""]||[self.secretFld.text isEqualToString:@""]||[self.confirmFld.text isEqualToString:@""]||[self.identityFld.text isEqualToString:@""]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];
        return;
        

    }
    
    if (![self.secretFld.text isEqualToString:self.confirmFld.text]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:@"两次密码输入不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alview show];
        return;

    }
    
    NSLog(@"验证码＝＝＝＝＝%@",self);
    [NetRequest firstLoginWithNode:self.stationFld.text phoneStr:self.phoneFld.text smgStr:self.identityFld.text passwordStr:self.secretFld.text block:^(NSDictionary *responseDicionary, NSError *error) {
                           if ([[NSString stringWithFormat:@"%@",[responseDicionary objectForKey:@"tips"]]isEqualToString:@"返回正常"]) {
                               NSLog(@"------------%@====",responseDicionary);
                               
//                                   [self dismissViewControllerAnimated:NO completion:^{
//                                       UIWindow*win=[[[UIApplication sharedApplication]delegate]window];
//                                       win.rootViewController=[[BaseTabBarController alloc]init];
//                               
//                                       
//                                       
//                                   }];
                               UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"恭喜您 ^o^" message:@"设置成功，返回登录界面登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                               [alview show];
                               alview.tag=10000;
                               
                           }
        
    }];
    

}
//获取验证码
- (IBAction)identityClick:(UIButton *)sender {
//    self.phoneFld.text=@"";
//    NSLog(@"网络情况==%@",[CoreStatus currentNetWorkStatusString]);
//
//    if (![CoreStatus isNetworkEnable]) {
//        
//        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alview show];
//        return ;
//        
//    }
//    if (self.stationFld.text.length<=7 ||self.stationFld.text.length>=14) {
//        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"请检查" message:@"站点编号输入不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alview show];
//        return ;
//    }
//
//
//    [NetRequest getPNumByNodeCode:self.stationFld.text block:^(NSDictionary *responseDicionary, NSError *error) {
//        NSLog(@"=====%@",responseDicionary );
//        NSInteger leng=self.stationFld.text.length;
//        
//      [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[responseDicionary objectForKey:@"result"]] forKey:@"PNum"];
//            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"欢迎您 ^o^" message:[NSString stringWithFormat:@"确定要将验证码发到%@上吗?",[responseDicionary objectForKey:@"result"]]
//    delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alview.tag=3000;
//            [alview show];
//        
//        
//        
//    }];
   


}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex==1&&alertView.tag==3000)
//    {
//        [XLPlist reGetIdentityCode:self.identityBtn];
//
//        self.phoneFld.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"PNum"];
//        [NetRequest getIdendityCodeNumWithNode:self.stationFld.text phoneNum:[[NSUserDefaults standardUserDefaults]objectForKey:@"PNum"] block:^(NSDictionary *responseDicionary, NSError *error) {
//            
//        }];
//        
//    }else if (alertView.tag==10000&&buttonIndex==1)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }
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
