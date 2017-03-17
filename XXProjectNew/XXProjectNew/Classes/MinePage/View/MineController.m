//
//  MineController.m
//  XXProjectNew
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define footer 0.016*screenHeight
#define firstCellHeight 0.245*screenHeight
#define secondOrForth 0.078*screenHeight
#define third 0.14*screenHeight
#define fifth 0.089*screenHeight
#import "MineController.h"
#import "StartUpLoginVC.h"
#import "AboutXLViewController.h"

#import "MineHeadView.h"

#import "StationAgentViewModel.h"

#import "MinePageModel.h"

#import "InviteActivityViewController.h"


#import "MyFollowController.h"



//appgw-test

#import "MyCell.h"
#import "StationAgentVC.h"
#import "MyNewCell.h"
@interface MineController ()<UITableViewDelegate,UITableViewDataSource,RCIMReceiveMessageDelegate,UIAlertViewDelegate>
{
    NSMutableArray* headeImageArr;
    NSMutableArray* headeLabNameArr;
    NSMutableArray*headeImageArr1;
    NSMutableArray* headeLabNameArr1;
    NSMutableArray*transferImageArr;

    NSMutableArray*transferNameArr;
    BOOL isFirst;
    UILabel*label;
    BOOL _isSet;//是否设置交易密码
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (strong, nonatomic) IBOutlet MyCell *QuitCell;
@property (strong, nonatomic) IBOutlet MyCell *AboutXLCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *FirstCell;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;
@property (weak, nonatomic) IBOutlet UILabel *headerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;


//未读消息

@property(nonatomic,weak)UILabel* redPointView;

@property(nonatomic,strong)MinePageViewModel* viewModel;
@property(nonatomic,weak)MineHeadView* headView;

@end

@implementation MineController

-(MinePageViewModel*)viewModel{
    
    
    if (!_viewModel) {
        
        
        MinePageViewModel* temp = [MinePageViewModel model];
        
        _viewModel = temp;
        
    }
    
    
    return _viewModel;
}




-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = true;
    
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;

    
    self.headView.user = self.viewModel.user;
//    if (self.viewModel.user != 0) {
    
        
        [self.viewModel prepareToPresentWithSuccess:^{
            
            [self.table reloadData];
            
        }];
        
        
        [[StationAgentViewModel model]obtainWebDataWithSuccess:^{
            
            [self.table reloadData];
            
//            self.headView.user = self.viewModel.user;
            
        } andFinished:nil];
        
        
//    }
    [self isSetPassword];
    
    
}


-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message{
    
    
    return YES;
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    
    
    
    
    if (left == 0) {
        
//        NSLog(@"%@",message.content.senderUserInfo.name);
        
        
        
        
        
        
    }
    
    
//
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
//        [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
        
//        [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

        [self.table reloadData];
        
        
//        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    });
    
    
}

-(void)newFans
{
    self.headView.dot.hidden = NO;
    self.headView.user = self.viewModel.user;
//    self.headView.btn_right_text.text = [NSString stringWithFormat:@"%ld",[self.headView.btn_right_text.text integerValue] + 1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //监听未读消息的代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [self setupHeadView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newFans) name:@"FANS" object:nil];
    self.table.tableFooterView = [[UIView alloc]init];
    isFirst=YES;
    [NetRequest whetherCountExist:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"whetherCountExist===%@",responseDicionary);
        isFirst=NO;
        if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000) {
            
            //连接正常的情况下
            
        }else{
            
           //连接错误
        }
        
        [headeImageArr removeAllObjects];
        [headeLabNameArr removeAllObjects];
        [headeImageArr addObject:@"station"];
        [headeImageArr addObject:@"receive"];
        [headeImageArr addObject:@"mine_transaction"];
        
        [headeImageArr addObject:@"mine_invite_icon"];
        [headeImageArr addObject:@"myAccent_icon"];

        
        [headeLabNameArr addObject:@"个人信息"];
        [headeLabNameArr addObject:@"收款账户"];
        //            [headeLabNameArr addObject:@"赚钱计算器"];
        [headeLabNameArr addObject:@"交易密码"];
        
        
        //新增
        
        [headeLabNameArr addObject:@"邀请好友"];
        //1.4新增
        [headeLabNameArr addObject:@"我的乡音"];

        
            [self.table reloadData];

    }];
    self.table.delegate=self;
    self.table.dataSource=self;
