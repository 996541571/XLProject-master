//
//  BankBusinessVC.m
//  XXProjectNew
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "BankBusinessVC.h"
#import "BankBusinessCell.h"
#import "RewordView.h"
#import "RankModel.h"
#import "DVRewardAndFlowerVC.h"
#import "PersonalInformationVC.h"
@interface BankBusinessVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSDictionary *_collectDic;//榜单汇总数据源
    NSMutableArray *_rankArr;//排名数据源
    NSInteger _index;
    RankModel *_rewordModel;
    int _page;
    NSInteger _rewardTag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *MyRankCell;//我的排名cell
@property (strong, nonatomic) IBOutlet UITableViewCell *CategoryCell;//第一个cell
@property (strong, nonatomic) IBOutlet UITableViewCell *TitleCell;//省内业绩排行


@property (weak, nonatomic) IBOutlet UILabel *rankLab;//排名
@property (weak, nonatomic) IBOutlet UIButton *reword;//打赏
@property (weak, nonatomic) IBOutlet UIButton *flower;//献花
@property (weak, nonatomic) IBOutlet UILabel *cardsLab;//开卡数量
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;//站点余额
@property(nonatomic,strong)RewordView *rewordView;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@end

@implementation BankBusinessVC
-(UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideReward)];
        _tap.delegate = self;
    }
    return _tap;
}
-(RewordView *)rewordView
{
    if (!_rewordView) {
        _rewordView = [RewordView rewordView];
        _rewordView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [_rewordView.reword addTarget:self action:@selector(toReword) forControlEvents:UIControlEventTouchUpInside];
        [_rewordView  addGestureRecognizer:self.tap];
    }
    return _rewordView;
}
-(void)hideReward
{
    self.rewordView.textField.text = @"0.88";
    [self.rewordView.modifyBtn setTitle:@"修改金额" forState:UIControlStateNormal];
    self.rewordView.reword.backgroundColor = blueColor;
    [self.rewordView removeFromSuperview];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.back];
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];
    _index = 0;
}
-(void)backToLastView{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _page = 2;
    _rankArr = [NSMutableArray arrayWithCapacity:0];
    _rewordModel = [[RankModel alloc]init];
    self.title = @"银行业务";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self requestData];

    [self.tableView addHeaderWithCallback:^{
        [_rankArr removeAllObjects];
        _page = 2;
        _index = 0;
        [self requestData];
    }];
    [self.tableView addFooterWithCallback:^{
        _page++;
        [self requestWithPage:_page pageSize:10];
    }];
    
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveKeyboardNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
}


