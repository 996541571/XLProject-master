//
//  InviteActivityViewController.m
//  XXProjectNew
//
//  Created by apple on 12/14/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "InviteActivityViewController.h"
#import "IATableViewCell.h"
#import "InviteActivityViewModel.h"
#import "InviteActivityModel.h"
#import "IATableView.h"
#import "IASrollView.h"


#import <UShareUI/UShareUI.h>

@interface InviteActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)InviteActivityViewModel*  viewModel;
@property(nonatomic,weak)IATableView* tableView;
@property(nonatomic,weak)IATableViewCell* myRankCell;
@property(nonatomic,strong)NSArray<UILabel*>* label_arr;
@property(nonatomic,strong)NSArray* btn_arr;
@property(nonatomic,weak)UIView* maskView;
@property(nonatomic,weak)UIImageView* zoom_imgV;
@property(nonatomic,weak)IASrollView* own_scroll;
@property(nonatomic,assign)CGRect origin_tableView;

//无数据
@property(nonatomic,weak)UILabel* tips_label;
@property(nonatomic,weak)UIImageView* tips_imgV;
@property(nonatomic,weak)UIView* grayView;
//


@end

@implementation InviteActivityViewController

static NSString* IATableViewCellReusedId = @"IATableViewCell";



-(UIView*)maskView{
    
    
    if (!_maskView) {
        
        
        
        UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        
        maskView.backgroundColor = RGB(0, 0, 0, 0.6);
        
        [maskView setAlpha:0];
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
        
        
        
        _maskView = maskView;
        
    }
    
    
    return _maskView;
}


-(InviteActivityViewModel*)viewModel{
    
    
    if (!_viewModel) {
        
        InviteActivityViewModel* temp = [InviteActivityViewModel model];
        
        _viewModel = temp;
        
    }
    
    
    return _viewModel;
}


-(void)loadView{
    
    IASrollView* v = [IASrollView new];
    
    self.own_scroll = v;
    
    v.delegate = self;
    
    v.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    v.contentSize = CGSizeMake(screenWidth, (2486/3.0 - 70)*(screenWidth/320.0));
    
//    v.di

    self.view = v;
    
}

-(void)backToLastView
{
    if (_isPush) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.viewModel obtainWebDataWithSuccess:^{
       
        [self.tableView reloadData];
        
        //手动刷新
        
        
        NSString* people_count = [NSString stringWithFormat:@"%d", [self.viewModel.recCount intValue]];
        
        NSString* prize = [NSString stringWithFormat:@"%.1lf", [self.viewModel.recAmtStr floatValue]];
        
        NSArray* dataText_arr = @[people_count,prize];


        
        for (int i = 0 ; i < 2; i++) {
            
//            [self LabelFactory:dataText_arr[i] andLabel:self.label_arr[i]];
            
      self.label_arr[i].text = dataText_arr[i];
            
            
        }
        
        
        //我的排行
        
        self.myRankCell.cellModel = self.viewModel.myRank;
        
        if (self.viewModel.myRank) {
            
            self.myRankCell.hidden = NO;
            
            self.tableView.frame = self.origin_tableView;
        }else{
            
            self.myRankCell.hidden = YES;
            
            
            if (self.origin_tableView.size.height) {
                
                self.tableView.frame = CGRectMake(self.origin_tableView.origin.x, self.origin_tableView.origin.y-50*(screenWidth/320.0), self.origin_tableView.size.width, self.origin_tableView.size.height+50*(screenWidth/320.0));
            }
            
        }
        
        
        //如果有数据就去掉无数据提示
        
        if ((self.viewModel.myRank) || (self.viewModel.rank_arr)) {
            
               [self.grayView removeFromSuperview];
        
        }
        
        
    }];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
//    [self setupTableView];
    
    self.navigationItem.title = @"邀请好友";
    
}


