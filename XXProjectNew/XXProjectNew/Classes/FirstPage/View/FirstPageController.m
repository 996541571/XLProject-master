//
//  FirstPageController.m
//  XXProjectNew
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#define firstCellTotalHeight 0.3229*screenHeight
#define firstScrollHeight 0.548*firstCellTotalHeight
#define firstFiveRoundHeight 0.452*firstCellTotalHeight
#define headetHeight 10 +  0.078*screenHeight
#define footerHeight 0.0156*screenHeight
#define secondCellHeight 0.23*screenHeight
#define thirdCellHeight   0.0885*screenHeight
#define thirdFirstNoDataHeight 0.323*screenHeight

#define defaultRowHight 49

#define viewHight (viewWid/(520.0/202))
#define viewWid  ((screenWidth-3*spaceWid)/2)
#define spaceWid 5


//Davie edited
#define narrow 10

static NSString *const FirstpageDic = @"FirstpageDic";

//#import "StartUpLoginVC.h"

#import "FirstPageController.h"
#import "WHScrollAndPageView.h"
#import "CustomCell.h"
#import "FiveBtnView.h"
#import "CustomHeaderView.h"
#import "RankController.h"
#import "SDCycleScrollView.h"
#import "WYWebController.h"
#import "MsgVoModal.h"
#import "MoreMesAccounceController.h"
#import "BankMoreController.h"
#import "NewUserView.h"
#import "NewUserEnveloppeVC.h"

#import "FPDateQueryModel.h"
#import "FPResultModel.h"

#import "YYModel.h"

#import "DVSolarDataCell.h"

#import "DVRewardAndFlowerVC.h"

#import "EarnMoneyController.h"

#import "NewsListPageViewController.h"

#import "NLTableViewCell.h"

#import "NLCollectionViewCell.h"

#import "NewsListPageViewModel.h"

#import "NewsListPageModel.h"

#import "FirstPageViewModel.h"

#import "FPBusinessModulView.h"

#import "BusinessModel.h"
#import "InviteActivityViewController.h"
#import "InviteAwardView.h"
typedef void(^IsFlag)(NSString *isFlag);

static  NSString* reusedID = @"cell";

@interface FirstPageController ()<WHcrollViewViewDelegate,UITableViewDelegate,UITableViewDataSource ,SDCycleScrollViewDelegate,UIAlertViewDelegate>


{
    NSMutableArray*headeImageArr;
    NSMutableArray*headeLabNameArr;
    NSMutableArray*thirdCellLabArr;
    NSMutableArray*fiveBtnArr;
    CGRect _fiveBtnViewRect;
    NSString*_dataValueStr;
    FiveBtnView*fiveBtnView;
    CustomHeaderView*aView;
    CustomHeaderView*aaView;
    //刚进来万一没网，消息公告下面就是空的
    UILabel*thirdCellNoDataLab;
    //标记滚动信息是光伏还是抢红包
    NSString *_activityFlag;
    NSString *_redPacketUrl;//接收抢红包界面url
    BOOL _isMustUpdate;//是否强制更新
    NSMutableArray *_pushActive;//公告跳转链接

}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic)  UITableView *table;
@property(nonatomic,retain)NSMutableArray*firstPageProfitArr;
@property(nonatomic,retain)NSDictionary*fiveBtnDic;
@property(nonatomic,retain)UILabel*myAlertLabel;
@property(nonatomic,retain)NSMutableArray*businessDtoListArr;
@property(nonatomic,strong)NSMutableArray*transferToFiveBtnViewArr;
//展示光伏信息、抢红包信息Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *DisplayCell;
@property(nonatomic,strong)SDCycleScrollView *bannerScrollView;
@property(nonatomic,strong)SDCycleScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITableViewCell *BannerCell;

@property(nonatomic,strong)NSMutableArray *titles;
@property(nonatomic,strong)NewUserView *userView;
@property(nonatomic,copy)IsFlag block;
@property (strong, nonatomic)  WHScrollAndPageView *whView;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSMutableDictionary* businessDic;
@property(nonatomic,strong)NSDictionary* solarDic;
@property(nonatomic,strong)NSMutableArray *webUrl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_top_constraint;
@property(nonatomic,strong)InviteAwardView *awardView;
@property(nonatomic,assign)BOOL transiting;
@property(nonatomic,strong)UIAlertView *offLineShow;
//新闻当前页
@property(nonatomic,assign)NSInteger currentPage;

//指引
@property(nonatomic,strong)NSIndexPath* index;

//上拉按钮
@property(nonatomic,weak)UIButton* backToTop_btn;

@property(nonatomic,strong)UIButton *msgBtn;

//新年

@property(nonatomic,assign,getter=isNewYear)BOOL newYear;

@end

//reusedID

static NSString* FPBusinessModulView_reusedID = @"bm_cell";