//    headeImageArr=[[NSMutableArray alloc]initWithObjects:@"station" ,@"calculateImage",nil];
//    headeLabNameArr=[[NSMutableArray alloc]initWithObjects:@"站长个人信息" ,@"赚钱计算器",nil];
    
    headeImageArr=[[NSMutableArray alloc]initWithObjects:@"station" ,nil];
    headeLabNameArr=[[NSMutableArray alloc]initWithObjects:@"个人信息" ,nil];

    
    headeImageArr1=[[NSMutableArray alloc]initWithObjects:@"search",@"connectManager", nil];
    headeLabNameArr1=[[NSMutableArray alloc]initWithObjects:@"调查问卷",@"联系客服经理", nil];
//    transferImageArr=[[NSMutableArray alloc]init];
//    transferNameArr=[[NSMutableArray alloc]init];

    self.table.backgroundColor=RGB(233,233,233,1.0f);

   
}
-(void)isSetPassword
{
    NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber *partyID = loginInfodic[@"nodeManagerPartyId"];
    if (!partyID) {
        partyID = @0;
    }
    [NetRequest requetWithParams:@[partyID] requestName:@"app.PersonInfoService.isSetTradePassword" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] ==1000) {
            _isSet = [[NSString stringWithFormat:@"%@",responseDicionary[@"result"]] intValue];
        }
            [self.table reloadData];
    }];
}



-(void)setupHeadView{
    
    MineHeadView* headView = [MineHeadView new];
    
    self.headView = headView;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FANS"] isEqualToString:@"FANS"]) {
        headView.dot.hidden = NO;
    } else {
        headView.dot.hidden = YES;
    }
    if (self.viewModel.user == 0) {
        //如果没有登录
        
        self.headView.frame = CGRectMake(0, 0, 0, (screenWidth/(1082/642.0)));
        
        self.headView.container.hidden = YES;
        
    }else{
        
        
        self.headView.frame = CGRectMake(0, 0, 0, double_btn_hight+(screenWidth/(1082/642.0)));
        
        
               self.headView.container.hidden = NO;
        
    }
    
    self.table.tableHeaderView = headView;

    if (self.viewModel.user != visitor) {
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePortait)];
        
      
          [self.headView.headimgV addGestureRecognizer:tap];
        
    }else{
        #pragma mark 跳转登录
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login)];
        
        
        [self.headView.headimgV addGestureRecognizer:tap];

        
        
    }
    
    
    
    [self.headView.alias addTarget:self action:@selector(headbtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    //btn_点击事件
    
        [self.headView.left_btn addTarget:self action:@selector(doubleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.headView.right_btn addTarget:self action:@selector(doubleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


#pragma mark 关注粉丝点击事件

-(void)doubleBtnDidClick:(UIButton*)btn{
    
    NSLog(@"%td",btn.tag);
    if (btn.tag == 1) {
        [MobClick event:@"um_my_funs_click_event"];
        self.headView.dot.hidden = YES;
        [[NSUserDefaults standardUserDefaults]setObject:@""forKey:@"FANS"];
    }else{
        [MobClick event:@"um_my_Attention_click_event"];
    }
    MyFollowController* VC= [MyFollowController new];
    
    VC.type = (int)btn.tag;
    
    VC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:VC animated:YES];

    
    
}


#pragma mark 跳转登录

-(void)login{
    
    
    LoginController* logVC =   [LoginController new];
    
    logVC.hidesBottomBarWhenPushed  = YES;
    
    [self.navigationController pushViewController:logVC animated:YES];

    
    
}



-(void)headbtnDidClick{
    
    
    if (self.viewModel.user != visitor) {
        
        [MobClick event:@"um_mine_page_manager_info_click_event"];
        
        StationAgentVC *agent = [[StationAgentVC alloc]initWithNibName:@"StationAgentVC" bundle:nil];
        agent.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:agent animated:YES];
        
        
    }else{
        
        
    #pragma mark 跳转登录

        
        [self login];
        
        
    }
    
    
    

    
}


#pragma mark 拿到更改后的头像

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    
    
    //NSString *const  UIImagePickerControllerEditedImage ;修改后的图片
    //    NSString *const  UIImagePickerControllerCropRect ;裁剪尺寸

    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    
    [[StationAgentViewModel model]  uploadForHeadIcon:image Success:^(NSString *imgUrl) {
        
         self.headView.headimgV.image = image;
        
        
        //更新融云用户信息
        

        
        [[RCIM sharedRCIM] clearUserInfoCache];
        
        
        
        
        //提示成功
        [[NoticeTool notice] showTips:@"保存成功!" onView:self.view];

        
    }];
    
    
    
    
}








#pragma mark -
#pragma mark tableview delegate

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        return fifth;
    }
//    else if (indexPath.section==0) {
//        return firstCellHeight;
//    }
    else
     {
         return secondOrForth;
     }
}