-(void)receiveKeyboardNoti:(NSNotification*)info{
    
    NSLog(@"%@",info);
    
    //UIKeyboardFrameBeginUserInfoKey
    
    //UIKeyboardFrameEndUserInfoKey
    
    NSDictionary* dic = [info valueForKey:@"userInfo"];
    
    CGRect beginRect  = [[dic valueForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect endRect  = [[dic valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    CGRect viewRect = self.view.frame;
    
    CGFloat space = endRect.origin.y - beginRect.origin.y;

    if (space > 0) {
        
        viewRect.origin.y += 20;
        

        self.view.transform = CGAffineTransformMakeTranslation(0, 20);
        
        
        
    }else{
        
        
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -20);
        
        viewRect.origin.y -= 20;
        
        
        
    }
    
    
//    self.view.frame = viewRect;
    
    
}


//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}






//上拉加载更多
-(void)requestWithPage:(int)page pageSize:(int)pageSize
{
    if (![CoreStatus isNetworkEnable]){
        [[NoticeTool notice]showTips:@"网络无法连接" onController:self];
        return;
    }
    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber *nodePartyId=[proactiveLoginDic objectForKey:@"nodePartyId"];
    if (!nodePartyId) {
        nodePartyId = @0;
    }
    NSNumber *pageCount = [NSNumber numberWithInt:page];
    NSNumber *size = [NSNumber numberWithInt:pageSize];
    NSNumber *nodeManagerPartyId=[proactiveLoginDic objectForKey:@"nodeManagerPartyId"];
    if (!nodeManagerPartyId) {
        nodeManagerPartyId = @0;
    }
    [NetRequest requetWithParams:@[@{@"nodePartyId":nodePartyId,@"nodeManagerPartyId":nodeManagerPartyId,@"districtTag":@2,@"page":pageCount,@"pageSize":size}] requestName:@"PresentedFlowersService.queryRankList" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        _index++;
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            NSArray *result = [responseDicionary[@"result"][@"result"] copy];
            for (NSDictionary *dic in result) {
                RankModel *model = [[RankModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_rankArr addObject:model];
            }
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }else{
            [[NoticeTool notice] showTips:responseDicionary[@"tips"] onController:self];
        }
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    }];
}
//下拉刷新
-(void)requestData
{
    if (![CoreStatus isNetworkEnable]){
        [[NoticeTool notice]showTips:@"网络无法连接" onController:self];
        return;
    }
//NodePartyId:站点id
//CurPage:当前页
//DistrictCode:固定传2
    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber *nodePartyId=[proactiveLoginDic objectForKey:@"nodePartyId"];
    if (!nodePartyId) {
        nodePartyId = @0;
    }
    [NetRequest requetWithParams:@[@{@"nodePartyId":nodePartyId,@"districtCode":@2}] requestName:@"PresentedFlowersService.getAgentDetail" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        _index++;
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            _collectDic = responseDicionary[@"result"];
            
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }else{
            [[NoticeTool notice] showTips:responseDicionary[@"tips"] onController:self];
        }
        if (_index == 2) {
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        }
    }];
//    榜单列表
//    入参：
//    page：当前页
//    pageSize:每页大小
//    nodePartyId：站点Id
//    nodeManagerPartyId：站长Id
//    districtTag：固定2
    [_rankArr removeAllObjects];
    NSNumber *page = @1;
    NSNumber *pageSize = @20;
    NSNumber *nodeManagerPartyId=[proactiveLoginDic objectForKey:@"nodeManagerPartyId"];
    if (!nodeManagerPartyId) {
        nodeManagerPartyId = @0;
    }
    [NetRequest requetWithParams:@[@{@"nodePartyId":nodePartyId,@"nodeManagerPartyId":nodeManagerPartyId,@"districtTag":@2,@"page":page,@"pageSize":pageSize}] requestName:@"PresentedFlowersService.queryRankList" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        _index++;
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            NSArray *result = [responseDicionary[@"result"][@"result"] copy];
            for (NSDictionary *dic in result) {
                RankModel *model = [[RankModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_rankArr addObject:model];
            }
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }else{
            [[NoticeTool notice] showTips:responseDicionary[@"tips"] onController:self];
        }
        if (_index == 2) {
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        }
    }];
}