@implementation FirstPageController
-(UIButton *)msgBtn
{
    if (!_msgBtn) {
        _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];;
        [_msgBtn addTarget:self action:@selector(messageBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgBtn;
}
-(InviteAwardView *)awardView
{
    if (!_awardView) {
        _awardView = [InviteAwardView awardView];
        _awardView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [_awardView.close addTarget:self action:@selector(awardViewClose) forControlEvents:UIControlEventTouchUpInside];
        [_awardView.check addTarget:self action:@selector(jumpToAccount) forControlEvents:UIControlEventTouchUpInside];
    }
    return _awardView;
}
-(void)awardViewClose
{
    [self.awardView removeFromSuperview];
}
-(void)jumpToAccount
{
    WYWebController*first=[WYWebController new];
    first.hidesBottomBarWhenPushed=YES;
    NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    first.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
    
    NSLog(@"---account---%@",first.urlstr);
    
    [self.navigationController pushViewController:first animated:YES];
    [self.awardView removeFromSuperview];
}
//懒加载
-(NSMutableArray*)businessDtoListArr{
    
    if (!self.businessDic) {
        
        _businessDic = [NSMutableDictionary dictionary];
    }
    return _businessDtoListArr;
    
    
}
-(SDCycleScrollView *)bannerScrollView
{
    if (!_bannerScrollView) {
        _bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenWidth, firstScrollHeight) delegate:self placeholderImage:[UIImage imageNamed:@"banner_home"]];
        _bannerScrollView.hidesForSinglePage = NO;
        _bannerScrollView.pageDotColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _bannerScrollView.autoScrollTimeInterval = 5.f;
        _bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _bannerScrollView.currentPageDotColor = [UIColor whiteColor];
    }
    return _bannerScrollView;
}


-(UIButton*)backToTop_btn{
    
    
    if (!_backToTop_btn) {
        
        UIButton* btn = [UIButton new];
        
        _backToTop_btn = btn;
        
        //        btn.backgroundColor = [UIColor redColor];
        
        //        [btn setTitle:@"点我返回" forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"back_to_top"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        
        btn.hidden = YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.view).offset(-30);
            
            make.bottom.equalTo(self.view).offset(-78);

            
            make.size.mas_equalTo(CGSizeMake(50, 50));
            
        }];
        
        
        
    }
    
    return _backToTop_btn;
    
}

-(void)backToTop:(UIButton*)btn{
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.table selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    btn.hidden = YES;
    
}


//滚动信息View
-(SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(42, 10, screenWidth - 60, 49) shouldInfiniteLoop:YES imageNamesGroup:nil];
        _scrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _scrollView.onlyDisplayText = YES;
        _scrollView.showPageControl = NO;
        _scrollView.titleLabelBackgroundColor = [UIColor whiteColor];
        _scrollView.titleLabelTextFont = [UIFont systemFontOfSize:13];
        _scrollView.titleLabelTextColor = RGB(44, 44, 44, 1);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

