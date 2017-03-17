//
//  DVRedPacketCheckTVC.m
//  XXProjectNew
//
//  Created by apple on 1/10/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DVRedPacketCheckTVC.h"
#import "DVRedPacketCheckCell.h"

#import "SimpleMessage.h"

@interface DVRedPacketCheckTVC ()
@property(nonatomic,weak)UIView* headView;
@property(nonatomic,weak)UIImageView* backImgView;

//amount_label

@property(nonatomic,weak)UILabel* amount_label;

@property(nonatomic,copy)NSString* partyID;

@property(nonatomic,copy)NSString* amount;

@property(nonatomic,copy)NSString* time;

@end

@implementation DVRedPacketCheckTVC


-(UIView*)headView{
    
    
    if (!_headView) {
        
        
        UIView* temp = [UIView new];
        
        _headView = temp;
        
            _headView.backgroundColor = [UIColor whiteColor];
        
        
        
//       UIView* view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, _headView.bounds.size.width , _headView.bounds.size.height)];
        
        
//        self.tableView.tableHeaderView = view;
        
//        [view addSubview:_headView];
        
        
        self.tableView.tableHeaderView = _headView;
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.width.left.top.equalTo(self.view);
            
            make.height.equalTo(@0);
            
//            make.centerX.equalTo(self.tableView);
            
        }];


        
        
        
    }
    
    
    return _headView;
}




-(UILabel*)money_label{
    
    
    if (!_money_label) {
        
        
        UILabel* temp = [UILabel new];
        
        [self.headView addSubview:temp];
        
        _money_label = temp;
        
    }
    
    
    return _money_label;
}



-(UILabel*)greetings_label{
    
    
    if (!_greetings_label) {
        
        
        UILabel* temp = [UILabel new];
        
        temp.font = [UIFont systemFontOfSize:13];

        temp.textColor = RGB(193, 142, 7, 1);
        
        [self.headView addSubview:temp];
        
        _greetings_label = temp;
        
    }
    
    
    return _greetings_label;
}

-(UILabel*)userName_label{
    
    
    if (!_userName_label) {
        
        
        UILabel* temp = [UILabel new];
        
        temp.textColor = title_Color;
        
        temp.font = [UIFont systemFontOfSize:14];
        
        [self.headView addSubview:temp];
        
        _userName_label = temp;
        
    }
    
    
    return _userName_label;
}

-(UIImageView*)iconImgView{
    
    
    if (!_iconImgView) {
        
        
        UIImageView* temp = [UIImageView new];
        
        [self.headView addSubview:temp];
        
        _iconImgView = temp;
        
    }
    
    
    return _iconImgView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //禁止滚动
    
    self.tableView.scrollEnabled = NO;
    
    [self setupUI];
    
    //并不是一创建就走
    
//    self.index = 3;
    
    
    
    [self setBackBtn];
    
//    NSString* userID =[[NSUserDefaults standardUserDefaults] valueForKey:RC_UserID] ;
    
    
    
    
    
}

//
-(void)setSenderUserId:(NSString *)senderUserId{
    
    _senderUserId = senderUserId.copy;
    
if ([[[NSUserDefaults standardUserDefaults] valueForKey:RC_UserID] isEqualToString:senderUserId]) {
    
                    self.index = 0;
    
    
    //如果是自己红包
    
//    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:senderUserId completion:^(RCUserInfo *userInfo) {
//        
//        self.userName_label.text = userInfo.name;
    
        
//    }];

    
    
    
    
    
    
    
                }else{
    
                    self.index = 1;
                }

    
    [self.tableView layoutIfNeeded];
    
    
}



-(void)setMessageModel:(RCMessageModel *)messageModel{
    
    
    SimpleMessage* message= (SimpleMessage*)messageModel.content;
    
    //红包发送者的ID
    
    self.senderUserId = messageModel.senderUserId;
    
    
   //红包发送者的用户信息
    
    self.userName_label.text = [NSString stringWithFormat:@"%@的红包",messageModel.userInfo.name];
    

    if (messageModel.userInfo.portraitUri.length) {
        
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:messageModel.userInfo.portraitUri]];
        
        }

    
    //祝福语
    
    self.greetings_label.text = message.briberyDesc;
    
    //红包金额
    
    self.amount = message.briberyAmount;
    
    self.amount_label.text = [NSString stringWithFormat:@"%.2lf", [message.briberyAmount doubleValue] ];


    
    
    
    //接受者的ID
    
    self.targetId = messageModel.targetId;
    
    
    [self.tableView reloadData];

    
//    _messageModel = messageModel;
//    
//    self.greetings_label.text = messageModel.briberyDesc;
//    
//    self.amount = [NSString stringWithFormat:@"¥%@元", messageModel.briberyAmount];
//    
//    self.amount_label.text = self.amount;

    
}