-(void)setupUI{
    
    self.view.backgroundColor =  RGB(241, 140, 42, 1);
    
    UIImageView* head_imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invite_head_img"]];
    
    //头图
    //720.252
    
    head_imgV.frame = CGRectMake(0, 0, screenWidth, (screenWidth/720.0)*252);
    
    
    [self.view addSubview:head_imgV];
    
    
    CGFloat mid_space = 100;
    
    
    
    //活动规则
    
    UIButton* btn = [UIButton buttonWithText:@"活动规则" andColor:[UIColor whiteColor] andFontSize:13 andSuperview:self.view];
    
    
    [btn addTarget:self action:@selector(activityBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        
        make.bottom.equalTo(head_imgV).offset((- 5)*(screenWidth/320.0));
        
    }];
    
    
    
    //----
    
    //mid_space btn
    
    NSArray* text_arr = @[@"已邀请",@"已获奖励"];
    
    NSString* people_count = [NSString stringWithFormat:@"%d", [self.viewModel.recCount intValue]];
    
//    NSString* people_count = @"100.0";
    
    NSString* prize = [NSString stringWithFormat:@"%.1lf", [self.viewModel.recAmtStr floatValue]];
    
//    NSString * prize = @"100.0";
    
    NSArray* dataText_arr = @[people_count,prize];
    
    NSArray* tail_arr = @[@"人",@"元"];
    
    NSMutableArray* arr = [NSMutableArray array];

    UITapGestureRecognizer *tap_L = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(midLabDidClick:)];
    
    UITapGestureRecognizer *tap_R = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(midLabDidClick:)];
    
    NSArray* tap_arr = @[tap_L,tap_R];
    

    
    
    for (int i = 0 ; i< 2; i++) {
        

        
    UILabel* label  = [UILabel labelWithText:dataText_arr[i] andColor:RGB(253, 244, 53, 1)andFontSize:20 andSuperview:self.view];
        
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        
        label.text = dataText_arr[i];
        
        NSLog(@"%@",label.text);
        
    UILabel* label_tail = [UILabel labelWithText:tail_arr[i] andColor:RGB(253, 244, 53, 1) andFontSize:13 andSuperview:self.view];
        
        
        [label_tail mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(label);
            
            make.left.equalTo(label.mas_right);
            
            
            
        }];
        

        
    label.userInteractionEnabled = YES;
        
    [label addGestureRecognizer:tap_arr[i]];
        
        
    [arr addObject:label];
    
        
    
//        label.text= @"100.0人";
        
    //加工
        
        #pragma mark ----------
        
//    [self LabelFactory:label.text andLabel:label];

    [self.view addSubview:label];

        
    
    label.frame = CGRectMake((screenWidth*(0.25+i*0.5))-30-10*i, CGRectGetMaxY(head_imgV.frame)+15, 80+i*20, 30);
        
    [label sizeToFit];
        
    label.tag = i;
    

    
        
    //btn
        
        
    DVButton* btn = [DVButton buttonWithText:text_arr[i] andColor: [UIColor whiteColor] andFontSize:14 andSuperview:self.view andType:BtnTypeRight];
        
    [btn addTarget:self action:@selector(midBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
    [btn setImage:[UIImage imageNamed:@"invite_arrow_icon"] forState:UIControlStateNormal];
    
    btn.frame = CGRectMake((screenWidth*(0.25+(i*0.5)))-50 , CGRectGetMaxY(label.frame), 90+i*10, 30);
    
    btn.tag = i;
    
    
    [self.view addSubview:btn];
    
        
        
    }
    
    self.label_arr = arr.copy;

    

    
    //分割线
    UIImageView* line_imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invite_line_icon"]];
    
    [self.view addSubview:line_imgV];
    
    line_imgV.frame = CGRectMake(screenWidth/2.0,CGRectGetMaxY(head_imgV.frame) + (mid_space - line_imgV.bounds.size.height)/2, line_imgV.bounds.size.width, line_imgV.bounds.size.height);
    
    
    
    
    
    
    
    
    
    //按钮背景
    //720.290
    UIImageView* blank_imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invite_blank_img"]];
    
    blank_imgV.frame = CGRectMake(0, CGRectGetMaxY(head_imgV.frame)+mid_space, screenWidth, (screenWidth/720.0)*290);
    
    [self.view addSubview:blank_imgV];
    
    blank_imgV.userInteractionEnabled = YES;
    


    
    
    //添加按钮--标签
    
    
    UILabel* label = [UILabel labelWithText:@"邀请好友:" andColor:RGB(230, 131, 61, 1) andFontSize:14 andSuperview:blank_imgV];
    
    label.frame = CGRectMake(22, 7, 100, 30);
    
    
    
    NSInteger count = 3;
    
    CGFloat btnWidth = 60.0;
    
    CGFloat btnHeight = 75.0;
    
    CGFloat space_Y = 10.0;
    
    CGFloat space_X = (blank_imgV.bounds.size.width -count*(btnWidth))/(count+1);

    
    NSArray* arr_name = @[@"微信好友",@"朋友圈",@"二维码邀请"];
    
    NSArray* img_name = @[@"invite_wechat.icon",@"invite_moments_icon",@"invite_code_icon"];
    
    NSMutableArray* btn_arr = [NSMutableArray array];
    
    for (int i = 0 ; i < count ; i ++) {
        
        DVButton* btn = [DVButton buttonWithText:arr_name[i] andColor:title_Color andFontSize:text_Size - 3 andSuperview:blank_imgV];
        
        //btn.backgroundColor = [UIColor redColor];
        
        [btn_arr addObject:btn];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:img_name[i]] forState:UIControlStateNormal];
        
        
        btn.frame=CGRectMake(space_X+(btnWidth+space_X)*(i% count),
                             space_Y+(btnHeight+space_Y)*(i/ count)+15,
                             btnWidth,
                             btnHeight);
        
    }
    
    
    self.btn_arr = btn_arr.copy;
    
    
    
    
    
    
    //误差比例 720-360, 320
    
    //tableView
    
    UIImageView* imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invite_rankList_backgroud"]];
    
    
    imgV.userInteractionEnabled = YES;
    
    
    
    CGFloat scale = screenWidth/360;
    
    
    
    imgV.frame = CGRectMake((screenWidth - imgV.bounds.size.width*scale)/2, CGRectGetMaxY(blank_imgV.frame)+74/3.0,imgV.bounds.size.width*scale,imgV.bounds.size.height*scale);
    
    
    
    [self.view addSubview:imgV];
    