//新手红包View
-(NewUserView *)userView
{
    if (!_userView) {
        _userView = [NewUserView userView];
        _userView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        _userView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_userView.claim addTarget:self action:@selector(claimEnveloppe) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userView;
}
#pragma mark -- 首页接口
//-(void)changeSkin
//{
//    [NetRequest requetWithParams:@[] requestName:@"app.IndexService.themeSwitch" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
//        NSLog(@"%@",responseDicionary);
//        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
//            if ([responseDicionary[@"result"] isEqualToString:@"DEFAULT"]) {//默认图
//                
//            } else {//新年图
//                
//                
//                self.newYear = YES;
//                
//                
//                
//            }
//        }
//        
//        
//        [self.table reloadData];
//        
//    }];
//}
//新人红包
-(void)isNewUser
{
    [NetRequest requetWithParams:@[] requestName:@"RedPacketService.isCashRedPacket" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            if ([responseDicionary[@"result"] integerValue] == 1) {//未领取
                [self.view addSubview:self.userView];
            }
        }
    }];
}
//领红包
-(void)claimEnveloppe
{
    self.userView.claim.userInteractionEnabled = NO;
    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber*partyID=[proactiveLoginDic objectForKey:@"nodeManagerPartyId"];
    [NetRequest requetWithParams:@[partyID] requestName:@"RedPacketService.cashRedPacket" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        [MobClick event:@"um_main_page_receive_hongbao_click_event"];
        [self.userView removeFromSuperview];
        self.userView.claim.userInteractionEnabled = YES;
//        NSLog(@"%@---%@",responseDicionary,error.localizedDescription);
        if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&responseDicionary!=nil){
            NSString *amount = [NSString stringWithFormat:@"%@",responseDicionary[@"result"][@"amount"]];
            NewUserEnveloppeVC *vc = [[NewUserEnveloppeVC alloc]initWithNibName:@"NewUserEnveloppeVC" bundle:nil];
            vc.count = amount;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }else{
            [[NoticeTool notice] showTips:responseDicionary[@"tips"] onController:self];
        }
    }];
    
}
//是否有未读信息
-(void)hasUnreadMsg
{
    [NetRequest requetWithParams:@[@""] requestName:@"MessageService.hasUnReadMsg" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            if ([responseDicionary[@"result"] integerValue] ==1) {
                [self.msgBtn setImage:[UIImage imageNamed:@"msgDot"] forState:UIControlStateNormal];
            } else {
                [self.msgBtn setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
            }
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice]expireNoticeOnController:self];
        }else{
            [self.msgBtn setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.msgBtn];
    }];
}
//请求banner数据
-(void)requestBannerData
{
    NSString *version = sysVersion;
    NSArray *params = [NSArray arrayWithObject:version];
    self.imageArr = [NSMutableArray arrayWithCapacity:0];
    self.webUrl = [NSMutableArray arrayWithCapacity:0];
    [NetRequest requetWithParams:params requestName:@"app.IndexService.indexBannersV2" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            NSArray *result = responseDicionary[@"result"];
            if (result.count) {
                for (NSDictionary *dic in result) {
                    [self.imageArr addObject:dic[@"bannerImageCode"]];
                    [self.webUrl addObject:dic[@"hrefUrl"]];
                }
    
            } else {
                [self.imageArr addObject:[NSString stringWithFormat:@"%@/image/banner/banner_home_new.png",ENV_H5_URL]];
                [self.webUrl addObject:[NSString stringWithFormat:@"%@/home/nodeManager/contactManager.html",ENV_H5_URL]];
            }
            
            
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice]expireNoticeOnController:self];
        }else{
            [self.imageArr addObject:[NSString stringWithFormat:@"%@/image/banner/banner_home_new.png",ENV_H5_URL]];
            [self.webUrl addObject:[NSString stringWithFormat:@"%@/home/nodeManager/contactManager.html",ENV_H5_URL]];
        }
        self.bannerScrollView.imageURLStringsGroup = self.imageArr;
    }];
    
}
-(void)publicNotice
{
    [_msgVoListArr removeAllObjects];
    [NetRequest getOpenService:^(NSDictionary *responseDicionary, NSError *error) {
        if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&responseDicionary!=nil) {
            for (NSDictionary*dic in [[responseDicionary objectForKey:@"result"]objectForKey:@"msgVoList"]) {
                
                MsgVoModal*modal=[[MsgVoModal alloc]init];
                modal.createTime=[dic objectForKey:@"createTime"];
//                NSLog(@"createTime===%@",modal.createTime);
                
                modal.isSave=[dic objectForKey:@"isSave"];
                modal.msgStatus=[dic objectForKey:@"msgStatus"];
                modal.msgTitle=[dic objectForKey:@"msgTitle"];
                
                
                
                modal.msgType=[dic objectForKey:@"msgType"];
                
                modal.praiseSign=[dic objectForKey:@"praiseSign"];
                modal.praises=[dic objectForKey:@"praises"];
                modal.readNum=[dic objectForKey:@"readNum"];
                modal.updateTime=[dic objectForKey:@"updateTime"];
//                NSLog(@"-----tileImg==%@",modal.titleImg);
                modal.url=[dic objectForKey:@"url"];
                modal.titleImg=[dic objectForKey:@"titleImg"];
                
                
                
                [_msgVoListArr addObject:modal];
                [_table reloadData];
            }

        }
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBarHidden = NO;

    self.newYear = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNewYear"];
    [self setupNaviBar];

    [self.bannerScrollView adjustWhenControllerViewWillAppera];
    
//    self.navigationController.navigationBarHidden = YES;
    
    if (!_isMustUpdate) {
        [self checkVersion];
    }
    
}

-(void)registerForCell{
    
    [self.table registerNib:[UINib nibWithNibName:@"NLTableViewCell" bundle:nil] forCellReuseIdentifier:NLTableViewReusedID];

    
    [self.table registerClass:[DVSolarDataCell class] forCellReuseIdentifier:reusedID];
    
    
    [self.table registerClass:[FPBusinessModulView class] forCellReuseIdentifier:FPBusinessModulView_reusedID];
    
    
    
    //自定义行高尝试
    
//    self.table.estimatedRowHeight = 2;
//    
//    self.table.rowHeight = UITableViewAutomaticDimension;
}


-(void)setupTableView{
    
    
    self.currentPage = 1;

    // 下拉加载
    
    
    __weak typeof(self) weakSelf = self;

    
        
        [[NewsListPageViewModel model] obtainWebDataWithType:5 andCurrentPage:@(self.currentPage) andFinished:^{
            
            
            if ( weakSelf.currentPage>3) {
                return ;
            }
            
            [weakSelf.table reloadData];
            
            weakSelf.currentPage++;
            
        }];
    
}

-(void)setupNaviBar{
    
    self.navigationItem.title = @"首页";
    
//------------messageBtn----------------
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERTYPE]);
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:USERTYPE] isEqualToString:VISITOR]) {
        [self hasUnreadMsg];
    }
}