-(void)setPacketID:(NSString *)packetID{
    
    _packetID = packetID.copy;
    
    
    [NetRequest requetWithParams:@[self.packetID] requestName:@"RedPacketService.queryRedPacketDetail" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        
        NSLog(@"%@",responseDicionary);
        
        if ([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 1000) {
        
            self.greetings_label.text = [[responseDicionary valueForKey:@"result"] valueForKey:@"description"];
            
//            self.greetings_label.text = [NSString stringWithFormat:@"%@的红包",self.greetings_label.text];
            
            self.partyID = [[responseDicionary valueForKey:@"result"] valueForKey:@"partyId"];
            
            self.amount = [NSString stringWithFormat:@"%.2lf", [ [[responseDicionary valueForKey:@"result"] valueForKey:@"amount"] doubleValue] ];
            
            self.amount_label.text = [NSString stringWithFormat:@"%.2lf",[ [[responseDicionary valueForKey:@"result"] valueForKey:@"amount"] doubleValue] ];

            
            
            self.time = [NSString stringWithFormat:@"%@",  [[responseDicionary valueForKey:@"result"] valueForKey:@"createDate"]];
        
            
//            [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:self.partyID completion:^(RCUserInfo *userInfo) {
//                
//                self.userName_label.text = [NSString stringWithFormat:@"%@的红包",userInfo.name];
//                
//                if (userInfo.portraitUri.length) {
//                    
//
//                }
//            
//                
//            }];
//            
            
            
            
            
            
            
//            [self.tableView layoutIfNeeded];
            
            [self.tableView reloadData];

            
        }
        
        
    }];

    
    
    
    
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    NSLog(@"%@",self.tableView.tableHeaderView);

    
    self.navigationController.navigationBar.barTintColor = RGB(222, 37, 42, 1);
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    #pragma mark ..navibar背景 与 阴影
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"rp_navi_bg"] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    
//    [self.tableView layoutSubviews];
    
//    [self.tableView reloadData];
    
//    [self.tableView layoutIfNeeded];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.tintColor =  blueColor;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
    
}

/** 修改当前UIViewController的状态栏颜色为白色
 
 navigation里不起作用
 
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
*/
-(void)setupUI{
    
//    self.view.backgroundColor = [UIColor redColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor = RGB(251, 245, 236, 1);
    
    self.tableView.separatorStyle = 0;
    
    
    
    
    
//    self.tableView.backgroundView.backgroundColor = [UIColor grayColor];
    
//    self.tableView.scrollEnabled = NO;
    
    
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"rp_navi_bg"];
    
    
    
    //修改中间标题
    
    UILabel* lable =[UILabel labelWithText:@"红包详情" andColor:RGB(253, 231, 199, 1) andFontSize:18 andSuperview:nil];
    
    [lable sizeToFit];
    
    self.navigationItem.titleView = lable;
    
    
    //headView 的背景
    
    UIImageView* backimgView = [UIImageView new];
    
    backimgView.image = [UIImage imageNamed:@"rp_head_bg"];
    
    self.backImgView = backimgView;
    
    backimgView.backgroundColor = [UIColor yellowColor];
    
    [self.headView addSubview:backimgView];
    
    
        
        [backimgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            #pragma mark "make.width.centerX.equalTo(self.view) 报错!"
            
            #pragma mark wrong!

            #pragma mark --
            
            
            //720 × 230 pixels
            
            make.width.centerX.equalTo(self.headView);
            
            //        make.width.centerY.equalTo(self.view).multipliedBy(0);
            
                    make.height.equalTo(@(screenWidth*(230/720.0)));
            
            make.top.left.equalTo(self.headView);
            
            
        }];
    
    
    
    //底下提示
    
   
   UILabel* label =  [UILabel labelWithText:@"收到的钱可直接用于发红包" andColor: RGB(223, 171, 110, 1) andFontSize:12 andSuperview:self.tableView];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.tableView);
        
        make.centerY.equalTo(self.tableView).multipliedBy(2).offset(-30);
        
//        [self.tableView layoutIfNeeded];
    }];
    

    

    
    
    
    
    //
    
    CGFloat  scale = screenWidth/360;
    
    self.iconImgView.backgroundColor = [UIColor redColor];
    
    self.iconImgView.image = [UIImage imageNamed:@"Mine_defaultIcon"];
    
    self.iconImgView.layer.cornerRadius = 29*scale;
    
    self.iconImgView.layer.masksToBounds = YES;
    //
    [self.iconImgView clipsToBounds];

    
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.headView);
        make.height.width.equalTo(@(58*scale));

        make.centerY.equalTo(self.backImgView).offset(25*scale);
        
        
    }];

    
    self.userName_label.text = @"王尼玛de红包";
    
    [self.userName_label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.headView);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(10);

        
    }];
    
    
    self.greetings_label.text =@"恭喜发财.大吉大利!";
    self.greetings_label.textAlignment = NSTextAlignmentCenter;
    
    self.greetings_label.numberOfLines = 2;
    
    [self.greetings_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.headView);
        make.top.equalTo(self.userName_label.mas_bottom).offset(10);
        make.width.lessThanOrEqualTo(@(screenWidth - 40));

    }];
    

    
    
    //
    UILabel* amount_label =  [UILabel labelWithText:@"0.00" andColor:RGB(215, 55, 67, 1) andFontSize:28 andSuperview:self.headView];
    
    self.amount_label = amount_label;

    
    
    
    
    //分割线
    
