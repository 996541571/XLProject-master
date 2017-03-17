//
//  PersonalInformationVC.m
//  XXProjectNew
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "PersonalInformationVC.h"
#import "OthersFollowController.h"
#import "PersonalView.h"
@interface PersonalInformationVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nickerName;
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property (weak, nonatomic) IBOutlet UIButton *followStatus;
@property(nonatomic,strong)NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UIButton *chat;
@property(nonatomic,strong)PersonalView *persionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@end

@implementation PersonalInformationVC
-(PersonalView *)persionView
{
    if (!_persionView) {
        _persionView = [[PersonalView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, 50+(screenWidth/(1082/642.0)))];
        [_persionView.follow addTarget:self action:@selector(followList) forControlEvents:UIControlEventTouchUpInside];
        [_persionView.fan addTarget:self action:@selector(fanList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _persionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if(![CoreStatus isNetworkEnable]){
//        [[NoticeTool notice]showTips:@"网络未连接" onView:self.view];
//    }
    [self.view addSubview:self.persionView];
    self.top.constant = 50+(screenWidth/(1082/642.0)) + 50 +64;
    [_followStatus setCornerRadiusWithRadius:17.5 borderWidth:0 borderColor:nil];
    [_chat setCornerRadiusWithRadius:17.5 borderWidth:1 borderColor:RGB(47, 150, 255, 1)];
    if (!_partyID) {
        _partyID = @0;
    }
    [NetRequest requetWithParams:@[@{@"partyId":_partyID}] requestName:@"UserService.getUserByPartyId" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            self.dataDic = responseDicionary[@"result"];
            [self setUI];
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }else{
            [[NoticeTool notice] showTips:@"网络异常" onController:self];
            
        }
    }];
    
}
-(void)followList
{
    [self jumpToFollowAndFanVCWithType:0];
}
-(void)fanList
{
    [self jumpToFollowAndFanVCWithType:1];
}
-(void)jumpToFollowAndFanVCWithType:(int)type
{
    OthersFollowController * other = [[OthersFollowController alloc]init];
    other.type = type;
    other.partyID = self.dataDic[@"partyId"];
    [self.navigationController pushViewController:other animated:YES
     ];
}
- (IBAction)followAndFan:(UIButton *)sender {
    
    OthersFollowController * other = [[OthersFollowController alloc]init];
    if ([sender.titleLabel.text isEqualToString:@"关注"]) {
        other.type = 0;
    } else {
        other.type = 1;
    }
    other.partyID = self.dataDic[@"partyId"];
    [self.navigationController pushViewController:other animated:YES
     ];
}

-(void)setUI{
    
    if ([_dataDic[@"bothStatus"] isEqualToString:@"UNFOLLOW"]) {
        
        [_followStatus setTitle:@"加关注" forState:UIControlStateNormal];
    } else {
        [_followStatus setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    if (![_dataDic[@"partyId"] isEqual:ManagerPartyId]) {
        self.title = @"Ta的信息";
        _followStatus.hidden = NO;
        _chat.hidden = NO;
    }else{
        self.title = @"个人信息";
    }
    if (!_dataDic[@"introduce"] || [_dataDic[@"introduce"] isEqualToString:@""]) {
        self.persionView.introduction.text = @"暂无介绍";

    } else {
        self.persionView.introduction.text = _dataDic[@"introduce"];
    }
    self.persionView.nikerName.text = _dataDic[@"nikerName"];
    [self.persionView.icon sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"headImg"]] placeholderImage:[UIImage imageNamed:@"Mine_defaultIcon"]];
    self.persionView.followCount.text = [NSString stringWithFormat:@"%@",_dataDic[@"followsNumber"]];
    self.persionView.fanCount.text = [NSString stringWithFormat:@"%@",_dataDic[@"fansNumber"]];
    if ([_dataDic[@"sex"] isEqualToString:@"女"]) {
        _persionView.genderIV.image = [UIImage imageNamed:@"girl_icon"];
    }else if ([_dataDic[@"sex"] isEqualToString:@"男"]) {
        _persionView.genderIV.image = [UIImage imageNamed:@"boy_icon"];
    }
    
}
- (IBAction)follow:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"加关注"]) {
        [MobClick event:@"um_my_Information_Jattention_click_event"];
        [self followOperateWithType:@"FOLLOW"];
    } else {
        [MobClick event:@"um_information_attention_click_event"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定不再关注此人?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)followOperateWithType:(NSString *)type
{
    NSArray *params = @[@{@"toPartyId":_dataDic[@"partyId"],@"fromPartyId":ManagerPartyId,@"bothStatus":type}];
    [NetRequest requetWithParams:params requestName:@"UserRelationService.follow" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            if ([responseDicionary[@"result"] isEqualToString:@"UNFOLLOW"]) {
                [_followStatus setTitle:@"加关注" forState:UIControlStateNormal];
            }else if ([responseDicionary[@"result"] isEqualToString:@"FOLLOW"] || [responseDicionary[@"result"] isEqualToString:@"BOTH"]){
                [_followStatus setTitle:@"取消关注" forState:UIControlStateNormal];
            }
        }
    }];
}
- (IBAction)chat:(id)sender {
    [MobClick event:@"um_information_Chat_click_event"];
    DVConversationVC *conversationVC = [[DVConversationVC alloc]init];
    
    conversationVC.unReadMessage = 10;
    
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = [NSString stringWithFormat:@"%@",self.dataDic[@"partyId"]];
    conversationVC.title = self.dataDic[@"nikerName"];
    [self.navigationController pushViewController:conversationVC animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self followOperateWithType:@"UNFOLLOW"];
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