-(void)messageBtnDidClick:(UIButton*)btn{
    [MobClick event:@"um_main_page_message_notice_click_event"];
    MoreMesAccounceController*firstMore=[MoreMesAccounceController new];
    
    firstMore.hidesBottomBarWhenPushed=YES;
    
    firstMore.navigationItem.title = @"消息列表";
    
    [self.navigationController pushViewController:firstMore animated:YES];
    
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toWeb:) name:@"pushNews" object:nil];
    [self requestBannerData];
    [self isNewUser];
    [self registerForCell];
    [self requestNotices];
    
//--------------------------------------------------------------------------------
    
//    self.table_top_constraint.constant = -50;
    
    [[FirstPageViewModel model] queryBusinessModulWithSuccess:^{
        
        
//        [self.table reloadData];
        
    }];
    
    [[FirstPageViewModel model] queryForSolarDataWithSuccess:^{
        
        
        [self.table reloadData];
        
    }];


    
    [[FirstPageViewModel model]obtainInvitePeopleNum:^(NSString *str) {
        
        if (str.length) {
            self.awardView.title.text = str;
            [self.view addSubview:self.awardView];
       }
        
    }];
    
    #pragma mark 下拉刷新
    
    
//---------------------------------------下拉刷新-------------------------------------
    
    
    
    [self.table addHeaderWithCallback:^{
       
        [self requestBannerData];
        
        [self isNewUser];
        
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:USERTYPE] isEqualToString:VISITOR]) {
            [self hasUnreadMsg];
        }
        
        [self requestNotices];
        
        [[FirstPageViewModel model] queryBusinessModulWithSuccess:^{
                        
//            [self.table reloadData];
            
        }];
        
        
        [[FirstPageViewModel model] queryForSolarDataWithSuccess:^{
            
            
            [self.table reloadData];
            
        }];
        [[FirstPageViewModel model]obtainInvitePeopleNum:^(NSString *str) {
            if (str.length) {
                self.awardView.title.text = str;
                [self.view addSubview:self.awardView];
            }
            
        }];
        
        [NewsListPageViewModel model].random_arr = nil;
        
        
        [[NewsListPageViewModel model] obtainWebDataWithType:5 andCurrentPage:@1 andFinished:^{
            
            [self.table reloadData];
        }];
        
        
        
        
//        [[FirstPageViewModel model]obtainInvitePeopleNum:^(NSString *str) {
//            
//            if (str.length) {
//                
//                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
//                
//                
//                [alertController addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//#pragma mark 邀请点击查看事件
//                    
//                    
//                    WYWebController*first=[WYWebController new];
//                    first.hidesBottomBarWhenPushed=YES;
//                    NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
//                    first.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
//                    
//                    NSLog(@"---account---%@",first.urlstr);
//                    
//                    [self.navigationController pushViewController:first animated:YES];
//                    
//                    
//                    
//                }]];
//                
//               // /Users/apple/Library/MobileDevice/Provisioning Profiles/570d03e9-291b-4b79-a351-f9c4328b069a.mobileprovision
//                
//                // 由于它是一个控制器 直接modal出来就好了
//                
//                [self presentViewController:alertController animated:YES completion:nil];
//                
//            }
//            
//        }];

        
        [self.table headerEndRefreshing];
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
//--------------------------------------------------------------------------------


    
//--------------------------------------------------------------------------------
    
    [self setupTableView];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak FirstPageController *weakSelf = self;
    
    //是否领取红包
    self.block = ^(NSString *isFlag){
        if ([isFlag isEqualToString:@"false"]) {
            [weakSelf.view addSubview:weakSelf.userView];
        }
    };
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publicNotice) name:@"public" object:nil];

    headeImageArr=[NSMutableArray arrayWithObjects:@"list",@"icon_newsRecommend", nil];
    headeLabNameArr=[NSMutableArray arrayWithObjects:@"银行业绩",@"新闻推荐", nil];
    thirdCellLabArr=[NSMutableArray arrayWithObjects:@"第一条数据",@"第二条数据", nil];

    
    self.headerView.backgroundColor=RGB(246, 246, 246, 1);
    
    self.table.delegate=self;
    self.table.dataSource=self;
    
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;

    self.table.backgroundColor=RGB(238,238,238,1.0f);

    //更新数据
    [self updateForData];
    
    NSDictionary *remoteNotification = [[NSUserDefaults standardUserDefaults]objectForKey:remoteNoti];
    if (remoteNotification) {
        if ([remoteNotification[@"msgType"] isEqualToString:@"OFFLINE"]) {
            NSString *title = remoteNotification[@"title"];
            NSString *content = remoteNotification[@"aps"][@"alert"];
            [[XLPlist sharePlist]deletePlistByPlistRoute:proactiveLogin ];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            _offLineShow = alert;
            [alert show];
        }else{
            if ([remoteNotification[@"url"] rangeOfString:@"http"].location != NSNotFound) {
                WYWebController *web = [WYWebController new];
                web.hidesBottomBarWhenPushed = YES;
                web.urlstr = remoteNotification[@"url"];
                [self.navigationController pushViewController:web animated:YES];
            }else if ([remoteNotification[@"url"] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
                InviteActivityViewController* vc = [InviteActivityViewController new];
                
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:remoteNoti];
    }
}


-(void)updateForData{

}

#pragma mark -豆腐块点击

-(void)bmCellDidClick:(DVButton*)btn{
    
    //没有数据时不会显示
    
    
        
    if( [[FirstPageViewModel model].business_arr[btn.tag].busiActive isEqualToString:@"HTML"]){
        
        //跳Web页
        
        
        //判断是否用WKWebView
        
        
        if ([[FirstPageViewModel model].business_arr[btn.tag].busiName isEqualToString:@"乡邻购"]||[[FirstPageViewModel model].business_arr[btn.tag].busiName isEqualToString:@"我的光伏"]) {
            WKWebVC *web = [[WKWebVC alloc]initWithNibName:@"WKWebVC" bundle:nil];
            
            web.urlstr = [FirstPageViewModel model].business_arr[btn.tag].hrefUrl;;
            
            web.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:web animated:YES];
            
            return;
            
        }
        
        [self popToNewWebPage:[FirstPageViewModel model].business_arr[btn.tag].hrefUrl ];

        
    }else if([[FirstPageViewModel model].business_arr[btn.tag].busiActive isEqualToString:@"ACTIVE_LOGIN"]){
        
        //跳登录
        
        LoginController* logVC =   [LoginController new];
        
        logVC.hidesBottomBarWhenPushed  = YES;
        
        [self.navigationController pushViewController:logVC animated:YES];

        
    }else if([[FirstPageViewModel model].business_arr[btn.tag].busiActive isEqualToString:@"ACTIVITY_INVITE"]){
        
        //跳邀请
        
        
        InviteActivityViewController* vc = [InviteActivityViewController new];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];

        
        
    }else if([[FirstPageViewModel model].business_arr[btn.tag].busiActive isEqualToString:@"RED_PACKET"]){
        
        //RED_PACKET
        
        
        
    }else if([[FirstPageViewModel model].business_arr[btn.tag].busiActive isEqualToString:@"ACTIVE_BANK"]){
        
        
        //如果是银行业务
        
        BankBusinessVC* vc = [BankBusinessVC new];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if([[FirstPageViewModel model].business_arr[btn.tag].busiActive isEqualToString:@"ACTIVE_PROFIT"]){
        
        //如果是赚钱页面
        
        EarnMoneyController* vc = [EarnMoneyController new];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        vc.other = YES;
        
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    
    
    }
        
        
        
        
    
    
        
    

    
    
}