//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //未登录不显示最后一个退出登录分区
    
    if (self.viewModel.user == visitor) {
        
        return 3;
    }
    
    
    
    return 4;
}
//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        
        if (self.viewModel.user == 0) {
            
            return 3;
        }
        
        if (self.viewModel.model.presentCell_dic) {
            
            return [[self.viewModel.model.presentCell_dic valueForKey:@"count"] integerValue] ;
        
        }else{
            
            return 0;
        }
        
        
    
        
        

    }
    
    
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (section == 0) {
        
        return  10;
        
    }else{
        
        return 0;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return footer;
   
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame=CGRectMake(0, 0, screenWidth, footer);
    
    view.backgroundColor = RGB(233,233,233,1.0f);
    return view;
    
    
}


#pragma mark "响应事件"
//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView cellForRowAtIndexPath:indexPath].selected = NO ;
    
    
    
    //如果没有登录
    
    
    if (self.viewModel.user == visitor && indexPath.section !=2 && indexPath.row != 4) {
        
        //调到登录页面
        
        [self login];
        
        return ;
    }
    
    
    
    
    if (indexPath.section==0) {

        WYWebController*first=[WYWebController new];
        first.hidesBottomBarWhenPushed=YES;
        NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
        
        
            
            if (indexPath.row == 0) {
                
                //个人信息
                
                [MobClick event:@"um_mine_page_manager_info_click_event"];
                StationAgentVC *agent = [[StationAgentVC alloc]initWithNibName:@"StationAgentVC" bundle:nil];
                agent.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:agent animated:YES];
                
                
                
            }else if(indexPath.row==1)//收款账户
            {
                [MobClick event:@"um_mine_page_payment_account_click_event"];
                first.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
                NSLog(@"---account---%@",first.urlstr);
                
                [self.navigationController pushViewController:first animated:YES];

                
            }else if(indexPath.row==2)
                //计算器
            {
                
                
                
                
                [MobClick event:@"um_mine_page_transaction_pwd_click_event"];
                //交易密码
                NSString *Btype;
                if (_isSet) {
                    Btype = @"5";
                } else {
                    Btype = @"3";
                }
                
                [MobClick event:@"um_mine_page_earnings_calculate_entrance_click_event"];

                
                first.urlstr =[NSString stringWithFormat:@"%@/home/network/nodeManager/setTradePwd.html?mobilePhone=%@&Btype=%@&partyId=%@&markFlag=true",ENV_H5CAU_URL,loginInfodic[@"mobilePhone"],Btype,loginInfodic[@"nodeManagerPartyId"]];
                [self.navigationController pushViewController:first animated:YES];
            }else if (indexPath.row == 3){
                
                #pragma mark 邀请入口
                
                
                InviteActivityViewController* vc = [InviteActivityViewController new];
                
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
                

                
                
                
            }else if (indexPath.row == 4){
                
                
//
                
                
            }

        
        
        
        
        
        
        
        {
//            if (indexPath.row == 0) {
//                
//                [MobClick event:@"um_mine_page_manager_info_click_event"];
//                StationAgentVC *agent = [[StationAgentVC alloc]initWithNibName:@"StationAgentVC" bundle:nil];
//                agent.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:agent animated:YES];
//            }else
//            {
//                [MobClick event:@"um_mine_page_earnings_calculate_entrance_click_event"];
//                CalculateController*cal=[CalculateController new];
//                cal.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:cal animated:YES];
//                
//            }
        }
        

       
        
    }else if (indexPath.section == 2){
        AboutXLViewController* vc = [AboutXLViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:true];
        
        vc.MineViewController_transferImageArr = headeImageArr1;
        vc.MineViewController_transferNameArr = headeLabNameArr1;
        
        self.navigationController.navigationBarHidden = NO;
    }else if(indexPath.section == 1) {
        
        
        
        if (indexPath.section == 1) {
            
            
            
            
#pragma mark 我的乡音入口
            
            [MobClick event:@"um_my_myXY_click_event"];
            DVConversationListVC *chatList = [[DVConversationListVC alloc] init];
            
            chatList.hidesBottomBarWhenPushed = YES;
            
            chatList.title = @"我的乡音";
            
//            [MobClick event:@"um_my_myXY_click_event"];

            
            [self.navigationController pushViewController:chatList animated:YES];
            
            
        }

        
        
        
    }

}

