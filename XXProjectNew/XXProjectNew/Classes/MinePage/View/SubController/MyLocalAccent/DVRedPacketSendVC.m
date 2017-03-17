//
//  DVRedPacketSendVC.m
//  XXProjectNew
//
//  Created by apple on 1/10/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DVRedPacketSendVC.h"

#import "SimpleMessage.h"

#import "MMPinView.h"

@interface DVRedPacketSendVC ()<UITextFieldDelegate>
@property(nonatomic,weak)MMPinView* pinView;
@property (weak, nonatomic) IBOutlet UILabel *presentAmount_label;

@property(nonatomic,copy)NSString* restAmount;


@end

@implementation DVRedPacketSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    [self setupUI];
    
    
    [self.money_field addTarget:self action:@selector(moneyfieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.des_field addTarget:self action:@selector(greeting:) forControlEvents:UIControlEventEditingChanged];
    
    
    [self.send_btn addTarget:self action:@selector(sendBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.send_btn.enabled = NO;
    
    self.send_btn.backgroundColor = RGB(253, 164, 170, 1);

    
    
}

-(void)greeting:(UITextField*)field{
    
    
    int i = 25;
    
    //    self.marked_label.text = [NSString stringWithFormat:@"%td\10",textField.text.length];
    
    if (field.text.length > i) {
        UITextRange *markedRange = [field markedTextRange];
        
        //        field.text =[NSString stringWithFormat:@"¥%.2lf",[field.text doubleValue]];
        
        
        if (markedRange) {
            return ;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [field.text rangeOfComposedCharacterSequenceAtIndex:i];
        field.text = [field.text substringToIndex:range.location];
    }

    
}


-(void)moneyfieldDidChanged:(UITextField*)field{
    
    int i = 7;

    
    if([field.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
    {
        

                
        
        NSRange range = [field.text rangeOfString:@"."];
        
        i = (int)range.location + 3;
        
    }
    
    
    
    
    //    self.marked_label.text = [NSString stringWithFormat:@"%td\10",textField.text.length];
    
    if (field.text.length > i) {
        UITextRange *markedRange = [field markedTextRange];
        
//        field.text =[NSString stringWithFormat:@"¥%.2lf",[field.text doubleValue]];

        
        if (markedRange) {
            return ;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [field.text rangeOfComposedCharacterSequenceAtIndex:i];
        field.text = [field.text substringToIndex:range.location];
    }

    
    
    
    self.presentAmount_label.text = [NSString stringWithFormat:@"¥%.2lf",[field.text doubleValue]];
    
    
    
    
    
    //激活按钮
    
    if ([field.text doubleValue] > 0.0) {
        
        self.send_btn.enabled = YES;
        
        self.send_btn.backgroundColor = RGB(227, 72, 81, 1);

        
    }else{
        
        self.send_btn.enabled = NO;

        self.send_btn.backgroundColor = RGB(253, 164, 170, 1);

    }
    
    
    
}




-(void)setupUI{
    
    
    //修改中间标题
    
    UILabel* lable =[UILabel labelWithText:@"发红包" andColor:RGB(253, 231, 199, 1) andFontSize:18 andSuperview:nil];
    
    [lable sizeToFit];
    
    self.navigationItem.titleView = lable;

    
    //增加标线
    
    self.moneyView.layer.borderWidth = 0.5;
    
    self.moneyView.layer.borderColor = RGB(237, 225, 190, 1).CGColor;
    
    self.des_field.layer.borderWidth = 0.5;
    
    self.des_field.layer.borderColor = RGB(237, 225, 190, 1).CGColor;

    
    
    
    
    
    //修改 placeholder 属性
    
    self.money_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入金额" attributes:@{NSForegroundColorAttributeName: RGB(242, 221, 189, 1)}];
    
    self.des_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"恭喜发财,大吉大利!" attributes:@{NSForegroundColorAttributeName: RGB(242, 221, 189, 1)}];


    
    self.moneyView.layer.cornerRadius = 5;
    
    [self.moneyView clipsToBounds];
    
    self.des_field.layer.cornerRadius = 5;
    
    [self.des_field clipsToBounds];
    
    self.des_field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    //左边间距 要设置显示
    self.des_field.leftViewMode = UITextFieldViewModeAlways;


    
    //btn
    
    self.send_btn.layer.cornerRadius = 5;
    
    [self.moneyView clipsToBounds];


    
    
    [self setBackBtn];
    
}

-(void)setBackBtn{
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"rp_back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];
    
    
    
    
}

-(void)backToLastView{
    
    [self.navigationController popViewControllerAnimated:true];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = RGB(222, 37, 42, 1);
#pragma mark ..navibar背景
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"rp_navi_bg"] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

//   self.navigationController.navigationBar.tintColor = [UIColor yellowColor];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
//    self.navigationController.navigationBar.tintColor =  [UIColor yellowColor];

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
//     [navigationBar setShadowImage:[UIImage new]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.des_field resignFirstResponder];
    
    [self.money_field resignFirstResponder];
    
    NSLog(@"9000000");
}

-(void)sendBtnDidClick:(UIButton*)btn{
    
    
//    SimpleMessage *message = [[SimpleMessage alloc] init];
//    
//    message.content = [NSString stringWithFormat:@"[乡邻红包]%@",self.des_field.text];
//
//    message.briberyName = @"乡邻红包";
//    
//    message.briberyDesc = self.des_field.text;
    
    
//    [self.delegate sendRedPacket:message];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    

    
    
    
    
    
    
    //键盘回退
    
    
    if (self.money_field.isFirstResponder) {
        
        [self.money_field resignFirstResponder];
        
        
    }else if(self.des_field.isFirstResponder){
        
        [self.des_field resignFirstResponder];
        
        
    }
        
        
        
    //检查网络
    
    if (![CoreStatus isNetworkEnable]){
        [[NoticeTool notice]showTips:@"网络异常，请检查网络连接" onView:self.view];
        return;
    }

    
    
    if([self.money_field.text rangeOfString:@"."].location !=NSNotFound)
    {
        
        NSRange range = [self.money_field.text rangeOfString:@"."];
        
        
        NSString* subStr = [self.money_field.text substringFromIndex:range.location+1];
        
        
        if ([subStr rangeOfString:@"."].location != NSNotFound) {
            
            [[NoticeTool notice]  showTips:@"输入错误!" onView:self.view];

            
            return;
        }
        
        
        
    }
    
    
    //金额是否超过200
    
    
    if ([self.money_field.text doubleValue] > 200.00) {
        
        [[NoticeTool notice]  showTips:@"红包金额不能超过200元" onView:self.view];
        
        
        return;
        
    }
    
    
    
    //是否设置了交易密码
    
    
    [self whetherSetPassword];

    
    //账户余额是否足够
    
    //----在楼上判断了
    
    
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    WYWebController*first=[WYWebController new];
    first.hidesBottomBarWhenPushed=YES;
    NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];

    if (alertView.tag == 0) {
        if(buttonIndex == 1){
            
            
            //设置交易密码--h5
            
            
            
            //交易密码
            NSString *Btype = @"3";
            
            //        if (_isSet) {
            //            Btype = @"5";
            //        } else {
            //            Btype = @"3";
            //        }
            
            first.urlstr =[NSString stringWithFormat:@"%@/home/network/nodeManager/setTradePwd.html?mobilePhone=%@&Btype=%@&partyId=%@&markFlag=true",ENV_H5CAU_URL,loginInfodic[@"mobilePhone"],Btype,loginInfodic[@"nodeManagerPartyId"]];
            [self.navigationController pushViewController:first animated:YES];
            
            
            
            //关闭网页的回调
            
//            first.close_blcok = ^(){
//
//                [self whetherSetPassword];
//                
//            };
            
            
            
        }
        
        
    }else if (alertView.tag == 1){
        if(buttonIndex == 1){

        //余额不足
//https://h5cau-dev.xianglin.cn/home/network/nodeManager/balanceRecharge.html
            
//        first.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
            
//            [NSString stringWithFormat:@"https://h5cau-dev.xianglin.cn/home/network/nodeManager/balanceRecharge.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
            
            first.urlstr = [NSString stringWithFormat:@"%@/home/network/nodeManager/balanceRecharge.html",ENV_H5CAU_URL];
            
            

//            
            
        NSLog(@"---account---%@",first.urlstr);
        
        [self.navigationController pushViewController:first animated:YES];
        
        
        //关闭网页的回调
        
        first.close_blcok = ^(){
            
//            [self whetherMoneyEnough];
            
        };
        
    }
    }else if (alertView.tag == 2){
        
        // 输入密码的结果
        
        
        self.pinView.userInteractionEnabled = YES;
        
        [self.pinView hide];
        
        
        
    }else if (alertView.tag ==3){
        //密码错误
        if (buttonIndex == 0) {
            
            //忘记密码
            
            
            NSString *Btype = @"3";
            
            first.urlstr =[NSString stringWithFormat:@"%@/home/network/nodeManager/setTradePwd.html?mobilePhone=%@&Btype=%@&partyId=%@&markFlag=true",ENV_H5CAU_URL,loginInfodic[@"mobilePhone"],Btype,loginInfodic[@"nodeManagerPartyId"]];
            [self.navigationController pushViewController:first animated:YES];

            
            self.pinView.userInteractionEnabled = YES;
            
            [self.pinView hide];
            
        }else if (buttonIndex == 1){
            
            //重试
            
            self.pinView.userInteractionEnabled = YES;

            
            [self.pinView clear];
            
        }
        
        
    }else if (alertView.tag == 4){
        //密码超限

        if (buttonIndex == 0) {
            
            //忘记密码
            
            NSString *Btype = @"3";

            first.urlstr =[NSString stringWithFormat:@"%@/home/network/nodeManager/setTradePwd.html?mobilePhone=%@&Btype=%@&partyId=%@&markFlag=true",ENV_H5CAU_URL,loginInfodic[@"mobilePhone"],Btype,loginInfodic[@"nodeManagerPartyId"]];
            [self.navigationController pushViewController:first animated:YES];

            
            self.pinView.userInteractionEnabled = YES;
            
            [self.pinView hide];
            
        }else if (buttonIndex == 1){
            
            //确定
            
            self.pinView.userInteractionEnabled = YES;

            [self.pinView hide];

        }

        
    }
    
    

}



-(void)whetherSetPassword{
    
    
    __block BOOL pw_whetherSet;
    
    NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber *partyID = loginInfodic[@"nodeManagerPartyId"];
    
    if (!partyID) {
        partyID = @0;
    }
    
    [NetRequest requetWithParams:@[partyID] requestName:@"app.PersonInfoService.isSetTradePassword" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            
            pw_whetherSet = [[NSString stringWithFormat:@"%@",responseDicionary[@"result"]] integerValue];
            
            
            //如果没有设置交易密码
            
            if (!pw_whetherSet) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                alertView.tag = 0;
                
                [alertView show];
                
                
                
                
            }else{
                
                
                //查询余额
                
                //RedPacketService
                
                [self whetherMoneyEnough];
                
                
                
            }
            
            
            
            
            
        }
    }];

    
}
-(void)whetherMoneyEnough{
    
    [NetRequest requetWithParams:@[] requestName:@"RedPacketService.queryAcctBalance" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        NSLog(@"%@",responseDicionary);
        
        
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            
            
            NSString* result = [responseDicionary valueForKey:@"result"];
            
            self.restAmount = result;
            
            
            if ([result doubleValue] < [self.money_field.text doubleValue]) {
                
                //余额不足
                
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"账户余额不足,建议您去充值!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                alertView.tag = 1;
                
                [alertView show];
                
                
            }else{
                
                //余额充足
                
                /*
                NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
                
                WYWebController *web = [[WYWebController alloc]init];
                web.urlstr = [NSString stringWithFormat:@"%@?toNodePartyId=%@&toNodeManagerId=%@&money=%@",@"",loginInfodic[@"nodePartyId"],loginInfodic[@"nodeManagerPartyId"],self.money_field.text];
                
                
                web.block = ^(NSString *result){
                    if ([result isEqualToString:@"true"]) {
                        //                [[NoticeTool notice]showTips:@"打赏成功" onController:self];
                        [[NoticeTool notice] showTips:@"发红包成功" onView:self.view];
//                        RankModel *model;
//                        if (_rankArr.count) {
//                            model = _rankArr[_rewardTag];;
//                        }
//                        BankBusinessCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_rewardTag inSection:2]];
//                        [cell.rewordIcon setImage:[UIImage imageNamed:@"bank_rewordColor"] forState:UIControlStateNormal];
//                        [cell.rewardCount setTitle:[NSString stringWithFormat:@"%ld人打赏",model.rewards +1] forState:UIControlStateNormal];
//                        [cell.rewardCount setTitleColor:blueColor forState:UIControlStateNormal];
//                        model.rewardsMark = -1;
//                        model.rewards += 1;
//                        [_rankArr replaceObjectAtIndex:_rewardTag withObject:model];
                        
                        
                    } else {
                           [[NoticeTool notice] showTips:@"发红包是吧" onView:self.view];
                        //                [[NoticeTool notice]showTips:@"打赏失败，请稍后再试" onController:self];
                    }
                };
                
                [self.navigationController pushViewController:web animated:YES];

                
                */
                
                
                
                MMPinView *pinView = [MMPinView new];
                
                pinView.restAmount = self.restAmount;
                
                pinView.vc = self;
                
                pinView.moneyText = [NSString stringWithFormat:@"%@元",self.money_field.text];
                
                
                [pinView show];
                
                
                pinView.hadInputPWBlock = ^(NSString* pw,MMPinView* view){
                    
                    
                    //判断密码正确与否
                    
                    view.userInteractionEnabled = NO;
                    
                    
                     
                     NSDictionary* dic = @{@"sendPartyId":[[NSUserDefaults standardUserDefaults] valueForKey:RC_UserID],
                                           @"partyId":self.targetId,
                                           @"amount":self.money_field.text,
                                           @"description":(self.des_field.text.length == 0 ? @"恭喜发财,大吉大利":self.des_field.text)
                                           };
                     
                     [NetRequest requetWithParams:@[dic,pw] requestName:@"RedPacketService.sendRedPacket" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
                     
                     NSLog(@"%@",responseDicionary);
                     
                         if ([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 1000) {
                             
                             view.userInteractionEnabled = YES;
                             
                             [view hide];
                             
                             [[NoticeTool notice] showTips:@"发送成功" onView:self.view];
                             
                             //发送消息
                             
                             
                             
                             SimpleMessage *message = [[SimpleMessage alloc] init];
                             
                             
                             //红包ID
                             
                             message.bribery_ID = [responseDicionary valueForKey:@"result"];
                             
                             
                             message.content = [NSString stringWithFormat:@"[乡邻红包]%@",self.des_field.text];
                             
                             message.briberyName = @"乡邻红包";
                             
                             message.briberyAmount = self.money_field.text;
                             
                             message.briberyDesc = self.des_field.text.length == 0 ? @"恭喜发财,大吉大利":self.des_field.text;
                             
                             [self.delegate sendRedPacket:message];
                             
                             
                             
                             
                             
                             
                             
                             //返回上一层
                             dispatch_after(
                                            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                                            dispatch_get_main_queue(),
                                            ^{
                                                
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }
                                            );
                             
                             
                         }else if([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 200013){
                             
                             //密码错误
                             
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message: [responseDicionary valueForKey:@"tips"]delegate:self cancelButtonTitle:@"忘记密码" otherButtonTitles:@"重试", nil];
                             
                             
                             alertView.tag = 3;
                             
                             self.pinView = view;
                             
                             [alertView show];

                             
                         }else if([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 500000) {
                             
                             //密码超限
                             
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message: [responseDicionary valueForKey:@"tips"]delegate:self cancelButtonTitle:@"忘记密码" otherButtonTitles:@"确定", nil];
                             
                             
                             alertView.tag = 4;
                             
                             self.pinView = view;
                             
                             [alertView show];

                             
                             
                         }else{
                             
                     
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message: [responseDicionary valueForKey:@"tips"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         
                         
                         alertView.tag = 2;
                         
                         self.pinView = view;
                         
                         [alertView show];
                             
                             
                         
                         }
                   
                     }];
                     
                    

                    
                };
                
                
                
            }
            
            
            
        }
    }];
    

    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

@end