//检测版本
-(void)checkVersion
{
    NSArray *requestArr = @[@{@"deviceType":@"IOS"}];
    [NetRequest requetWithParams:requestArr requestName:@"app.XLAppIndexPageService.version" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
//        NSLog(@"checkVersion---%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            
            NSDictionary*  result = responseDicionary[@"result"];
            
            NSString* version = result[@"version"];
            
            NSString* local_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            //
            //如果等于-1
            if ([result[@"updateLevel"] integerValue] == -1) {
                
                return ;
                
                
            } else {
                
                //如果等于0或者1
                //判断大小
                
                NSString *version_after = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                NSString* local_version_after= [local_version stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                NSLog(@"%@,%@",version_after,local_version_after);
                
                //如果有新版本
                if (version_after.integerValue > local_version_after.integerValue) {
                    NSString *cancel;
                    if ([result[@"updateLevel"] integerValue] == 0) {
                        cancel = @"取消";
                        _isMustUpdate = YES;
                    } else {
                        cancel = nil;
                        
                    }
                    
                    NSString* message = result[@"desc"];
                    self.message = message;
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:@"确定", nil];
                    //                    [alert show];
                    
                    
                    
                    
                    //如果你的系统大于等于7.0
                    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
                    {
                        CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(240,400) lineBreakMode:NSLineBreakByTruncatingTail];
                        
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(+10, 0,260, size.height)];
                        
                        //                        UILabel* textLabel = [UILabel new];
                        
                        textLabel.font = [UIFont systemFontOfSize:15];
                        textLabel.textColor = [UIColor blackColor];
                        textLabel.backgroundColor = [UIColor clearColor];
                        textLabel.lineBreakMode =NSLineBreakByWordWrapping;
                        textLabel.numberOfLines =0;
                        textLabel.text = message;
                        
                        if (size.height > 20) {
                            
                            textLabel.textAlignment =NSTextAlignmentLeft;
                        }else{
                            
                            textLabel.textAlignment = NSTextAlignmentCenter;
                        }
                        
                        
                        UIView* textView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, 280, size.height)];
                        [textView addSubview:textLabel];
                        [alert setValue:textView forKey:@"accessoryView"];
                        
                        alert.message =@"";
                    }else{
                        NSInteger count = 0;
                        for( UIView * view in alert.subviews )
                        {
                            if( [view isKindOfClass:[UILabel class]] )
                            {
                                count ++;
                                if ( count == 2 ) { //仅对message左对齐
                                    UILabel* label = (UILabel*) view;
                                    label.textAlignment =NSTextAlignmentLeft;
                                }
                            }
                        }
                    }
                    [alert show];
                }

            }
            
        } else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }
    }];
}
//公告数据
-(void)requestNotices
{
    _titles = [NSMutableArray arrayWithCapacity:0];
    _pushActive = [NSMutableArray arrayWithCapacity:0];
    [NetRequest requetWithParams:@[@{}] requestName:@"RedPacketService.getPointRushList" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
//        NSLog(@"%@",responseDicionary);
        
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            
            NSDictionary *result = responseDicionary[@"result"];
            NSArray *pVosList = result[@"pVosList"];
            for (NSDictionary *dict in pVosList) {
                [_titles addObject:dict[@"pointRush"]];
                [_pushActive addObject:dict[@"pushActive"]];
            }
            
            self.scrollView.titlesGroup = _titles;
        }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }
       
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 协议里面方法

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        if (indexPath.row == 1  &&[FirstPageViewModel model].business_arr.count) {
            return 100;
        }else if (indexPath.row == 2){
            return 60.f;
        }else if(indexPath.row == 0){
            return firstScrollHeight;
        }else{
            return 0;
        }

    }else if(indexPath.section==1){
        
        //solarView 高度
        //子View的高度*2+ 标题高度 + 间距
        return viewHight*2+50+22;
        
    }else
    {
        //cell高100
        
        if (indexPath.row == 0) {
            
            return 110;
        }
        
        return 100;
    }
}
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        NSLog(@"------ _msgVoListArr.count==%lu",(unsigned long)_msgVoListArr.count);
        
        /*
         
         返回新闻
         
         */
        
        
        return [NewsListPageViewModel model].random_arr.count;

    }
    else if (section == 0){
        return 3;
    }
    
    return 1;
}
//组头距离
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        
        return headetHeight;
    }
    return 0;
}

