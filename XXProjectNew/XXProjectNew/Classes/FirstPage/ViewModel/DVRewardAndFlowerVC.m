//
//  DVRewardAndFlowerVC.m
//  XXProjectNew
//
//  Created by apple on 16/11/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "DVRewardAndFlowerVC.h"
#import "DVRewardAndFlowerCell.h"
#import "NoticeTool.h"
@interface DVRewardAndFlowerVC ()
@property(nonatomic,assign)Kind kind;
@property(nonatomic,copy)NSString* nodeManagerPartyId;
@property(nonatomic,copy)NSString* nodePartyId;
//@property(nonatomic,strong)NSDictionary* cellModel;
@property(nonatomic,weak)UILabel* tips_label;
@property(nonatomic,weak)UIImageView* tips_imgV;
@property(nonatomic,strong)NSArray* dataArr;
@property(nonatomic,assign)NSInteger curPage;
@property(nonatomic,assign)NSInteger totalPage;
@property(nonatomic,getter=isNoData)BOOL NOdata;
@end


static NSString* reusedID = @"cell";
@implementation DVRewardAndFlowerVC


-(instancetype)initWithKind:(Kind)kind andNodePartyId:(NSString*)nodePartyId  andNodeManagerPartyId:(NSString*)nodeManagerPartyId andisMine:(BOOL)isMine{
    
    self = [super init];
    
    if (self) {
        
        self.kind = kind;
        
        self.nodePartyId = nodePartyId;
        
        self.nodeManagerPartyId = nodeManagerPartyId;
        
        if (kind == KindFlower) {
            
            
            
            if (isMine) {
                
                
                self.navigationItem.title = @"我的献花列表";
            }else{
                
                self.navigationItem.title = @"献花列表";


            }
            
            
        }else{
            
            if (isMine) {
                
                
                self.navigationItem.title = @"我的打赏列表";

            }else{
                
                self.navigationItem.title = @"打赏列表";

                
            }

            
            
            
            
        }
        
        
        if (nodePartyId && nodeManagerPartyId) {
            
            [self obtainWebData];
            
        }
        
    }
    
    return self;
}

-(void)loadData{
    
    
    if (self.curPage > self.totalPage || self.curPage == self.totalPage) {
        
        
        [self.tableView footerEndRefreshing];
        
        //数据最新提示
        
        UIView* v =  [UIApplication sharedApplication].keyWindow;
        
        [[NoticeTool notice]showTips:@"没有数据了" onView:v];

        
        return;
        
    }
    
    
    
    NSDictionary* dic;
    NSArray* arr;
    NSString* parameters;
    NSString* curPage = [NSString stringWithFormat:@"%td",self.curPage + 1];
    
    if (self.kind == KindFlower) {
        
        dic = @{@"toNodePartyId":self.nodePartyId,@"fromNodeManagerPartyId":self.nodeManagerPartyId,@"districtTag":@"2",@"curPage":curPage,@"pageSize":@"10"};
        
        parameters = @"PresentedFlowersService.queryHistoryRecordNode";
        
    }else{
        
        dic = @{@"toNodePartyId":self.nodePartyId,@"fromNodeManagerPartyId":self.nodeManagerPartyId,@"curPage":curPage,@"pageSize":@"10"};
        
        parameters = @"RewardService.queryHistoryRecordNode";
        
        
    }
    
    arr = @[dic];
    
    
    [NetRequest requetWithParams:arr requestName:parameters finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSString* resultStatus = [responseDicionary valueForKey:@"resultStatus"];
        
        if (resultStatus.integerValue == 1000) {
            
            
            NSArray* arr = [[responseDicionary valueForKey:@"result"] valueForKey:@"result"];
            
            
            //没有值就提示
            
            if (arr.count > 0) {
                
                
                self.dataArr = [self.dataArr arrayByAddingObjectsFromArray:[[responseDicionary valueForKey:@"result"] valueForKey:@"result"]];
                
                self.curPage ++;
                
                //拿到数据刷新一下
                
                [self.tableView reloadData];

                
            }else{
                
                //数据最新提示
                
               UIView* v =  [UIApplication sharedApplication].keyWindow;
                
                [[NoticeTool notice]showTips:@"没有数据了" onView:v];
                
                
            }
            
            
            
            
            
            
         
            
            
            
            
            
        }else if (resultStatus.integerValue == 2000){
            //过期
        }
        
        [self.tableView footerEndRefreshing];
        
    }];
    
    
    

    
    
}

