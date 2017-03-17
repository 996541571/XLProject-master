//
//  MoreMonthConroller.m
//  XXProjectNew
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define footer 0.0156*screenHeight
#define header  0.073*screenHeight    
#define cellHeight 0.255*screenHeight
#import "MoreMonthConroller.h"
#import "MoneyMoreView.h"
#import "MoneyMoreCell.h"



@interface MoreMonthConroller ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*monthArr;
    UIImageView*noDataImageView;
    UILabel*nodataLab;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,retain)NSMutableArray*modalArr;
//防止返回的数据是1000，但数组时空
@property(nonatomic,retain)NSMutableArray*arr;

@property(nonatomic,assign)int page;
@property(nonatomic,retain)UILabel*myAlertLabel;



@end

@implementation MoreMonthConroller
-(void)setupUI{
    
    
    self.table.backgroundColor = RGB(241, 241, 241, 1);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.page=1;

    //    self.table.backgroundColor=RGB(233,233,233,1.0f);

    noDataImageView=[[UIImageView alloc]init];
//    noDataImageView.bounds=CGRectMake(0, 0, 291/3, 378/3);
//    noDataImageView.center=self.table.center;
    noDataImageView.frame=CGRectMake(screenWidth/2-291/6, 100, 291/3, 378/3);
//    noDataImageView.backgroundColor=[UIColor redColor];
    noDataImageView.image=[UIImage imageNamed:@"nodata"];
    nodataLab=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-291/6, 100+378/3+50, 291/3, 40)];
    nodataLab.text=@"暂无数据";
    nodataLab.textColor=[UIColor lightGrayColor];
    nodataLab.textAlignment=NSTextAlignmentCenter;
    nodataLab.font=[UIFont systemFontOfSize:16];
    
    



    self.modalArr=[NSMutableArray arrayWithCapacity:0];
    self.arr=[NSMutableArray arrayWithCapacity:0];


    [NetRequest earnMoneyMoreListWithPage:1 block:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"-----%@",[responseDicionary objectForKey:@"result"]);
        if ([[responseDicionary objectForKey:@"result"]count]==0 ) {
            
            [self.table addSubview:noDataImageView];
            [self.table addSubview:nodataLab];

            
        }
        
        if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&[[responseDicionary objectForKey:@"result"]count]!=0){
            self.arr=[responseDicionary objectForKey:@"result"];
           
        
        for (NSDictionary*dic in [responseDicionary objectForKey:@"result"]) {
            MoreMonthModal*modal=[[MoreMonthModal alloc]init];
            modal.bankProfit=[dic objectForKey:@"bankProfit"];
            modal.eshopProfit=[dic objectForKey:@"eshopProfit"];
            modal.loanProfit=[dic objectForKey:@"loanProfit"];
            modal.liveEchargeProfit=[dic objectForKey:@"liveEchargeProfit"];
            modal.mobileEchargeProfit = dic[@"mobileEchargeProfit"];
            modal.month=[dic objectForKey:@"month"];
            modal.total=[dic objectForKey:@"total"];
            modal.totalProfit=[dic objectForKey:@"totalProfit"];
            modal.year=[dic objectForKey:@"year"];
            [self.modalArr addObject:modal];
            
            
            
        }
        [self.table reloadData];
    }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
        {
            [[NoticeTool notice]expireNoticeOnController:self];
        }
    }];

   
    monthArr=[NSMutableArray arrayWithObjects:@"7月",@"6月",@"5月", nil];
    
    
    self.headerView.backgroundColor=RGB(246, 246, 246, 1);
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=NO;
    //    self.table.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//    self.table.backgroundColor=[UIColor whiteColor];
    [self.table addHeaderWithCallback:^{
        [NetRequest earnMoneyMoreListWithPage:1 block:^(NSDictionary *responseDicionary, NSError *error) {
            if ([[responseDicionary objectForKey:@"result"]count]!=0 ) {
                
                [nodataLab removeFromSuperview];
                [noDataImageView removeFromSuperview];
                
                
            }

            NSLog(@"更多赚钱＝＝＝＝＝%@",responseDicionary);
            if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&responseDicionary!=nil){
                [self.modalArr removeAllObjects];
                
                
                for (NSDictionary*dic in [responseDicionary objectForKey:@"result"]) {
                    MoreMonthModal*modal=[[MoreMonthModal alloc]init];
                    modal.bankProfit=[dic objectForKey:@"bankProfit"];
                    modal.eshopProfit=[dic objectForKey:@"eshopProfit"];
                    modal.loanProfit=[dic objectForKey:@"loanProfit"];
                    modal.liveEchargeProfit=[dic objectForKey:@"liveEchargeProfit"];
                    modal.mobileEchargeProfit = dic[@"mobileEchargeProfit"];
                    modal.month=[dic objectForKey:@"month"];
                    modal.total=[dic objectForKey:@"total"];
                    modal.totalProfit=[dic objectForKey:@"totalProfit"];
                    modal.year=[dic objectForKey:@"year"];
                    [self.modalArr addObject:modal];
                    
                    
                    
                }
                [self.table headerEndRefreshing];
                
                [self.table reloadData];
                
            }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
            {
                [[NoticeTool notice]expireNoticeOnController:self];
            }

        }];
    }];
    [self.table addFooterWithCallback:^{
        
        self.page=self.page+1;
        NSLog(@"earnMoneyMore---self.page=%d",self.page);
        [NetRequest earnMoneyMoreListWithPage:self.page block:^(NSDictionary *responseDicionary, NSError *error) {
            NSLog(@"更多赚钱加载＝＝＝＝＝%@＝＝页数==%d",responseDicionary,self.page);
            if ([[responseDicionary objectForKey:@"result"]count]!=0 ) {
                
                [nodataLab removeFromSuperview];
                [noDataImageView removeFromSuperview];
                
                
            }

            if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000&&responseDicionary!=nil){
                
                
                for (NSDictionary*dic in [responseDicionary objectForKey:@"result"]) {
                    MoreMonthModal*modal=[[MoreMonthModal alloc]init];
                    modal.bankProfit=[dic objectForKey:@"bankProfit"];
                    modal.eshopProfit=[dic objectForKey:@"eshopProfit"];
                    modal.loanProfit=[dic objectForKey:@"loanProfit"];
                    modal.liveEchargeProfit=[dic objectForKey:@"liveEchargeProfit"];
                    modal.mobileEchargeProfit = dic[@"mobileEchargeProfit"];
                    modal.month=[dic objectForKey:@"month"];
                    modal.total=[dic objectForKey:@"total"];
                    modal.totalProfit=[dic objectForKey:@"totalProfit"];
                    modal.year=[dic objectForKey:@"year"];
                    [self.modalArr addObject:modal];
                    
                    
                    
                }
                [self.table footerEndRefreshing];
                
                [self.table reloadData];
                
            }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
            {
                 [[NoticeTool notice]expireNoticeOnController:self];
            }
        }];

    }];
}

