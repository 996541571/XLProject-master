//
//  ModifyPhoneNumVC.m
//  XXProjectNew
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "ModifyPhoneNumVC.h"

@interface ModifyPhoneNumVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextF;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;
@property (weak, nonatomic) IBOutlet UITextField *snsTextF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,strong)NSString *snsCode;
@property(nonatomic,assign)BOOL isSns;
@end

@implementation ModifyPhoneNumVC
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
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];
    [self initUI];
}
- (IBAction)next:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"下一步"]) {
        if ([self.snsTextF.text isEqualToString:@""]||self.snsTextF.text.length != 6) {
            [[NoticeTool notice]showTips:@"请输入正确的验证码" onView:self.view];
            return;
        }
        _phoneNum = self.numberTextF.text;
        _snsCode = self.snsTextF.text;
        self.noticeLab.text = @"请输入新手机号并验证";
        self.numberTextF.text = @"";
        self.snsTextF.text = @"";
        self.numberTextF.userInteractionEnabled = YES;
        if (_isSns) {
            _isSns = NO;
            [[XLPlist sharePlist]cancelTimerOfButton:self.codeBtn];
        }
        [sender setTitle:@"马上绑定" forState:UIControlStateNormal];
    } else {
        NSDictionary *dict = @{@"mobilePhone":_phoneNum,@"smsCode":_snsCode,@"newMobilePhone":self.numberTextF.text,@"newSmsCode":self.snsTextF.text};
        NSArray *parms = [NSArray arrayWithObject:dict];
        [NetRequest requetWithParams:parms requestName:@"UserService.bindNewPhone" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
            NSLog(@"%@",responseDicionary);
            if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
                LoginController *login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
                login.hidesBottomBarWhenPushed = YES;
                login.isExit = YES;
                [self.navigationController pushViewController:login animated:YES];
                NSDictionary *userInfo = [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
                dict[@"mobilePhone"] = self.numberTextF.text;
                userInfo = [NSDictionary dictionaryWithDictionary:dict];
                [[XLPlist sharePlist]saveToPlistByAppendPlisRouteStr:proactiveLogin ByJsonDic:dict];
                
            }else{
                [[NoticeTool notice]showTips:responseDicionary[@"tips"] onController:self];
            }
        }];
        if (_isSns) {
            _isSns = NO;
            [[XLPlist sharePlist]cancelTimerOfButton:self.codeBtn];
        }
    }
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
    NSArray *params = @[@{@"mobilePhone":self.numberTextF.text}];
    [NetRequest requetWithParams:params requestName:@"AppLoginService.smsCodeSend" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            _isSns = YES;
            [[XLPlist sharePlist]reGetIdentityCode:sender];
        }else{
            [[NoticeTool notice]showTips:responseDicionary[@"tips"] onController:self];
        }
    }];
    
}
-(void)initUI
{
    self.title = @"更换登录手机号";
    self.numberTextF.text = @"";
    self.numberTextF.userInteractionEnabled = NO;
    NSDictionary *userInfo = [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    self.numberTextF.text = userInfo[@"mobilePhone"];
    [self view:self.numberView setCornerRadioWithValue:5.f hasBorderColor:YES];
    [self view:self.codeView setCornerRadioWithValue:5.f hasBorderColor:YES];
    [self view:self.nextBtn setCornerRadioWithValue:17.f hasBorderColor:NO];
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

-(void)backToLastView{
    
    [self.navigationController popViewControllerAnimated:true];
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