#pragma mark "显示cell"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 3) {
        
        
        [_quitBtn addTarget:self action:@selector(quitPress) forControlEvents:UIControlEventTouchUpInside];
        _quitBtn.layer.borderWidth = 0.5 ;
        _quitBtn.layer.borderColor = RGB(148, 148, 148, 1).CGColor;
        
        _quitBtn.layer.cornerRadius = 3.3;
        //255,60,71
        [_quitBtn setTitleColor:RGB(255, 60, 71, 1) forState:UIControlStateNormal];
        self.QuitCell.backgroundColor = [UIColor clearColor];
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        return self.QuitCell;

        
        
    }
    
    if (indexPath.section== 2) {


            self.AboutXLCell.separate_line.hidden = false;
            
        
            
        

        
        return self.AboutXLCell;

        
        
    }else if (indexPath.section== 1){
        
        
//        return self.AboutXLCell;
        
        
         NSString *ID = @"MyNewCell";
        MyNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MyNewCell" owner:self options:nil].lastObject;
        }

        
       UILabel* redPointView =  [UILabel new];
        

        
        if (!self.redPointView) {
            
            self.redPointView = redPointView;
            
            [cell.contentView addSubview:self.redPointView];
            
            self.redPointView.layer.cornerRadius = 10.5;
            
            self.redPointView.clipsToBounds = YES;
            
            self.redPointView.layer.masksToBounds = YES;
            
            self.redPointView.backgroundColor = [UIColor redColor];
            
            
            self.redPointView.textColor = [UIColor whiteColor];
            
            self.redPointView.font = [UIFont systemFontOfSize:12];
            
            self.redPointView.textAlignment = NSTextAlignmentCenter;
            
            
            
            [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(cell);
                
                make.right.equalTo(cell).offset(-30);
                
                make.height.width.equalTo(@20);
                
            }];
            
        }
        
        
