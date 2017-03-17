//
//  ContactsController.m
//  XXProjectNew
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import "ContactsController.h"
#import "ContactsModel.h"
#import "ContactsViewModel.h"
#import "ContactsCell.h"
static NSString *ID = @"ContactsCell";
@interface ContactsController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)ContactsViewModel *viewModel;
@property(nonatomic,strong)NSArray *contacts;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
//@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSArray *allContacts;
@end

@implementation ContactsController
-(ContactsViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [ContactsViewModel shareModel];
    }
    return _viewModel;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"联系人";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _searchView.layer.cornerRadius = 5.f;
    _searchView.clipsToBounds = YES;
    _tableView.rowHeight = [ContactsCell rowHeight];
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.sectionHeaderHeight = 25.f;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor lightGrayColor];
    [_tableView registerNib:[UINib nibWithNibName:@"ContactsCell" bundle:nil] forCellReuseIdentifier:ID];
    [_textField addTarget:self action:@selector(searchContacts:) forControlEvents:UIControlEventEditingChanged];
    [self.viewModel getContactsDataWithBlock:^(NSArray *contacts) {
        _allContacts = [contacts copy];
        _contacts = [contacts copy];
        [self.tableView reloadData];
    }];
}
-(void)searchContacts:(UITextField *)field
{
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    if ([field.text isEqualToString:@""]) {
        for (int i = 0; i < _allContacts.count; i++) {
            for (ContactsModel *model in _allContacts[i]) {
                [dataArr addObject:model];
            }
        }
    } else {
        for (int i = 0; i < _allContacts.count; i++) {
            for (ContactsModel *model in _allContacts[i]) {
                if ([model.nikerName rangeOfString:field.text].location != NSNotFound) {
                    [dataArr addObject:model];
                }
            }
        }
    }
    NSArray *arr = [self.viewModel setUpTableSectionWithContacts:dataArr];
    _contacts = [arr copy];
    [_tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.viewModel.sectionTitles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = _contacts[indexPath.section][indexPath.row];
    return cell;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.viewModel.sectionTitles[section];
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 25.f)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, screenWidth, 25.f)];
    titleLab.text = self.viewModel.sectionTitles[section];
    titleLab.textColor = RGB(153, 153, 153, 1);
    [headView addSubview:titleLab];
    headView.backgroundColor = RGB(238, 238, 238, 1);
    return headView;
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.viewModel.sectionTitles;
//    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonalInformationVC *person = [[PersonalInformationVC alloc]init];
    ContactsModel *model = _contacts[indexPath.section][indexPath.row];
    person.partyID = (NSNumber *)model.partyId;
    [self.navigationController pushViewController:person animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
