//
//  FirstMoreController.m
//  XXProjectNew
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define cellHeight   0.0885*screenHeight

#import "MoreMesAccounceController.h"
#import "MoreMesAccounceCell.h"


@interface MoreMesAccounceController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,retain)UILabel*myAlertLabel;


@end

@implementation MoreMesAccounceController

-(void)publicNotice
{
    self.msgVoListArr=[NSMutableArray arrayWithCapacity:0];
    [NetRequest firstPageMesMoreWithPage:1 block:^(NSDictionary *responseDicionary, NSError *error) {
        if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&responseDicionary!=nil){
            
            
            for (NSDictionary*dic in [responseDicionary objectForKey:@"result"]) {
                
                MsgVoModal*modal=[[MsgVoModal alloc]init];
                modal.createTime=[dic objectForKey:@"createTime"];
                modal.isSave=[dic objectForKey:@"isSave"];
                modal.msgStatus=[dic objectForKey:@"msgStatus"];
                modal.msgTitle=[dic objectForKey:@"msgTitle"];
                
                
                
                modal.msgType=[dic objectForKey:@"msgType"];
                
                modal.praiseSign=[dic objectForKey:@"praiseSign"];
                modal.praises=[dic objectForKey:@"praises"];
                modal.readNum=[dic objectForKey:@"readNum"];
                modal.updateTime=[dic objectForKey:@"updateTime"];
                
                modal.url=[dic objectForKey:@"url"];
                [_msgVoListArr addObject:modal];
                
            }
            [self.table reloadData];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.msgVoListArr=[NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publicNotice) name:@"public" object:nil];
    self.table.tableFooterView = [[UIView alloc]init];
    self.page=1;
    [NetRequest firstPageMesMoreWithPage:1 block:^(NSDictionary *responseDicionary, NSError *error) {
        if (![CoreStatus isNetworkEnable]) {
            return ;
        }
        NSLog(@"更多消息公告＝＝＝＝＝%@",responseDicionary);
        if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&responseDicionary!=nil){
            
            
            for (NSDictionary*dic in [responseDicionary objectForKey:@"result"]) {
                
                MsgVoModal*modal=[[MsgVoModal alloc]init];
                modal.createTime=[dic objectForKey:@"createTime"];
                modal.isSave=[dic objectForKey:@"isSave"];
                modal.msgStatus=[dic objectForKey:@"msgStatus"];
                modal.msgTitle=[dic objectForKey:@"msgTitle"];
                
                
                
                modal.msgType=[dic objectForKey:@"msgType"];
                
                modal.praiseSign=[dic objectForKey:@"praiseSign"];
                modal.praises=[dic objectForKey:@"praises"];
                modal.readNum=[dic objectForKey:@"readNum"];
                modal.updateTime=[dic objectForKey:@"updateTime"];
                
                modal.url=[dic objectForKey:@"url"];
                [_msgVoListArr addObject:modal];
                
            }
            [self.table reloadData];

        }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
        {
            [[NoticeTool notice] expireNoticeOnController:self];
        }


    }];
    self.headerView.backgroundColor=RGB(246, 246, 246, 1);
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.table addHeaderWithCallback:^{
        _page = 1;
        [NetRequest firstPageMesMoreWithPage:1 block:^(NSDictionary *responseDicionary, NSError *error) {
            if (![CoreStatus isNetworkEnable]) {
                [self.table headerEndRefreshing];
                return ;
            }
            NSLog(@"更多消息公告＝＝＝＝＝%@",responseDicionary);
            if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&[responseDicionary objectForKey:@"result"]!=nil){
                [self.msgVoListArr removeAllObjects];
                
                
                for (NSDictionary*dic in [responseDicionary objectForKey:@"result"]) {
                    
                    MsgVoModal*modal=[[MsgVoModal alloc]init];
                    modal.createTime=[dic objectForKey:@"createTime"];
                    modal.isSave=[dic objectForKey:@"isSave"];
                    modal.msgStatus=[dic objectForKey:@"msgStatus"];
                    modal.msgTitle=[dic objectForKey:@"msgTitle"];
                    modal.msgType=[dic objectForKey:@"msgType"];
                    
                    modal.praiseSign=[dic objectForKey:@"praiseSign"];
                    modal.praises=[dic objectForKey:@"praises"];
                    modal.readNum=[dic objectForKey:@"readNum"];
                    modal.updateTime=[dic objectForKey:@"updateTime"];
                    
                    modal.url=[dic objectForKey:@"url"];
                    [_msgVoListArr addObject:modal];
                    
                }
                [self.table headerEndRefreshing];

                [self.table reloadData];

            }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
            {
                [[NoticeTool notice] expireNoticeOnController:self];
            }
        }];
    }];
    [self.table addFooterWithCallback:^{
        self.page=self.page+1;
        [NetRequest firstPageMesMoreWithPage:self.page block:^(NSDictionary *responseDicionary, NSError *error) {
            NSLog(@"更多消息公告＝＝＝＝＝%@",responseDicionary);
            if (![CoreStatus isNetworkEnable]) {
                [self.table footerEndRefreshing];
                return ;
            }

            if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&responseDicionary!=nil){
                
                
                for (NSDictionary*dic in [responseDicionary objectForKey:@"result"]) {
                    
                    MsgVoModal*modal=[[MsgVoModal alloc]init];
                    modal.createTime=[dic objectForKey:@"createTime"];
                    modal.isSave=[dic objectForKey:@"isSave"];
                    modal.msgStatus=[dic objectForKey:@"msgStatus"];
                    modal.msgTitle=[dic objectForKey:@"msgTitle"];
                    
                    
                    
                    modal.msgType=[dic objectForKey:@"msgType"];
                    
                    modal.praiseSign=[dic objectForKey:@"praiseSign"];
                    modal.praises=[dic objectForKey:@"praises"];
                    modal.readNum=[dic objectForKey:@"readNum"];
                    modal.updateTime=[dic objectForKey:@"updateTime"];
                    
                    modal.url=[dic objectForKey:@"url"];
                    [_msgVoListArr addObject:modal];
                    
                }
                [self.table footerEndRefreshing];
                [self.table reloadData];

            }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
            {
                [[NoticeTool notice] expireNoticeOnController:self];
                
            }
        }];

    }];
    

    // Do any additional setup after loading the view from its nib.
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_msgVoListArr.count!=0) {
        return _msgVoListArr.count;
    }
    
    return 0;
    
}



//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"um_msg_manager_more_page_msg_click_event"];
    MsgVoModal*modal=_msgVoListArr[indexPath.row];
    WYWebController*first=[[WYWebController alloc]init];
    first.urlstr=modal.url;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *isRead = (UILabel *)[cell viewWithTag:232];
    isRead.hidden = YES;
    modal.msgStatus = @"9";
    [_msgVoListArr replaceObjectAtIndex:indexPath.row withObject:modal];
    NSLog(@"modal.url====%@",modal.url);
    [self.navigationController pushViewController:first animated:YES];
    

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return   [MoreMesAccounceCell MoreMesAccounceCellWith:tableView indexPath:indexPath msgVoListArr:self.msgVoListArr];
    
}

- (IBAction)backPress:(UIButton *)sender {
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