//    UIView * seperationLine = [UIView new];
//    
//    seperationLine.backgroundColor = RGB(237, 225, 190, 1);
//    
//    [self.headView addSubview:seperationLine];
//    
//    [seperationLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.bottom.left.right.equalTo(self.headView);
//        make.height.equalTo(@0.5);
//        
//    }];

    
    
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


-(void)setIndex:(NSInteger)index{
    
    _index = index;
    
    //    self.headView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    if (index == 0) {
        //查看自己的红包
        
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            
            make.width.equalTo(self.view);
            
            make.height.equalTo(@200);
            
//            self.tableView.tableHeaderView = self.headView;

            
        }];
        
        

        
    }else if(index == 1){
        
        //查看别人的红包
        
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            
            make.width.equalTo(self.view);
            
            make.height.equalTo(@(300 - 30));
            
//            self.tableView.tableHeaderView = self.headView;

            
        }];

        
        self.amount_label.numberOfLines = 1;
        
        
       UILabel* tail_label =  [UILabel labelWithText:@"元" andColor:RGB(215, 55, 67, 1) andFontSize:13 andSuperview:self.headView];
        
        
        
        
        [tail_label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.amount_label.mas_right).offset(0);
            make.bottom.equalTo(self.amount_label).offset(-5);
            
        }];
        
        
        [self.amount_label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(self.headView);
            
            make.top.equalTo(self.greetings_label.mas_bottom).offset(30);
            
        }];
        
        
        
        UIButton* btn = [UIButton buttonWithText:@"已存入收款账户,可直接提现" andColor:         RGB(79, 122, 160, 1) andFontSize:12 andSuperview:self.headView];
        
        [btn addTarget:self action:@selector(lookMyPacket) forControlEvents:UIControlEventTouchUpInside];
    
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            
            make.centerX.equalTo(self.headView);
            
            make.top.equalTo(_amount_label.mas_bottom).offset(10);

            
        }];
        
        
        
    }else{
        
        
//        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            
//            make.width.equalTo(self.view);
//            
//            make.height.equalTo(@200);
//            
//        }];

        
        
    }
    
    //否则布局错误
    
    
    [self.headView.superview layoutIfNeeded];
    
    
//    [self.tableView reloadData];
    
//        [self.tableView layoutIfNeeded];
    
    
    
    NSLog(@"%@",self.tableView.tableHeaderView);
//    [self.tableView.tableHeaderView.superview layoutIfNeeded];
    
//    [self.tableView layoutSubviews];
    
    
    
    //frame 修改后 重新 设置一遍防止布局错误
    
    self.tableView.tableHeaderView = self.headView;
    
//    [self.tableView setTableHeaderView:self.headView];
    
    [self.tableView.tableHeaderView layoutIfNeeded];
    
    [self.tableView reloadData];
    
 [self.tableView layoutSubviews];
    
    
    
}



-(void)lookMyPacket{
    
    
    WYWebController*first=[WYWebController new];
    first.hidesBottomBarWhenPushed=YES;
    NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];

    
    first.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
    NSLog(@"---account---%@",first.urlstr);
    
    [self.navigationController pushViewController:first animated:YES];

    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if (self.index == 0) {
        
        return 1;
    }else{
        
        return 0;
    }
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.index) {
        
        return nil;
    }
    
    
    
   UILabel* label =  [UILabel labelWithText:[NSString stringWithFormat:@"    一个红包,共%.2lf元",[self.amount doubleValue]] andColor:RGB(223, 171, 110, 1) andFontSize:12 andSuperview:nil];
    
    label.frame = CGRectMake(20, 0, 100, 20);
    
    return  label;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView registerNib:[UINib nibWithNibName:@"DVRedPacketCheckCell" bundle:nil] forCellReuseIdentifier:@"cell" ];
    
    DVRedPacketCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.amount_label.text = [NSString stringWithFormat:@"%.2lf元",[self.amount doubleValue] ];
    
    
    
    //时间戳
    
    NSTimeInterval _interval= self.time.doubleValue / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.time_label.text =  [objDateformat stringFromDate: date];

    
 
    
    if (self.targetId) {
        
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
            
            cell.userName.text = userInfo.name;
            
            if(userInfo.portraitUri.length){
                
                
                [cell.iconhead_imgV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]];
                
            }
            
            
        }];

    }
    
    
    
    
    return cell;
}



@end
