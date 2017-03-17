//
//  RankController.m
//  XXProjectNew
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define headerHeight 0.109*screenHeight
#define cellHeight       0.09375*screenHeight

#import "RankController.h"
#import "RankHeaderView.h"
#import "RankCell.h"



@interface RankController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*headerNameArr;
    NSMutableArray*headerImageArr;
    NSMutableArray*cellImageArr;
    NSMutableArray*cellLabNameArr;
    NSMutableArray*cellRankArr;
    
    NSMutableArray*secondCellImageArr;
    NSMutableArray*secondCellLabNameArr;
    NSMutableArray*secondcellRankArr;
    
    NSMutableArray*cellUrlArr;
    NSMutableArray*secondCellUrlArr;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *backPress;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation RankController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [NetRequest yejiAndBenefitRank:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"rank====%@",responseDicionary);
    if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"totalProfitUrl"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"totalProfitUrl"]isEqualToString:@""]) {
            [cellImageArr addObject:@"totalMoneyList"];
            [cellLabNameArr addObject:@"总收益榜单"];
        [cellUrlArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"totalProfitUrl"]];
         if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"totalProfitRank"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"totalProfitRank"]isEqualToString:@""])
         {
             [cellRankArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"totalProfitRank"]];
         }
    }
        if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankProfitTopUrl"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankProfitTopUrl"]isEqualToString:@""]) {
            [cellImageArr addObject:@"moneyBank"];
            [cellLabNameArr addObject:@"银行收益榜单(省内)"];
            [cellUrlArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankProfitTopUrl"]];

            if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankProfitTopRank"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankProfitTopRank"]isEqualToString:@""])
            
            {
                [cellRankArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankProfitTopRank"]];
//                [cellRankArr addObject:@"123"];
            }

        }
        if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"lifePayProfitUrl"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"lifePayProfitUrl"]isEqualToString:@""]) {
            [cellImageArr addObject:@"moneyBusiness"];
            [cellLabNameArr addObject:@"电商&充值收益榜单"];
            [cellUrlArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"lifePayProfitUrl"]];

            if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"lifePayProfitRank"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"lifePayProfitRank"]isEqualToString:@""])
            {
                [cellRankArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"lifePayProfitRank"]];
            }

        }
        NSLog(@"cellRankArr====%@",cellRankArr);
        //second
        if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankPerformanceUrl"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankPerformanceUrl"]isEqualToString:@""]) {
            [secondCellImageArr addObject:@"list"];
            [secondCellLabNameArr addObject:@"业绩榜单"];
            [secondCellUrlArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankPerformanceUrl"]];
            if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankPerformanceRank"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankPerformanceRank"]isEqualToString:@""])
//            if (![[responseDicionary objectForKey:@"result" ]objectForKey:@"bankPerformanceRank"])
            {
                [secondcellRankArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankPerformanceRank"]];
//                [secondcellRankArr addObject:@"123457666"];

            }else
            {
                [secondcellRankArr addObject:@""];

            }

        }
        if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankBalanceUrl"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankBalanceUrl"]isEqualToString:@""]) {
            [secondCellImageArr addObject:@"balance"];
            [secondCellLabNameArr addObject:@"存款余额排名"];
            [secondCellUrlArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankBalanceUrl"]];

            if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankBalanceRank"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankBalanceRank"]isEqualToString:@""])
            {
                [secondcellRankArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankBalanceRank"]];
            }else
            {
                [secondcellRankArr addObject:@""];
            }

        }
        if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankIncrBalanceUrl"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankIncrBalanceUrl"]isEqualToString:@""]) {
            [secondCellImageArr addObject:@"add"];
            [secondCellLabNameArr addObject:@"存款增量余额排名"];
            [secondCellUrlArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankIncrBalanceUrl"]];

            if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankIncrBalanceRank"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankIncrBalanceRank"]isEqualToString:@""])
            {
                [secondcellRankArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankIncrBalanceRank"]];
            }else
            {
                [secondcellRankArr addObject:@""];

            }

        }
        if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankCardNumUrl"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankCardNumUrl"]isEqualToString:@""]) {
            [secondCellImageArr addObject:@"cardRank"];
            [secondCellLabNameArr addObject:@"银行卡排名"];
            [secondCellUrlArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankCardNumUrl"]];

            if ([[responseDicionary objectForKey:@"result" ]objectForKey:@"bankCardNumRank"]&&![[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankCardNumRank"]isEqualToString:@""])
            {
                [secondcellRankArr addObject:[[responseDicionary objectForKey:@"result" ]objectForKey:@"bankCardNumRank"]];
            }else{
                [secondcellRankArr addObject:@""];

            }

        }


        [self.table reloadData];
        
    }];
    
    self.headerView.backgroundColor=RGB(246, 246, 246, 1);
    self.table.delegate=self;
    self.table.dataSource=self;
   
    self.table.separatorStyle=NO;
    
    headerImageArr=[NSMutableArray arrayWithObjects:@"redRain.jpg",@"rain.jpg", nil];

    headerNameArr=[NSMutableArray arrayWithObjects:@"收益排名",@"业绩排名", nil];
    

//    cellImageArr=[NSMutableArray arrayWithObjects:@"totalMoneyList",@"moneyBank",@"moneyBusiness", nil];
//    cellLabNameArr=[NSMutableArray arrayWithObjects:@"总收益榜单",@"银行收益榜单",@"电商&充值收益榜单", nil];
//    cellRankArr=[NSMutableArray arrayWithObjects:@"5月省内第5名",@"5月省内第5名",@"5月省内第一名", nil];
    cellImageArr=[NSMutableArray arrayWithCapacity:0];
    cellLabNameArr=[NSMutableArray arrayWithCapacity:0];
    cellRankArr=[NSMutableArray arrayWithCapacity:0];
//    secondCellImageArr=[NSMutableArray arrayWithObjects:@"list",@"balance",@"add",@"cardRank", nil];
//    secondCellLabNameArr=[NSMutableArray arrayWithObjects:@"业绩榜单",@"存款余额排名",@"存款增量余额排名",@"银行卡排名", nil];
//    secondcellRankArr=[NSMutableArray arrayWithObjects:@"5月省内第1名",@"5月省内第2名",@"5月省内第3名",@"5月省内第4名", nil];
    secondCellImageArr=[NSMutableArray arrayWithCapacity:0];
    secondCellLabNameArr=[NSMutableArray arrayWithCapacity:0];
    secondcellRankArr=[NSMutableArray arrayWithCapacity:0];
    
    cellUrlArr=[NSMutableArray arrayWithCapacity:0];
    secondCellUrlArr=[NSMutableArray arrayWithCapacity:0];

    
    

    // Do any additional setup after loading the view from its nib.
}

    
    
    
-(void)setupUI{
    
    self.table.backgroundColor = RGB(238, 238, 238, 1);
    
    self.table.tableHeaderView = [UIView new];
    
}



//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cellHeight;
    }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}