//组头视图
#pragma mark 组头视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    __weak FirstPageController *weakSelf = self;
    float hei;
    if (section==0) {
        hei=0;
    }else
    {
       hei= headetHeight;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hei - 0.5)];//减边线高
    view.backgroundColor = RGB(255,255,255,1.0f);

    if (section==2) {
        [aaView removeFromSuperview];
        
        CGRect _frame = view.frame;
        
        _frame.size.height = headetHeight ;
        
        aaView=[[CustomHeaderView alloc]initWithFrame:_frame labelNameStr:headeLabNameArr[section-1] imageNameStr:headeImageArr[section-1] section:section dataValue:_dataValueStr];
       
        aaView.headerClickBlock=^(int tag)
        {
            #pragma mark -
            #pragma mark 头条新闻入口
            
            //new-codes
            
           NewsListPageViewController* newsPage =  [[NewsListPageViewController alloc]init];
            
//            [newsPage loadView];
            
            weakSelf.navigationController.navigationBarHidden = NO;
            
            newsPage.hidesBottomBarWhenPushed = YES;
            
            [weakSelf.navigationController pushViewController:newsPage animated:YES];
            
            //um_main_page_news_click_event
            
            //埋点
            [MobClick event:@"um_main_page_news_click_event"];
        };
        [view addSubview:aaView];

    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==2)
    {
    return 0.01;
    }
    
    if(section==0)
    {
        return 10;
    }

    return footerHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, footerHeight)];
    view.backgroundColor = RGB(238,238,238,1.0f);

    return view;
}


#pragma mark "显示cell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    #pragma mark 第0组cell
    if (indexPath.section==0) {
        
        //section 0 有两行,第一行是一个复合view,第二行是小喇嘛
        if (indexPath.row == 2) {
            self.scrollView.titlesGroup = _titles;
            [self.DisplayCell addSubview:self.scrollView];
            //小喇叭放在0组下面
            return self.DisplayCell;
        //section 0 第一行
        } else if (indexPath.row == 1){
            
            #pragma mark 豆腐块
            
            
            FPBusinessModulView* bmCell = [tableView dequeueReusableCellWithIdentifier:FPBusinessModulView_reusedID forIndexPath:indexPath];
            bmCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            bmCell.newYear = self.isNewYear;
            
            bmCell.model_arr = [FirstPageViewModel model].business_arr ;
            
            
                
            for (int i = 0  ;  i < bmCell.model_arr.count; i++) {
                
                [bmCell.btn_arr[i] addTarget:self action:@selector(bmCellDidClick:) forControlEvents:UIControlEventTouchUpInside];
            }

            return bmCell;
            
            
        }else {
            
            
            [self.BannerCell.contentView addSubview:self.bannerScrollView];
            return self.BannerCell;
            
        }
        
    #pragma mark 第1组cell
    }else if(indexPath.section==1)
    {
        //分割线
        
        //判断是否是该组的最后一个cell

        #pragma mark solar
        //保留两位小数
        //累计发电：etotal，累计收益：income，减少伐木：totalplant，减少排放：co2
        
        DVSolarDataCell* DVcell = [tableView dequeueReusableCellWithIdentifier:reusedID forIndexPath:indexPath];
        
        DVcell.separate_line.hidden = false;

        
        if ([FirstPageViewModel model].solarDic) {
            
            DVcell.dataModel = [FirstPageViewModel model].solarDic;
            
        }
        
        return DVcell;
        
        
    }else
    {
        
        NLTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NLTableViewReusedID forIndexPath:indexPath];
        if (![NewsListPageViewModel model].random_arr.count) {
            return nil;
        }
        
        cell.model = [NewsListPageViewModel model].random_arr[indexPath.row];
        #pragma mark "判断数组是否为空,为空无法判断"
        
        //判断是否是该组的最后一个cell

        if ( _msgVoListArr.count && indexPath.row + 1 == [tableView numberOfRowsInSection:indexPath.section] ) {

            cell.separate_line.hidden = false;
            
        }else{
            
            cell.separate_line.hidden = true;
            
        }
        
        
        return cell;
    }
    
}

