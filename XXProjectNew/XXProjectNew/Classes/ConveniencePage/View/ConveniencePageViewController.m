//
//  ConveniencePageViewController.m
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "ConveniencePageViewController.h"
#import "ConveniecePageViewModel.h"
#import "CPTableViewcell.h"
#import "ConveniencePageModel.h"

#import "CPCellModel.h"


@interface ConveniencePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView* tableView;
@property(nonatomic,strong)ConveniecePageViewModel* viewModel;
@property(nonatomic,weak)UIView* grayview;
@end

static NSString* cellReusedID = @"cell";

@implementation ConveniencePageViewController

-(void)loadView{
    
    [self setupTableView];
}




-(void)setupTableView{
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.tableView = tableView;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.view = tableView;
    
    [tableView registerClass:[CPTableViewcell class] forCellReuseIdentifier:cellReusedID];
    
    tableView.tableFooterView = [UIView new];
    
    //35 间距是tableview 自带的
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    self.tableView.sectionFooterHeight =  10;
    
    self.tableView.sectionHeaderHeight  = 0;
    
//    self.tableView.rowHeight = CellRowHeight ;
    
    
}

-(ConveniecePageViewModel*)viewModel{
    
    
    if (!_viewModel) {
        
        
        ConveniecePageViewModel* temp = [ConveniecePageViewModel model];
        
        _viewModel = temp;
        
    }
    
    
    return _viewModel;
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"便民";
    
    self.tableView.separatorStyle = 0;
    
    
    
    [self.viewModel obtainWebDataWithSuccess:^(NSArray *arr) {
        
        
        self.viewModel.cellModel_arr = arr;
        
        [self.tableView reloadData];
        
        
        [self.grayview removeFromSuperview];
        
        
        self.navigationItem.title = self.viewModel.PageTitle;
        
    }];
    
    
    
    //grayView
    
   UIView* grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, screenWidth,  screenHeight)];
    
    self.grayview = grayView;
    
    grayView.backgroundColor= [UIColor clearColor];
    
    [self.view addSubview:grayView];
    
    
    grayView.userInteractionEnabled = YES;
    
    //imgV
    
    UIImageView*  nodataImgView=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2-69, screenHeight/3, 137,90)];
    nodataImgView.image=[UIImage imageNamed:@"noNet"];
    
    nodataImgView.userInteractionEnabled = YES;
    
    [grayView addSubview:nodataImgView];
    
    
    //btn
    
   UIButton* nodataBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight/3, screenWidth, 120)];
    [grayView addSubview:nodataBtn];
    
    
    nodataBtn.userInteractionEnabled = YES;
    
    [nodataBtn addTarget:self action:@selector(nodataPress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //lab
   UILabel*  firstLab=[[UILabel alloc]initWithFrame:CGRectMake(0, nodataImgView.frame.origin.y+90+20, screenWidth, 16)];
    
    firstLab.font=[UIFont systemFontOfSize:14];
    
    firstLab.textAlignment=NSTextAlignmentCenter;
    
    firstLab.text=@"您的网络太慢了~";
    
    firstLab.textColor = text_Color;
    
    [grayView addSubview:firstLab];
    
    //label
    
    UILabel* secondLab=[[UILabel alloc]initWithFrame:CGRectMake(0, firstLab.frame.origin.y+16+20, screenWidth, 16)];
    
    secondLab.font=[UIFont systemFontOfSize:14];
    
    secondLab.textAlignment=NSTextAlignmentCenter;
    
    secondLab.text=@"点击我刷新一下试试吧";
    
//    secondLab.textColor=RGB(238, 238, 238, 1);
    
    secondLab.textColor = text_Color;
    
    [grayView addSubview:secondLab];

    
    
    

    
    
}


-(void)nodataPress:(UIButton*)btn{
    
    
    [self.viewModel obtainWebDataWithSuccess:^(NSArray *arr) {
        
        [self.grayview removeFromSuperview];
        
        self.viewModel.cellModel_arr = arr;
        
                [self.tableView reloadData];
        
        
        self.navigationItem.title = self.viewModel.PageTitle;
        
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    
    return self.viewModel.cellModel_arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    ConveniencePageModel* model = self.viewModel.cellModel_arr[indexPath.section];
//    
//    [model cellRowHeight];
    
//    return mode
    
    return self.viewModel.cellModel_arr[indexPath.section].cellRowHeight;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CPTableViewcell* cell = [tableView dequeueReusableCellWithIdentifier:cellReusedID forIndexPath:indexPath];
    
    if (!self.viewModel) {
    
        self.viewModel = [ConveniecePageViewModel model];
    }
    
    cell.cell_model = self.viewModel.cellModel_arr[indexPath.section];
    
    cell.tag = indexPath.section;
    
    
    __weak typeof(cell ) weak_cell = cell ;
    
    cell.block = ^(DVButton* btn,NSInteger cell_tag){
        
        
        //友盟统计
        
        [self um_btnClickEvent:btn.titleLabel.text];
        
        
       //return ;
        
        
        
        /*
         
        NSLog(@"btn_tag = %td, cell_tag = %td",btn_tag,cell_tag);
        
        
        WKWebVC* webVC = [WKWebVC new];
        
        webVC.urlstr = @"https://h5-dev.xianglin.cn/appLife/dream";
        
        webVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:webVC animated:YES];
        
        
        */
        
        #pragma mark 点击事件
        
        
        
        if ([MinePageViewModel model].user == visitor && ([btn.titleLabel.text isEqualToString:@"水电煤"] )) {
            
            
            LoginController* vc = [LoginController new];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            return;

            
        }
        if ([btn.titleLabel.text isEqualToString:@"乡邻购"]||[btn.titleLabel.text isEqualToString:@"快递查询"]||[btn.titleLabel.text isEqualToString:@"火车票"]||[btn.titleLabel.text isEqualToString:@"交通违章"]||[btn.titleLabel.text isEqualToString:@"驾考题库"]) {
            WKWebVC *webVC = [WKWebVC new];
            webVC.urlstr = weak_cell.cell_model.smallCell_arr[btn.tag].murl;
            
            webVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:webVC animated:YES];
            

        } else {
            
            WYWebController *webVC = [WYWebController new];
            
            webVC.urlstr = weak_cell.cell_model.smallCell_arr[btn.tag].murl;
            
            webVC.hidesBottomBarWhenPushed = YES;
            
            
            [self.navigationController pushViewController:webVC animated:YES];
        }

    };
    
    
    return cell;
}

-(void)um_btnClickEvent:(NSString*)title{
    
    NSArray* title_arr = @[@"菜谱大全",@"火车票",@"驾考题库",@"交通违章",
                           @"快递查询",@"水电煤",@"手机充值",@"腾讯QQ充值",
                           @"乡邻购",@"周公解梦"];
    NSArray* event_arr = @[@"um_convenience_CPDQ_click_event",
                           @"um_convenience_HCPCX_click_event",
                           @"um_convenience_JKTK_click_event",
                           @"um_convenience_JTWZ_click_event",
                           @"um_convenience_KDCX_click_event",
                           @"um_convenience_SDM_click_event",
                           @"um_convenience_sjcz_click_event",
                           @"um_convenience_txQQ_click_event",
                           @"um_convenience_XLbuy_click_event",
                           @"um_convenience_ZGJM_click_event",
                           ];
    
    
    
    for (int i = 0 ; i < title_arr.count; i++) {
        
        
        if ([title isEqualToString:title_arr[i]]) {
            
            NSLog(@"%@,%@",title_arr[i],event_arr[i]);
            
            [MobClick event:event_arr[i]];
        }
        
        
    }
    
    
    
}


@end