//    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake((screenWidth - imgV.bounds.size.width)/2, CGRectGetMaxY(blank_imgV.frame)+74/3.0, imgV.bounds.size.width, imgV.bounds.size.height) style:(UITableViewStyleGrouped)];
//    
    IATableView * tableView = [[IATableView alloc]initWithFrame:CGRectMake(15, 103*(screenWidth/320), imgV.bounds.size.width -30, imgV.bounds.size.height-123*(screenWidth/320)) style:UITableViewStylePlain];
    
    
    self.origin_tableView = tableView.frame;
    
    self.own_scroll.own_table = tableView;
    
    
    #pragma mark 我的cell
    
    IATableViewCell * cell =  [[[NSBundle mainBundle]loadNibNamed:@"IATableViewCell" owner:nil options:nil] firstObject];
    
    cell.hidden = YES;
    
    self.myRankCell = cell;
    
    cell.cellModel = self.viewModel.myRank;

    
    self.tableView = tableView;
    
    cell.frame = CGRectMake(15, 50*(screenWidth/320), tableView.bounds.size.width, 49);
    
    
    [imgV addSubview:cell];
    
    
    
    [imgV addSubview:tableView];
    
    
    tableView.backgroundColor = [UIColor clearColor];


    tableView.dataSource = self;
    
    tableView.delegate  = self;
    
    tableView.separatorStyle = 0;
    
    __weak typeof(tableView)  weak_tableview = tableView;
    
    #pragma mark 下拉刷新
    
    [tableView addFooterWithCallback:^{
       
        [weak_tableview footerEndRefreshing];
        
        [self.viewModel obtaininviteUserRankingDataWithSuccess:^{
            
            [weak_tableview reloadData];
        }];
        
        
    }];
    
    
    [tableView registerNib:[UINib nibWithNibName:@"IATableViewCell" bundle:nil] forCellReuseIdentifier:IATableViewCellReusedId];
    
    //自动行高
    
    tableView.estimatedRowHeight = 2;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    //分割线
    tableView.separatorStyle = 1;
    tableView.backgroundColor = [UIColor whiteColor];
    
    
    //无数据提示框
    
    
//    self.NOdata = YES;
    