//-----------
        
        cell.separate_line.hidden = false;
        
        
        
        
        if (headeImageArr.count > 3) {
            cell.image.image = [UIImage imageNamed:headeImageArr[4]];
            
        }
        
        
        
        if (headeLabNameArr.count > 3) {
            cell.title.text = headeLabNameArr[4];
        }
        
        
        //
        cell.leading.constant = 15;
        cell.notice.hidden = YES;
        
        
        
                //

        
        
        //-------------
        
        
        if (self.viewModel.user == 0) {
            
            
            self.redPointView.hidden = YES;
            
            return cell;
            
        }else{
            
            
            self.redPointView.hidden= NO;
        }
        

       NSArray* array =  [[RCIMClient sharedRCIMClient] getConversationList:@[@1]];
        
        
        NSLog(@"----%@",array);
        
       __block int minus = 0;
        
        for (RCConversation* cv in array) {
            
            
            [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:1 targetId:cv.targetId success:^(RCConversationNotificationStatus nStatus) {
                
                if (nStatus == 0) {
                    //如果是屏蔽
                    
                    minus+=cv.unreadMessageCount;
                    
                }
                
            } error:^(RCErrorCode status) {
                
                NSLog(@"读取屏蔽消息开关失败");
            }];

            
            
        }
        
        int result =[[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        
        
        //减去屏蔽的消息数
        
        result-=minus;
        
        
        //屏蔽的对话不显示
        

        if (result > 99) {
            
            self.redPointView.hidden = NO;

            self.redPointView.text = @"99+";
            
            self.redPointView.font = [UIFont systemFontOfSize:8];

            
        }else if(result < 1){
            
            self.redPointView.hidden = YES;

        }else{
            
            self.redPointView.hidden = NO;

            self.redPointView.text = [NSString stringWithFormat:@"%d", result];
            self.redPointView.font = [UIFont systemFontOfSize:12];

            
            
            
        }
        
        
        
        return cell;

        
        
        
        
    }else if(indexPath.section == 0){
        
        //section == 0
        
        static NSString *ID = @"MyNewCell";
        MyNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MyNewCell" owner:self options:nil].lastObject;
        }
        
        

        //判断是否是该组的最后一个cell
        
        if ( headeImageArr.count && indexPath.row + 1 == [tableView numberOfRowsInSection:indexPath.section] ) {
            
            cell.separate_line.hidden = false;
            
        }else{
            
            cell.separate_line.hidden = YES;
            
        }
        
        
        NSLog(@"%@",indexPath);
        if (headeImageArr.count > 1) {
            cell.image.image = [UIImage imageNamed:headeImageArr[indexPath.row]];

        }
        if (headeLabNameArr.count > 1) {
            cell.title.text = headeLabNameArr[indexPath.row];
        }
        
        
        
        
        
        
            
            if (indexPath.row == 1) {
                
                
                if (self.viewModel.user == visitor ) {
                    
                    cell.notice.text = @"";
                    
                }else{
                    
                    if([StationAgentViewModel model].coinAppear){
                        
                        cell.notice.text = @"去提现";
                        
                    }else{
                        cell.notice.text = @"";

                        
                    }
                    
                    
                }
                cell.notice.hidden = NO;
                cell.leading.constant = 15;
            }else if (indexPath.row == 2){
                
                if (self.viewModel.user == 0) {
                    
                    cell.notice.hidden = YES;
                }else{
                    
                    cell.notice.hidden = NO;
                }
                
                
                if (_isSet) {
                    cell.notice.text = @"已设置";
                } else {
                    cell.notice.text = @"未设置";
                }
                cell.leading.constant = 0;

            }else{
                cell.leading.constant = 15;
                cell.notice.hidden = YES;
//                cell.dot.hidden = YES;
            }
        
        
//        } else {
//            
//            if (indexPath.row == 1) {
//                cell.leading.constant = 0;
//            }else{
//                cell.leading.constant = 15;
//            }
//            cell.notice.hidden = YES;
////            cell.dot.hidden = YES;
//        }
//        
        return cell;
        
    }

    
    
    
    
        return nil;
        
    
}



#pragma mark -
#pragma mark 获取头像





-(void)quitPress
{
    UIAlertView *alview = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alview show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [NetRequest quitLogin:^(NSDictionary *responseDicionary, NSError *error) {
            NSLog(@"quitDic=======%@",responseDicionary);
            if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000) {
                [[XLPlist sharePlist]deletePlistByPlistRoute:proactiveLogin ];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                LoginController *login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
                login.hidesBottomBarWhenPushed = YES;
                login.isExit = YES;
                [self.navigationController pushViewController:login animated:YES];

                [MobClick event:@"um_logout_page_sure_event"];
            }
        }];
        
        
        //断开融云链接
        
        
        [[RCIM sharedRCIM] disconnect:NO];
        
    }
}





@end
