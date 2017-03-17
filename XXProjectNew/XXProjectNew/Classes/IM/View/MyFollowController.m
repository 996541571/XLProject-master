//
//  MyFollowController.m
//  XXProjectNew
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "MyFollowController.h"
#import "MyFollowCell.h"
#import "FollowsAndFansVM.h"
#import "FindFriendsController.h"
#import "SearchFriendVC.h"
static NSString *reuseID = @"MyFollowCell";

@interface MyFollowController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property(nonatomic,strong)FollowsAndFansVM *viewModel;
@property (strong, nonatomic) IBOutlet UIButton *find;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,assign)int page;
@end

@implementation MyFollowController
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_headView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"searchBar"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(jumpToSearchVC) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_headView);
        }];
    }
    return _headView;
}

-(FollowsAndFansVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [FollowsAndFansVM shareModel];
    }
    return _viewModel;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _page = 1;
    switch (_type) {
        case 0:
            self.title = @"我的关注";
            [self getDataWithType:@"FOLLOW" withPage:_page isALL:@"false"];
            break;
        case 1:
            self.title = @"我的粉丝";
            [self getDataWithType:@"FANS" withPage:_page isALL:@"false"];
            break;
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its
//    if(![CoreStatus isNetworkEnable]){
//        [[NoticeTool notice]showTips:@"网络未连接" onView:self.view];
//    }    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_find];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MyFollowCell" bundle:nil] forCellReuseIdentifier:reuseID];

    [_tableView addFooterWithCallback:^{
        _page++;
        if (_type) {
            [self getDataWithType:@"FANS" withPage:_page isALL:@"false"];
            
        } else {
            [self getDataWithType:@"FOLLOW" withPage:_page isALL:@"false"];
        }
    }];
}
- (IBAction)findFriend:(id)sender {
    [MobClick event:@"um_my_Attention_findfriends_event"];
    FindFriendsController *find = [[FindFriendsController alloc]init];

    [self.navigationController pushViewController:find animated:YES];
}
-(void)jumpToSearchVC
{
    SearchFriendVC *find = [SearchFriendVC new];
    if (_type) {
        find.type = @"FANS";
    } else {
        find.type = @"FOLLOW";
    }
    [self.navigationController pushViewController:find animated:YES];
}
//我的粉丝和关注
-(void)getDataWithType:(NSString *)type withPage:(int)page isALL:isALL
{
    
    NSNumber *count = [NSNumber numberWithInt:page];
    [self.viewModel getMyFollowsOrFansWithType:type page:count pageSize:@10 isALL:isALL vc:self success:^(NSArray *dataArr) {
        [_dataArr addObjectsFromArray:dataArr];;
        if (_dataArr.count) {
            _noDataView.hidden = YES;
            _tableView.tableHeaderView = self.headView;
        } else {
            _noDataView.hidden = NO;
        }
        if (!dataArr.count && page > 1) {
            [[NoticeTool notice]showTips:@"没有更多数据了哦" onView:self.view];
        }
        [_tableView reloadData];
        if (page == 1) {
            [_tableView headerEndRefreshing];
        } else {
            [_tableView footerEndRefreshing];
        }

    }];
}
#pragma mark -- UITableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (_type) {
        cell.isFan = YES;
        cell.row = indexPath.row;
        cell.block = ^(NSInteger index){
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dataArr[index]];
            dict[@"bothStatus"] = @"BOTH";
            [_dataArr replaceObjectAtIndex:index withObject:dict];
        };
    } else {
        cell.isFan = NO;
    }
    if (_dataArr.count) {
        cell.dataDic = _dataArr[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonalInformationVC *person = [[PersonalInformationVC alloc]init];
    person.partyID = _dataArr[indexPath.row][@"partyId"];
    [self.navigationController pushViewController:person animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
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