//    self.tableView.backgroundColor=RGB(233,233,233,1.0f);
    
    UIView* grayView = [UIView new];
    
    self.grayView = grayView;
    
    grayView.backgroundColor = RGB(233,233,233,1.0f);
    
    grayView.frame = CGRectMake(tableView.frame.origin.x,
                                tableView.frame.origin.y - 48,
                                tableView.frame.size.width,
                                tableView.frame.size.height + 48 );
    
    [imgV addSubview:grayView];
    
    
    
    UIImageView*  noDataImageView=[[UIImageView alloc]init];
    
    noDataImageView.frame=CGRectMake(tableView.bounds.size.width/2-291/6, 100-80, 291/3, 378/3);
    
    noDataImageView.image=[UIImage imageNamed:@"nodata"];
    
    self.tips_imgV = noDataImageView;
    
    [grayView addSubview:noDataImageView];
    
    
    UILabel*  nodataLab=[[UILabel alloc]initWithFrame:CGRectMake(tableView.bounds.size.width/2-291/6 - 5, 100+378/3+50 - 30 - 80, 291/3, 40)];
    nodataLab.text=@"暂无数据";
    nodataLab.textColor=[UIColor lightGrayColor];
    nodataLab.textAlignment=NSTextAlignmentCenter;
    nodataLab.font=[UIFont systemFontOfSize:16];
    
    self.tips_label = nodataLab;
    
    [grayView addSubview:nodataLab];

    
    
}



-(void)setupTableView{
    

    
    
}
#pragma mark 中间label点击

-(void)midLabDidClick:(UIGestureRecognizer*)tap{

    if ([MinePageViewModel model].user == 0) {
        
        [self login];
        
        return;
    }


    switch (tap.view.tag) {
        case 0:
        {
            
            [MobClick event:@"um_Invitesfriends_YYQ_click_event"];
            
            [self popToNewWebPage:self.viewModel.detail];
            
        }
            break;
        case 1:
        {
            
            [MobClick event:@"um_Invitesfriends_YHJL_click_event"];
            
            [self popToNewWebPage:self.viewModel.amt];
        }
            break;
            
            
        default:
            break;
    }

    
    
    
}

#pragma mark 中间Button 点击

-(void)midBtnDidClick:(DVButton*)btn{
    
    
    if ([MinePageViewModel model].user == 0) {
        
        [self login];
        
        return;
    }
    
    
    
    switch (btn.tag) {
        case 0:
        {
            
            [self popToNewWebPage:self.viewModel.detail];
            
            [MobClick event:@"um_Invitesfriends_YYQ_click_event"];

        }
            break;
        case 1:
        {
            
            [MobClick event:@"um_Invitesfriends_YHJL_click_event"];
            
            [self popToNewWebPage:self.viewModel.amt];
        }
            break;

            
        default:
            break;
    }
    
    
}

#pragma mark 活动介绍
-(void)activityBtnDidClick{
    
    
    [MobClick event:@"um_Invitesfriends_HDGZ_click_event"];
    
    [self popToNewWebPage:self.viewModel.desc];
    
}


#pragma mark 跳转登录

-(void)login{
    
    
    LoginController* logVC =   [LoginController new];
    
    logVC.hidesBottomBarWhenPushed  = YES;
    
    [self.navigationController pushViewController:logVC animated:YES];
    
    
    
}




- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType url:(NSString*)urlStr title:(NSString*)title msg:(NSString*)msg imgStr:(NSString*)imgStr
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = imgStr;
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:msg thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = urlStr;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
    
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = @"分享成功";
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
//            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            result = @"取消分享";
        }
        else{
//            result = [NSString stringWithFormat:@"Share fail"];
            result = @"分享失败";
        }
    }
    [[NoticeTool notice]showTips:result onController:self];

}
#pragma mark 下面三个Btn

