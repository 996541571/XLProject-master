//
//  OthersFollowController.m
//  XXProjectNew
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "OthersFollowController.h"
#import "OthersFollowCell.h"
#import "FollowsAndFansVM.h"
static NSString *reuseID = @"MyFollowCell";
@interface OthersFollowController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property(nonatomic,strong)FollowsAndFansVM *viewModel;
@property(nonatomic,assign)int count;
@end

@implementation OthersFollowController

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
    _count = 1;
    switch (_type) {
        case 0:
            self.title = @"Ta的关注";
            [self getDataWithType:@"FOLLOW" toPartyId:_partyID page:_count pageSize:@10];
            break;
        case 1:
            self.title = @"Ta的粉丝";
            [self getDataWithType:@"FANS" toPartyId:_partyID page:_count pageSize:@10];
            break;
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if(![CoreStatus isNetworkEnable]){
//        [[NoticeTool notice]showTips:@"网络未连接" onView:self.view];
//    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"OthersFollowCell" bundle:nil] forCellReuseIdentifier:reuseID];
    
    [self refreshData];
}

-(void)getDataWithType:(NSString *)type toPartyId:(NSNumber *)PartyId page:(int)page pageSize:(NSNumber *)pageSize
{
    NSNumber *count = [NSNumber numberWithInt:page];
    [self.viewModel getOthersFollowsOrFansWithType:type toPartyId:PartyId page:count pageSize:pageSize vc:self success:^(NSArray *dataArr) {
        if (page == 1) {
            [_dataArr removeAllObjects];
        }
        [_dataArr addObjectsFromArray:dataArr];
        if (_dataArr.count) {
            _noDataView.hidden = YES;
        } else {
            _noDataView.hidden = NO;
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
    OthersFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.row = indexPath.row;
    cell.block = ^(NSInteger index,NSString *result){
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dataArr[index]];
        dict[@"bothStatus"] = result;
        [_dataArr replaceObjectAtIndex:index withObject:dict];
    };
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

-(void)refreshData
{
    [_tableView addHeaderWithCallback:^{
        _count = 1;
        NSString *typeStr;
        if (_type) {
            typeStr = @"FANS";
        } else {
            typeStr = @"FOLLOW";
        }
        [self getDataWithType:typeStr toPartyId:_partyID page:_count pageSize:@10];
    }];
    [_tableView addFooterWithCallback:^{
        _count ++;
        NSString *typeStr;
        if (_type) {
            typeStr = @"FANS";
        } else {
            typeStr = @"FOLLOW";
        }
        [self getDataWithType:typeStr toPartyId:_partyID page:_count pageSize:@10];
    }];

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
