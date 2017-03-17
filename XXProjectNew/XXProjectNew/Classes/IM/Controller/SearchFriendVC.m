//
//  SearchFriendVC.m
//  XXProjectNew
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "SearchFriendVC.h"
#import "FindFriendsCell.h"
#import "FollowsAndFansVM.h"

static NSString *reuseID = @"FindFriendsCell";
@interface SearchFriendVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFiel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)NSMutableArray *searchArr;
@property(nonatomic,strong)FollowsAndFansVM *viewModel;
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation SearchFriendVC
-(FollowsAndFansVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [FollowsAndFansVM shareModel];
    }
    return _viewModel;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if(![CoreStatus isNetworkEnable]){
//        [[NoticeTool notice]showTips:@"网络未连接" onView:self.view];
//    }
    [_textFiel becomeFirstResponder];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 60.f;
    _bgView.layer.cornerRadius = 3.f;
    _bgView.clipsToBounds = YES;
    [_textFiel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tableView registerNib:[UINib nibWithNibName:@"FindFriendsCell" bundle:nil] forCellReuseIdentifier:reuseID];
}
-(void)getData
{
    [self.viewModel getMyFollowsOrFansWithType:_type page:@0 pageSize:@0 isALL:@"true" vc:self success:^(NSArray *dataArr) {
        _dataArr = [dataArr copy];
    }];
}
-(void)textFieldDidChange:(UITextField *)field
{
    [self searchWithKeyWord:field.text];
}
-(void)searchWithKeyWord:(NSString *)keyWord
{
    _searchArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.dataArr) {
        NSString *name = dict[@"nikerName"];
        if ([name rangeOfString:keyWord].location != NSNotFound) {
            [_searchArr addObject:dict];
        }
    }
    [_tableView reloadData];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.dataDic = _searchArr[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonalInformationVC *person = [[PersonalInformationVC alloc]init];
    person.partyID = _searchArr[indexPath.row][@"partyId"];
    [self.navigationController pushViewController:person animated:YES];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByAppendingString:string];
    if (text.length > 20) {
        return NO;
    } else {
        return YES;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