-(void)btnDidClick:(UIButton*)btn{
    
    if ([MinePageViewModel model].user == 0) {
        
        [self login];
        
        return;
    }

    
    switch (btn.tag) {
        case 0:
        {
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                //微信
                [[NoticeTool notice]showTips:@"您未安装微信" onView:self.view];
                return;
            }
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession url:self.viewModel.wxHref title:self.viewModel.title msg:self.viewModel.msg imgStr:self.viewModel.img];
            
            //友盟埋点
            
//            um_Invitesfriends_HY_click_event
            
            [MobClick event:@"um_Invitesfriends_HY_click_event"];
            [MobClick event:@"um_banner_share_wechatfriends_click_event"];
        }
            break;
        case 1:
        {
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                //朋友圈
                [[NoticeTool notice]showTips:@"您未安装微信" onView:self.view];
                return;
            }
             [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine url:self.viewModel.wxHref title:self.viewModel.title msg:self.viewModel.msg imgStr:self.viewModel.img];
        
              //友盟埋点
         
            [MobClick event:@"um_banner_share_friendsQ_click_event"];
            
            [MobClick event:@"um_Invitesfriends_PYQ_click_event"];
        }
            break;
        case 2:
        {
        
            //友盟埋点
            
            [MobClick event:@"um_Invitesfriends_EWM_click_event"];
            
            //放大二维码
            
            //提示文字
            
            
            //二维码
            UIImageView* imgV = [UIImageView new];
            
            //提示文字
            UILabel* label = [UILabel labelWithText:@"邀请好友,获取现金奖励。" andColor:title_Color andFontSize:text_Size andSuperview:imgV];
            //底框
            UIView* backView = [UIView new];
            backView.backgroundColor = [UIColor whiteColor];
            
            //X箭头
            UIImageView* x_imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"x_cion"]];
            
            [backView addSubview:x_imgV];
            
            [x_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(backView).offset(-10);
                make.top.equalTo(backView).offset(10);
            }];
            
            [self.maskView addSubview:backView];
            
            [self.maskView addSubview:imgV];
            
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.centerX.equalTo(imgV);
                make.centerY.equalTo(imgV).offset(-20);
                make.size.equalTo(imgV).offset(40);
            }];
            
            
            label.textAlignment = 1;
            
            
            [imgV addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.centerX.equalTo(imgV);
                make.top.equalTo(imgV).offset(-16);
                make.width.equalTo(imgV.mas_width);
            }];
            
            if (self.viewModel.qrCode.length) {
                
                [imgV sd_setImageWithURL:[NSURL URLWithString:self.viewModel.qrCode]];
                
            }else{
                
                imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invite_origincode_icon"]];
                
            }
            
            //获取图片的大小
            
            //CGSize imgSize = imgV.image.size;
            
            self.zoom_imgV = imgV;
            
            [imgV setAlpha:0];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.maskView.alpha = 1;
                
                imgV.alpha = 1;
            }];
            
            
            
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.equalTo(self.maskView);
                
               // make.size.mas_equalTo(CGSizeMake(imgSize.width, imgSize.height+30));
                
            }];
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
            
//            imgV.userInteractionEnabled = NO; 
            
            [self.maskView addGestureRecognizer:tapGestureRecognizer];
            

            
            
        }
            break;

            
        default:
            break;
    }
    
    
}


-(void)hideImageView:(UITapGestureRecognizer*)tap{
    
    [tap.view removeFromSuperview];
    
    [self.zoom_imgV removeFromSuperview];
    
}


-(void)LabelFactory:(NSString*)text andLabel:(UILabel*)label{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
//    [AttributedStr addAttribute:NSFontAttributeName
//     
//                          value:[UIFont systemFontOfSize:13.0]
//     
//                          range:NSMakeRange(label.text.length - 1, 1)];
    
    
//    NSUInteger u = label.text.length;
    
//    [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:20]}
//                           range:NSMakeRange(0, label.text.length - 1)];
    
    
//    label.attributedText = AttributedStr;

    
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    
    return self.viewModel.rank_arr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    IATableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:IATableViewCellReusedId forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
//    cell.cellModel = self.viewModel.rank_arr[indexPath.row];
    
    cell.cellModel = self.viewModel.rank_arr[indexPath.row];
    
    cell.selectionStyle = 0 ;
    
    
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if (![[scrollView class] isSubclassOfClass:[UITableView class]] && [self.tableView pointInside:scrollView.contentOffset withEvent:nil]) {
//    
//        scrollView.scrollEnabled = NO;
//
//    }else{
//        
//        
//        scrollView.scrollEnabled = YES;
//        
//    }
    
//    scrollView.scrollEnabled = YES;

}
//
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    
//    
//    if (![[scrollView class] isSubclassOfClass:[UITableView class]] && [self.tableView pointInside:scrollView.contentOffset withEvent:nil]) {
//        
////        scrollView.scrollEnabled = NO;
//        
//        return;
//        
//    }else{
//        
//        
//        scrollView.scrollEnabled = YES;
//        
//    }
//
////    scrollView.scrollEnabled = YES;
//
//    
//}



@end