#pragma mark 点击cell事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.section == 1) {
        
        [MobClick event:@"um_main_page_guangfu_data_click_event"];
       
        WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
        web.urlstr = [NSString stringWithFormat:@"%@/home/nodeManager/guangfu.html",ENV_H5_URL];
        
        //[NSString stringWithFormat:@"%@/home/nodeManager/guangfu.html",ENV_H5_URL];
        web.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:web animated:YES];

    }
    
    
    if (indexPath.section==2) {
        
        //----------------------------------------------
        
        
        [MobClick event:@"um_page_topnews_click_event"];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        WKWebVC* webVC = [WKWebVC new];
        
        NewsListPageModel* model_ = [NewsListPageViewModel model].random_arr[indexPath.row];
        
        webVC.urlstr = model_.url;
        
        webVC.msgImage = model_.titleImg;
        
        webVC.msgTitle = model_.msgTitle;
        webVC.message = model_.message;
        webVC.hidesBottomBarWhenPushed = YES;

        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
   
}

#pragma mark 静默加载

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (!tableView.dragging) {
        
        return;
        
    }
    

    
    
    if (indexPath.row > self.index.row) {
        
        if(indexPath.row > 10){
            
            self.backToTop_btn.hidden = NO;
            
        }
        
        
        
    }else{
        
        
        if(indexPath.row < 5){
            
            self.backToTop_btn.hidden = YES;
        }
        
        
        
    }
    
    
    self.index = indexPath;
    
    
    
    
    if (indexPath.row ==  9 || indexPath.row == 19) {
        
        [[NewsListPageViewModel model] obtainWebDataWithType:5 andCurrentPage:@(self.currentPage) andFinished:^{
            
            if ( self.currentPage>3) {
                return ;
            }
            
            [self.table reloadData];
            
            self.currentPage++;
            
        }];
    }

    
}


#pragma mark -
#pragma mark - 其他
-(void)jiayouClick
{
    [MobClick event:@"um_mian_page_earnings_calculate_entrance_click_event"];
    CalculateController*cal=[CalculateController new];
    cal.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:cal animated:YES];
}
-(void)rankClick:(UIButton*)btn
{
    [MobClick event:@"um_main_page_income_list_click_event"];
    RankController*rank=[RankController new];
    rank.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rank animated:YES];
    
    NSLog(@"-------%ld",(long)btn.tag);
}
#pragma mark -- SDCycleScrollView Delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if (index == _titles.count - 1) {
        [self requestNotices];
    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
    if (cycleScrollView == self.scrollView) {
        NSString *pushUrl = _pushActive[index];
        if ([pushUrl rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
            InviteActivityViewController* vc = [InviteActivityViewController new];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([pushUrl rangeOfString:@"http"].location != NSNotFound){
            web.urlstr = pushUrl;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        [MobClick event:@"um_main_page_message_rolling_1_click_event"];
        
    } else {
        
        
        NSArray *urlArr = self.webUrl;
        if ([urlArr[index] rangeOfString:@"ACTIVITY_INVITE"].location != NSNotFound) {
            InviteActivityViewController* vc = [InviteActivityViewController new];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];

        } else {
            if (urlArr.count) {
                if (urlArr.count==1) {
                    web.urlstr=urlArr[0];
                    
                }else
                {
                    web.urlstr=urlArr[index];
                }
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];

        }
            
            switch (index) {
                case 0:
                    [MobClick event:@"um_main_page_banner_1_click_event"];
                    break;
                case 1:
                    [MobClick event:@"um_main_page_banner_2_click_event"];
                    break;
                case 2:
                    [MobClick event:@"um_main_page_banner_3_click_event"];
                    break;
                case 3:
                    [MobClick event:@"um_main_page_banner_4_click_event"];
                    break;
                case 4:
                    [MobClick event:@"um_main_page_banner_5_click_event"];
                    break;
                case 5:
                    [MobClick event:@"um_main_page_banner_6_click_event"];
                    break;
                case 6:
                    [MobClick event:@"um_main_page_banner_7_click_event"];
                    break;
                case 7:
                    [MobClick event:@"um_main_page_banner_8_click_event"];
                    break;
                case 8:
                    [MobClick event:@"um_main_page_banner_9_click_event"];
                    break;
                case 9:
                    [MobClick event:@"um_main_page_banner_10_click_event"];
                    break;
                default:
                    break;
            }

        }
    }
    
}