//设置组尾距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0;
}


//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight+10;
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
    if (self.modalArr.count!=0) {
        NSLog(@"-----%lu",(unsigned long)self.modalArr.count);
        return self.modalArr.count;
    }
    return 0;
    
}

//设置区域的名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSLog(@"--------- %@",self.arr);
    if (self.arr.count==0) {
        return 0;
    }
    return header;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
//
//    view.backgroundColor = [UIColor redColor];
//    
//    view.frame = CGRectMake(0, 0, 300, 20);
//    
//    return view;
    
    
    
    
    
    if (self.arr.count==0) {
        view.frame=CGRectMake(0, 0, screenWidth, 0);
        return view;
        
    }else
    { view.frame=CGRectMake(0, 0, screenWidth, header);
        
        //        view.backgroundColor = RGB(255,255,255,1.0f);
        view.backgroundColor=[UIColor redColor];
        MoneyMoreView*more=[[MoneyMoreView alloc]initWithFrame:view.frame];
        [view addSubview:more];

        return view;

    }

    
    
}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//  
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, footer)];
//    view.backgroundColor = RGB(238,238,238,1.0f);
//
//    return view;
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark "显示cell"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return  [MoneyMoreCell moreTableViewCellWith:tableView indexPath:indexPath imgNameStrArr:self.modalArr labelNameArr:monthArr];
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