#pragma mark -- UITableView delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return _rankArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.CategoryCell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return self.TitleCell;
        } else {
            if (_collectDic[@"balanceRank"]) {
                self.rankLab.text = [NSString stringWithFormat:@"%@",_collectDic[@"balanceRank"]];
            }
            if (_collectDic[@"rewards"]) {
                [self.reword setTitle:[NSString stringWithFormat:@"%@人打赏",_collectDic[@"rewards"]] forState:UIControlStateNormal];
            }else{
                [self.reword setTitle:@"0人打赏" forState:UIControlStateNormal];
            }
            [self.reword addTarget:self action:@selector(myreward) forControlEvents:UIControlEventTouchUpInside];
            if (_collectDic[@"flowers"]) {
                [self.flower setTitle:[NSString stringWithFormat:@"%@人献花",_collectDic[@"flowers"]] forState:UIControlStateNormal];
            }else{
                [self.flower setTitle:@"0人献花" forState:UIControlStateNormal];
            }
            [self.flower addTarget:self action:@selector(myFlower) forControlEvents:UIControlEventTouchUpInside];
            if (_collectDic[@"cardCount"]) {
                self.cardsLab.text = [NSString stringWithFormat:@"开卡数量：%@张",_collectDic[@"cardCount"]];
            }else{
                self.cardsLab.text = @"开卡数量：0张";
            }
            if (_collectDic[@"balance"]) {
                self.balanceLab.text = [NSString stringWithFormat:@"站点余额：%@元",_collectDic[@"balance"]];
            }else{
                self.balanceLab.text = @"站点余额：0.00元";
            }
            return self.MyRankCell;
        }
        
    }else{
        static NSString *ID = @"bankBusinessCell";
        BankBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"BankBusinessCell" owner:self options:nil].lastObject;
        }
        cell.rewardCount.tag = indexPath.row;
        cell.rewordIcon.tag = indexPath.row;
        cell.flowerIcon.tag = indexPath.row;
        cell.fowerCount.tag = indexPath.row;
        [cell.rewordIcon addTarget:self action:@selector(reword:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rewardCount addTarget:self action:@selector(reword:) forControlEvents:UIControlEventTouchUpInside];
        [cell.flowerIcon addTarget:self action:@selector(flower:) forControlEvents:UIControlEventTouchUpInside];
        [cell.fowerCount addTarget:self action:@selector(flower:) forControlEvents:UIControlEventTouchUpInside];
        if (_rankArr.count) {
            cell.model = _rankArr[indexPath.row];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankModel *model = _rankArr[indexPath.row];
    if ([model.hasLogin isEqualToString:@"yes"]) {
        PersonalInformationVC *person = [[PersonalInformationVC alloc]init];
        person.partyID = (NSNumber *)model.nodeManagerPartyId;
        [self.navigationController pushViewController:person animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.f;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 50.f;
        } else {
            return 180.f;
        }
        
    }else{
        return 140.f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != 2) {
        return 10.f;
    }
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    view.backgroundColor = RGB(238,238,238,1.0f);
    
    return view;
}
-(void)toReword
{
    if ([self.rewordView.textField.text floatValue] > 0) {
        [self.rewordView removeFromSuperview];
        [self.rewordView.modifyBtn setTitle:@"修改金额" forState:UIControlStateNormal];
        self.rewordView.reword.backgroundColor = blueColor;
        WYWebController *web = [[WYWebController alloc]init];
        web.urlstr = [NSString stringWithFormat:@"%@?toNodePartyId=%@&toNodeManagerId=%@&money=%@",_collectDic[@"rewardParamUrl"],_rewordModel.nodePartyId,_rewordModel.nodeManagerPartyId,self.rewordView.textField.text];
        web.block = ^(NSString *result){
            if ([result isEqualToString:@"true"]) {
//                [[NoticeTool notice]showTips:@"打赏成功" onController:self];
                [self showTips:@"打赏成功"];
                RankModel *model;
                if (_rankArr.count) {
                    model = _rankArr[_rewardTag];;
                }
                BankBusinessCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_rewardTag inSection:2]];
                [cell.rewordIcon setImage:[UIImage imageNamed:@"bank_rewordColor"] forState:UIControlStateNormal];
                [cell.rewardCount setTitle:[NSString stringWithFormat:@"%ld人打赏",model.rewards +1] forState:UIControlStateNormal];
                [cell.rewardCount setTitleColor:blueColor forState:UIControlStateNormal];
                model.rewardsMark = -1;
                model.rewards += 1;
                [_rankArr replaceObjectAtIndex:_rewardTag withObject:model];
            } else {
                [self showTips:@"打赏失败，请稍后再试"];
//                [[NoticeTool notice]showTips:@"打赏失败，请稍后再试" onController:self];
            }
        };
        [self.navigationController pushViewController:web animated:YES];
        self.rewordView.textField.text = @"0.88";
    }else{
        [[NoticeTool notice]showTips:@"打赏金额不能为0元" onController:self];
    }
    
}
-(void)rewordResult:(NSNotification *)noti
{
    NSLog(@"%@",noti.userInfo[@"rewordResult"]);
    if ([noti.userInfo[@"rewordResult"] isEqualToString:@"true"]) {
        [[NoticeTool notice]showTips:@"打赏成功" onController:self];
    } else {
        [[NoticeTool notice]showTips:@"打赏失败，请稍后再试" onController:self];
    }
}
-(void)myFlower
{
    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSString *nodePartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodePartyId"]];
    NSString *nodeManagerPartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodeManagerPartyId"]];
    DVRewardAndFlowerVC *vc = [[DVRewardAndFlowerVC alloc]initWithKind:KindFlower andNodePartyId:nodePartyId andNodeManagerPartyId:nodeManagerPartyId andisMine:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)myreward
{
    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSString *nodePartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodePartyId"]];
    NSString *nodeManagerPartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodeManagerPartyId"]];
    DVRewardAndFlowerVC *vc = [[DVRewardAndFlowerVC alloc]initWithKind:KindReward andNodePartyId:nodePartyId andNodeManagerPartyId:nodeManagerPartyId andisMine:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)reword:(UIButton *)sender
{
    _rewardTag = sender.tag;
    if (_rankArr.count) {
        _rewordModel = _rankArr[sender.tag];;
    }
    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
//    NSString *nodePartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodePartyId"]];
    NSString *nodeManagerPartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodeManagerPartyId"]];
    NSString *dd = [NSString stringWithFormat:@"%@",_rewordModel.nodeManagerPartyId];
    if ([nodeManagerPartyId isEqualToString:dd]) {
        [[NoticeTool notice]showTips:@"您不能给自己站点打赏" onController:self];
        return;
    }
    if (_rewordModel.rewardsMark == -1) {//已打赏，跳列表
        DVRewardAndFlowerVC *vc = [[DVRewardAndFlowerVC alloc]initWithKind:KindReward andNodePartyId:[NSString stringWithFormat:@"%@",_rewordModel.nodePartyId] andNodeManagerPartyId:[NSString stringWithFormat:@"%@",_rewordModel.nodeManagerPartyId] andisMine:NO];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self.view addSubview:self.rewordView];
    }
    
}
-(void)flower:(UIButton *)sender
{
    RankModel *model;
    if (_rankArr.count) {
        model = _rankArr[sender.tag];;
    }
    if (model.mark == -1) {//已献花，跳列表
        DVRewardAndFlowerVC *vc = [[DVRewardAndFlowerVC alloc]initWithKind:KindFlower andNodePartyId:[NSString stringWithFormat:@"%@",model.nodePartyId] andNodeManagerPartyId:[NSString stringWithFormat:@"%@",model.nodeManagerPartyId] andisMine:NO];
        [self.navigationController pushViewController:vc animated:YES];
    } else {//未献花
        sender.enabled = NO;
        NSString *nodeManagerPartyId = [NSString stringWithFormat:@"%@",model.nodeManagerPartyId] ;
        NSString *nodePartyId = [NSString stringWithFormat:@"%@",model.nodePartyId] ;
        if (!nodePartyId) {
            nodePartyId = @"";
        }
        if (!nodeManagerPartyId) {
            nodeManagerPartyId = @"";
        }
        [XLProgressHUD showOnView:self.view message:@"献花中..." animated:YES];
        [NetRequest requetWithParams:@[@{@"toNodePartyId":nodePartyId,@"":nodeManagerPartyId}] requestName:@"PresentedFlowersService.insertFlowersLog" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
            NSLog(@"%@",responseDicionary);
            sender.enabled = YES;
            if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
                RankModel *model = _rankArr[sender.tag];
                BankBusinessCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:2]];
                [cell.flowerIcon setImage:[UIImage imageNamed:@"bank_flowerColor"] forState:UIControlStateNormal];
                [cell.fowerCount setTitle:[NSString stringWithFormat:@"%ld人献花",model.flowers +1] forState:UIControlStateNormal];
                [cell.fowerCount setTitleColor:blueColor forState:UIControlStateNormal];
                [[NoticeTool notice]showTips:@"献花成功" onController:self];
                model.mark = -1;
                model.flowers += 1;
                [_rankArr replaceObjectAtIndex:sender.tag withObject:model];
            }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
                [[NoticeTool notice] expireNoticeOnController:self];
            }else{
                [[NoticeTool notice] showTips:responseDicionary[@"tips"] onController:self];
            }
            [XLProgressHUD hideOnView:self.view];
        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)caculation:(UIButton *)sender {
    [MobClick event:@"um_bankbusiness_calculate_click_event"];
    CalculateController *cal=[[CalculateController alloc]initWithNibName:@"CalculateController" bundle:nil];
    [self.navigationController pushViewController:cal animated:YES];
}
- (IBAction)benefit:(UIButton *)sender {
    [MobClick event:@"um_bankbusiness_earning_click_event"];
    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
    web.urlstr = [NSString stringWithFormat:@"%@?nodePartyId=%@&version=%@",_collectDic[@"profitUrl"],_collectDic[@"nodePartyId"],sysVersion];
    [self.navigationController pushViewController:web animated:YES];
}
- (IBAction)manage:(UIButton *)sender {
    [MobClick event:@"um_bankbusiness_management_click_event"];
    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
    web.urlstr = [NSString stringWithFormat:@"%@?nodePartyId=%@&version=%@",_collectDic[@"operateUrl"],_collectDic[@"nodePartyId"],sysVersion];
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)rank:(UIButton *)sender {
    [MobClick event:@"um_bankbusiness_myranking_click_event"];
    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
    web.urlstr = [NSString stringWithFormat:@"%@?version=%@&nodePartyId=%@",_collectDic[@"myRankUrl"],sysVersion,_collectDic[@"nodePartyId"]];
    [self.navigationController pushViewController:web animated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    if (touch.view.tag == 101) {
        return NO;
    }
    return YES;
}
-(void)showTips:(NSString *)tips
{
    UILabel *myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake((screenWidth-150)/2, screenHeight-49-100, 150, 30)];  //起始高度设的大点
    myAlertLabel.text= tips;
    myAlertLabel.layer.cornerRadius=6;
    myAlertLabel.layer.masksToBounds = YES;
    myAlertLabel.font=[UIFont systemFontOfSize:14];
    myAlertLabel.textAlignment=NSTextAlignmentCenter;
    myAlertLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:myAlertLabel];
    myAlertLabel.textColor=[UIColor whiteColor];
    myAlertLabel.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:1  //动画时间
                          delay:3  //开始延迟时间
                        options: UIViewAnimationOptionCurveEaseInOut  //弹入弹出
                     animations:^{
                         myAlertLabel.alpha=0;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [myAlertLabel removeFromSuperview];  //移动后隐藏
                     }];
    
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