-(void)obtainWebData{
    
    //RewardService.queryHistoryRecordNode
    
    NSDictionary* dic;
    NSArray* arr;
    NSString* parameters;
    
    if (self.kind == KindFlower) {
        
        dic = @{@"toNodePartyId":self.nodePartyId,@"fromNodeManagerPartyId":self.nodeManagerPartyId,@"districtTag":@"2",@"curPage":@"1",@"pageSize":@"20"};
        
        parameters = @"PresentedFlowersService.queryHistoryRecordNode";
        
    }else{
        
        dic = @{@"toNodePartyId":self.nodePartyId,@"fromNodeManagerPartyId":self.nodeManagerPartyId,@"curPage":@"1",@"pageSize":@"20"};
        
        parameters = @"RewardService.queryHistoryRecordNode";

        
    }
    
    arr = @[dic];
    
    
    [NetRequest requetWithParams:arr requestName:parameters finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSString* resultStatus = [responseDicionary valueForKey:@"resultStatus"];
        
        if (resultStatus.integerValue == 1000) {
            
            
            self.curPage = 1;
            
            self.totalPage = [[[responseDicionary valueForKey:@"result"] valueForKey:@"totalCount"] integerValue];
            
            self.dataArr = [[responseDicionary valueForKey:@"result"] valueForKey:@"result"];
            
            //没有值就提示
            
            
            self.NOdata = self.dataArr.count == 0 ? YES : NO;
            
            if (!self.isNoData) {
                
                self.tips_label.hidden = YES;
                
                self.tips_imgV.hidden  = YES;
                
            }else{
                
                self.tips_imgV.hidden = NO;
                
                self.tips_label.hidden = NO;

                
            }
            
            
        
            

            
            //拿到数据刷新一下
            
            [self.tableView reloadData];
            
        
            
            
            
        }else if (resultStatus.integerValue == 2000){
            //过期
        }
        
         [self.tableView headerEndRefreshing];
        
    }];
    

    
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
    
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];

    
}


-(void)backToLastView{
    
    [self.navigationController popViewControllerAnimated:true];

    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForCell];
    
    // 不可选择
    
    self.tableView.allowsSelection = NO;
    
    
    // 自动行高
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 2;
    
    
    //不显示多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //设置背景
    
    self.tableView.backgroundColor = RGB(222,222, 222, 1);
    
    
    
    //无数据提示框
    
    
    self.NOdata = YES;
    
    self.view.backgroundColor=RGB(233,233,233,1.0f);
    
    UIImageView*  noDataImageView=[[UIImageView alloc]init];
    
    noDataImageView.frame=CGRectMake(screenWidth/2-291/6, 100, 291/3, 378/3);
    
    noDataImageView.image=[UIImage imageNamed:@"nodata"];
    
    self.tips_imgV = noDataImageView;
    
    [self.view addSubview:noDataImageView];
    
    
    UILabel*  nodataLab=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-291/6, 100+378/3+50, 291/3, 40)];
    nodataLab.text=@"暂无数据";
    nodataLab.textColor=[UIColor lightGrayColor];
    nodataLab.textAlignment=NSTextAlignmentCenter;
    nodataLab.font=[UIFont systemFontOfSize:16];
    
    self.tips_label = nodataLab;
    
    [self.view addSubview:nodataLab];
    
    
    
    
    
    //下拉刷新
    
    
    __weak DVRewardAndFlowerVC *weakSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        
        [weakSelf obtainWebData];
        
        
    }];
    
    
    
    
    //上拉加载
    [self.tableView addFooterWithCallback:^{
        
        [weakSelf loadData];
        
        
    }];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    
}


-(void)registerForCell{
    
    
    
    UINib* nib = [UINib nibWithNibName:@"DVRewardAndFlowerCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:reusedID];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DVRewardAndFlowerCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID forIndexPath:indexPath];
    
    cell.kind = self.kind;
    
    cell.model = self.dataArr[indexPath.row];
    
    
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
