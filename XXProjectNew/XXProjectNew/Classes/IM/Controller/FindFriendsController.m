//
//  FindFriendsController.m
//  XXProjectNew
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "FindFriendsController.h"
#import "FindFriendsCell.h"
@interface FindFriendsController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITableViewCell *SearchCell;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)int page;
@end
static NSString *reuseID = @"FindFriendsCell";
@implementation FindFriendsController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(![CoreStatus isNetworkEnable]){
        [[NoticeTool notice]showTips:@"网络异常" onView:self.view];
    }
    self.title = @"找朋友";
    _searchBtn.enabled = NO;
    _searchBtn.backgroundColor = [UIColor lightGrayColor];
    [self setlayerForView:_searchView];
    [self setlayerForView:_searchBtn];
    _page = 1;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.rowHeight = 60.f;
    [_tableView registerNib:[UINib nibWithNibName:@"FindFriendsCell" bundle:nil] forCellReuseIdentifier:reuseID];
    [_tableView addFooterWithCallback:^{
        _page++;
        [self searchDataWithPage:_page];
    }];
}
-(void)textFieldDidChange:(UITextField *)field
{
    if ([field.text length] > 0) {
        _searchBtn.backgroundColor = blueColor;
        _searchBtn.enabled = YES;
    } else {
        _searchBtn.backgroundColor = [UIColor lightGrayColor];
        _searchBtn.enabled = NO;
    }
}
- (IBAction)searchFriends:(UIButton *)sender {
    [self.view endEditing:YES];
    [_dataArr removeAllObjects];
    [self searchDataWithPage:1];
}
-(void)searchDataWithPage:(int)page
{
    NSNumber *count = [NSNumber numberWithInt:page];
    NSArray *parms = @[_textField.text,count,@10];
    [NetRequest requetWithParams:parms requestName:@"UserRelationService.findFriends" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"%@",responseDicionary);
        if ([responseDicionary[@"resultStatus"] integerValue] == 1000) {
            [_dataArr addObjectsFromArray:responseDicionary[@"result"]];
            if (_dataArr.count) {
                _noDataView.hidden = YES;
            } else {
                _noDataView.hidden = NO;
            }
        }else if ([responseDicionary[@"resultStatus"] integerValue] == 2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }else{
            [[NoticeTool notice] showTips:@"网络异常" onController:self];
        }
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    }];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count) {
        return _dataArr.count + 1;
    } else {
        return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.SearchCell;
    }
    FindFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.isFan = YES;
    cell.dataDic = _dataArr[indexPath.row - 1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonalInformationVC *person = [[PersonalInformationVC alloc]init];
    person.partyID = _dataArr[indexPath.row - 1][@"partyId"];
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)setlayerForView:(UIView *)view
{
    view.layer.cornerRadius = 3.f;
    view.clipsToBounds = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