//设置每个区有多少行共有多少行

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        if (section==1) {
            return secondCellImageArr.count;
        }
        
        return cellImageArr.count;
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerHeight)];
    view.backgroundColor = RGB(255,255,255,1.0f);
    
    RankHeaderView*aView=[[RankHeaderView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerHeight) labelNameStr:headerNameArr[section] imageNameStr:headerImageArr[section] section:section];
    
        [view addSubview:aView];
    
    
    
    
    return view;
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    RankCell*cell =[RankCell rankTableViewCellWith:tableView indexPath:indexPath];
  
        if (indexPath.section==0) {
            if(cellLabNameArr.count!=0)
            {
                UIImageView*imgView=(UIImageView*)[cell viewWithTag:3001];
                imgView.image=[UIImage imageNamed:cellImageArr[indexPath.row]];
                NSLog(@"imageCenter===%@",NSStringFromCGPoint(imgView.center));
                
                UILabel*upLab= (UILabel*)[cell viewWithTag:3002];
                
                NSLog(@"1111%@",NSStringFromCGPoint(upLab.center));
                //            upLab.center=CGPointMake(upLab.center.x, cell.upLabCenterYContraint.constant);
                
                //            CGPoint point;
                //            point.x=upLab.center.x;
                //            point.y=imgView.center.y;
                //            upLab.center=point;
                //            NSLog(@"2222%@",NSStringFromCGPoint(upLab.center));
                //            upLab.bounds=CGRectMake(0, 0, upLab.frame.size.width, upLab.frame.size.height);
                NSLog(@"indexpath.row===%ld",(long)indexPath.row);
//                upLab.text=cellLabNameArr[indexPath.row];
//                upLab.textColor=RGB(102, 102, 102, 1);
                NSLog(@"center====%@",NSStringFromCGPoint(upLab.center));
                UILabel*middleLab= (UILabel*)[cell viewWithTag:3003];

                UILabel*downLab= (UILabel*)[cell viewWithTag:3004];
                //                        downLab.text=cellRankArr[indexPath.row];
                downLab.textColor=RGB(153, 153, 153, 1);
                if(cellRankArr.count==0)
                {   upLab.hidden=YES;
                    downLab.hidden=YES;
                    middleLab.hidden=NO;
                    middleLab.text=cellLabNameArr[indexPath.row];
                    middleLab.textColor=RGB(102, 102, 102, 1);

                    
                    
                }else
                {
                    
                    upLab.hidden=NO;
                    upLab.text=cellLabNameArr[indexPath.row];
                    upLab.textColor=RGB(102, 102, 102, 1);
                     middleLab.hidden=YES;
                    downLab.hidden=NO;
                    downLab.text=cellRankArr[indexPath.row];
                    
                }


                
            }

            
            
           


            
        

        
        
    }else {
        //没有设置4002的label
        if (secondCellLabNameArr.count!=0) {
            UIImageView*imgView=(UIImageView*)[cell viewWithTag:4000];
            imgView.image=[UIImage imageNamed:secondCellImageArr[indexPath.row]];
            UILabel*upLeftLab= (UILabel*)[cell viewWithTag:4001];
            upLeftLab.text=@"【银】";
            upLeftLab.textColor=RGB(47, 150, 255, 1);
            
            
            UILabel*upRightLab= (UILabel*)[cell viewWithTag:4002];
            upRightLab.textColor=RGB(102, 102, 102, 1);
            UILabel*middleLeftLab= (UILabel*)[cell viewWithTag:4003];
            middleLeftLab.text=@"【银】";

            middleLeftLab.textColor=RGB(47, 150, 255, 1);
            UILabel*middleRightLab= (UILabel*)[cell viewWithTag:4004];
            middleRightLab.textColor=RGB(102, 102, 102, 1);

            UILabel*downLab= (UILabel*)[cell viewWithTag:4005];
            downLab.textColor=RGB(153, 153, 153, 1);
            if (secondcellRankArr.count==0) {
                upLeftLab.hidden=YES;
                upRightLab.hidden=YES;
                downLab.hidden=YES;
                middleLeftLab.hidden=NO;
                middleRightLab.hidden=NO;
                middleRightLab.text=secondCellLabNameArr[indexPath.row];

               
                
                
            }else
            {
            
//                    middleLeftLab.hidden=YES;
//                    middleRightLab.hidden=YES;
//                    upLeftLab.hidden=NO;
//                    upRightLab.hidden=NO;
//                    downLab.hidden=NO;
//                    upRightLab.text=secondCellLabNameArr[indexPath.row];
//                    downLab.text=secondcellRankArr[indexPath.row];
                        if (![secondcellRankArr[indexPath.row] isEqualToString:@""]) {
                            middleLeftLab.hidden=YES;
                            middleRightLab.hidden=YES;
                            upLeftLab.hidden=NO;
                            upRightLab.hidden=NO;
                            downLab.hidden=NO;
                            upRightLab.text=secondCellLabNameArr[indexPath.row];
                            downLab.text=secondcellRankArr[indexPath.row];

                            
                            
                        }else
                        {
                            upLeftLab.hidden=YES;
                            upRightLab.hidden=YES;
                            downLab.hidden=YES;
                            middleLeftLab.hidden=NO;
                            middleRightLab.hidden=NO;
                            middleRightLab.text=secondCellLabNameArr[indexPath.row];
                            

                        }
                        
                    }
                    
                

                    
                
                

                
            }
            
        
        
       
        

        
    }
    return cell;

    
    


 }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*proactiveLoginDic=      [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    NSNumber*partyID=[proactiveLoginDic objectForKey:@"nodePartyId"];
    NSString*partyIDStr=[NSString stringWithFormat:@"%@",partyID];

    if (indexPath.section==0) {
        NSString *name = cellLabNameArr[indexPath.row];
        if ( [name isEqualToString:@"总收益榜单"]) {
            [MobClick event:@"um_top_page_earnings_total_click_event"];
        }else if ([name isEqualToString:@"银行收益榜单(省内)"]){
            [MobClick event:@"um_top_page_earnings_bank_click_event"];
        }else if ([name isEqualToString:@"电商&充值收益榜单"]){
            [MobClick event:@"um_top_page_earnings_ds_and_cz_click_event"];
        }
        WYWebController*first=[WYWebController new];
        
            NSLog(@"====%@",[NSString stringWithFormat:@"%@?nodePartyId=%@",cellUrlArr[indexPath.row],partyIDStr]);
            first.urlstr=[NSString stringWithFormat:@"%@?nodePartyId=%@",cellUrlArr[indexPath.row],partyIDStr];
            first.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:first animated:YES];
        
       }else
    {
        NSString *name = secondCellLabNameArr[indexPath.row];
        if ( [name isEqualToString:@"业绩榜单"]) {
            [MobClick event:@"um_top_page_business_bank_click_event"];
        }else if ([name isEqualToString:@"存款余额排名"]){
            [MobClick event:@"um_top_page_business_deposit_balance_click_event"];
        }else if ([name isEqualToString:@"存款增量余额排名"]){
            [MobClick event:@"um_top_page_business_deposit_incremental_balance_click_event"];
        }else if ([name isEqualToString:@"银行卡排名"]){
            [MobClick event:@"um_top_page_business_bank_card_click_event"];
        }
        WYWebController*first=[WYWebController new];
        
        NSLog(@"====%@",[NSString stringWithFormat:@"%@&nodePartyId=%@",secondCellUrlArr[indexPath.row],partyIDStr]);
        if ([secondCellUrlArr[indexPath.row] rangeOfString:@"?"].location == NSNotFound) {
                        NSLog(@"无？===%@",[NSString stringWithFormat:@"%@?nodePartyId=%@",secondCellUrlArr[indexPath.row],partyIDStr]);


            first.urlstr=[NSString stringWithFormat:@"%@?nodePartyId=%@",secondCellUrlArr[indexPath.row],partyIDStr];


        }else
        {
                       NSLog(@"有？===%@",[NSString stringWithFormat:@"%@&nodePartyId=%@",secondCellUrlArr[indexPath.row],partyIDStr]);

            first.urlstr=[NSString stringWithFormat:@"%@&nodePartyId=%@",secondCellUrlArr[indexPath.row],partyIDStr];



        }
        first.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:first animated:YES];
    }
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