- (NSString *)dealThevideoTime:(double)time
{
    NSDate *detaildate= [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _offLineShow) {
        [[XLPlist sharePlist]deletePlistByPlistRoute:proactiveLogin ];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
        LoginController *login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
        login.hidesBottomBarWhenPushed = YES;
        login.isExit = YES;
        [self presentViewController:login animated:YES completion:nil];
        return;
    }
    if (alertView.numberOfButtons == 2 ) {
        if (buttonIndex) {
            NSURL* url = [[NSURL alloc]initWithString:@"itms-apps://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8"];
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
        //https://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8

    }
    
    if (alertView.numberOfButtons == 1) {
        
        
        [alertView show];
        
        
        //https://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8
        
        NSURL* url = [[NSURL alloc]initWithString:@"itms-apps://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8"];
        
        [[UIApplication sharedApplication]openURL:url];
        
        
        
    }

}
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView == _offLineShow) {
        return;
    }
    if (alertView.numberOfButtons == 1) {
        
        
        
        NSString* message = self.message;
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //                    [alert show];
        
        alert.delegate = self;
        
        
        //如果你的系统大于等于7.0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(240,400) lineBreakMode:NSLineBreakByTruncatingTail];
            
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(+10, 0,260, size.height)];
            
            //                        UILabel* textLabel = [UILabel new];
            
            textLabel.font = [UIFont systemFontOfSize:15];
            textLabel.textColor = [UIColor blackColor];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.lineBreakMode =NSLineBreakByWordWrapping;
            textLabel.numberOfLines =0;
            textLabel.text = message;
            
            if (size.height > 20) {
                
                textLabel.textAlignment =NSTextAlignmentLeft;
            }else{
                
                textLabel.textAlignment = NSTextAlignmentCenter;
            }
            
            
            UIView* textView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, 280, size.height)];
            [textView addSubview:textLabel];
            [alert setValue:textView forKey:@"accessoryView"];
            
            alert.message =@"";
        }else{
            NSInteger count = 0;
            for( UIView * view in alert.subviews )
            {
                if( [view isKindOfClass:[UILabel class]] )
                {
                    count ++;
                    if ( count == 2 ) { //仅对message左对齐
                        UILabel* label = (UILabel*) view;
                        label.textAlignment =NSTextAlignmentLeft;
                    }
                }
            }
        }
        [alert show];
        
        
    }
    
    
}

-(void)dealForBusinessModuleArrWithName:(NSString*)name{
    
    //如果没有从数组删去
    NSDictionary* dicSOLAR = self.businessDic[name];
    
    if ([dicSOLAR[@"businessStatus"] isEqualToString:@"NONE"]) {
        
        [self.businessDic removeObjectForKey:name];
        
    }

}

-(NSMutableArray*)dealWithBusinessModule{
    
      //判断是否开通响应业务来展现业务模块
    
    NSMutableArray* arr = [NSMutableArray array];
    
    
    //如果没有办理就不显示
    
    [self dealForBusinessModuleArrWithName:@"SOLAR"];
    [self dealForBusinessModuleArrWithName:@"BANK"];
    [self dealForBusinessModuleArrWithName:@"LOAN"];
    
    
    //增加其他业务
    
    NSDictionary* dic = @{@"businessType":@"OTHER",@"h5url":@"nil"};
    
    [self.businessDic setObject:dic forKey:@"otherBusiness"];
    
    
    
    //都没有开通的话
    if (!self.businessDic[@"SOLAR"] && !self.businessDic[@"BANK"] && !self.businessDic[@"LOAN"]) {
        
        //不取消 手机充值,乡邻易购
        
    }else{
        
        //取消 手机充值 ,乡邻易购
        
        [self.businessDic removeObjectForKey:@"MOBILERECHARGE"];
        [self.businessDic removeObjectForKey:@"ESHOP"];
        
        
    }

    
    //按自定义顺序添加
    
    [self sortedArrayUsingCustomMethod:arr];
    
    

    
    return arr.copy;
    
}

-(void)sortedArrayUsingCustomMethod:(NSMutableArray*)arr{
    

    NSArray* array = @[@"BANK",@"LOAN",@"SOLAR",@"ESHOP",@"MOBILERECHARGE",@"OTHER"];
    
    for (int i  = 0 ; i < array.count; i++) {
        
        for (NSDictionary* dic  in self.businessDic.allValues) {
            
            if ([[dic valueForKey:@"businessType"] isEqualToString:array[i]]) {
                
                [arr addObject:dic];
                
            }
            
        }
    }

}



@end
