//
//  BankMoreController.m
//  XXProjectNew
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define firstCellHeight   0.125*screenHeight
#define otherCellHeight 0.078*screenHeight

#import "BankMoreController.h"
#import "BankMoreCell.h"
#import "CalculateController.h"



@interface BankMoreController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* headeImageArr;
    NSMutableArray* headeLabNameArr;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,retain)NSMutableArray*busiVisisDtoArr;
@property(nonatomic,retain)NSMutableArray*businessDtoListArr;
@property(nonatomic,retain)UILabel*myAlertLabel;


@end

@implementation BankMoreController
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView.backgroundColor=RGB(246, 246, 246, 1);
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.backgroundColor=RGB(238,238,238,1.0f);

  self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    headeImageArr=[NSMutableArray arrayWithCapacity:0];
    headeLabNameArr=[NSMutableArray arrayWithCapacity:0];
    self.busiVisisDtoArr=[NSMutableArray arrayWithCapacity:0];
    self.businessDtoListArr=[NSMutableArray arrayWithCapacity:0];
    [NetRequest earnMoneyPage:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"earnPage====%@",responseDicionary);
        
        
        
        
        
        if (([responseDicionary objectForKey:@"resultStatus"]!=nil)&&[[responseDicionary objectForKey:@"resultStatus"]intValue]==1000) {
           
            //收益明细(第二部分)
            //收益明细(圆值第二部分)
                      //收益明细（圆）右边开通哪些业务
            NSArray*businessDtoListArr=[[responseDicionary objectForKey:@"result"]objectForKey:@"businessDtoList"];
            if (businessDtoListArr.count!=0) {
                for (NSDictionary*dic in businessDtoListArr) {
                    //判断圆右边业务有无开通，哪些开通了
                    
                    if ([[dic objectForKey:@"businessType" ] isEqualToString:@"ESHOP"]||[[dic objectForKey:@"businessType" ] isEqualToString:@"LOAN"]||[[dic objectForKey:@"businessType" ] isEqualToString:@"BANK"]||[[dic objectForKey:@"businessType" ] isEqualToString:@"MOBILERECHARGE"]) {
                        BusinessDtoListModal*listModal=[BusinessDtoListModal new];
                        
                        listModal.businessType=[dic objectForKey:@"businessType"];
                        if ([listModal.businessType isEqualToString:@"BANK"]) {
                            listModal.name=@"银行业务";
                        }else if ([listModal.businessType isEqualToString:@"ESHOP"])
                        {
                            listModal.name=@"电商业务";
                            
                        }else if ([listModal.businessType isEqualToString:@"LOAN"])
                        {
                            listModal.name=@"借款业务";
                            
                        }else
                        {
                            listModal.name=@"充值缴费";
                            
                        }
                        listModal.businessStatus=[dic objectForKey:@"businessStatus"];
                        listModal.h5url=[dic objectForKey:@"h5url"];
                        [self.businessDtoListArr addObject:listModal];
                        
                        
                    }
                    
                    
                }
                NSLog(@"----count==%lu",(unsigned long)self.businessDtoListArr.count);
                
            }
            
            
            
            
            //跳转visit部分
           
            if ([[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"bankManagerUrl"]) {

                [self.busiVisisDtoArr addObject:[[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"bankManagerUrl"]];
                [headeLabNameArr addObject:@"银行业务"];
                [headeImageArr addObject:@"moneyBank"];
                
                
            }
            if (![[[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"eshopManagerUrl"]isEqualToString:@""]) {
                
                [self.busiVisisDtoArr addObject:[[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"eshopManagerUrl"]];
                [headeLabNameArr addObject:@"电商业务"];
                [headeImageArr addObject:@"moneyBusiness"];
                
            }
            if (![[[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"lifeMangerUrl"]isEqualToString:@""]) {
                
                [self.busiVisisDtoArr addObject:[[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"lifeMangerUrl"]];
                [headeLabNameArr addObject:@"充值缴费"];
                [headeImageArr addObject:@"moneyCharge"];
                
            }
            if (![[[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"loanManagerUrl"]isEqualToString:@""]) {
                [self.busiVisisDtoArr addObject:[[[responseDicionary objectForKey:@"result"]objectForKey:@"busiVisisDto"]objectForKey:@"loanManagerUrl"]];
                [headeLabNameArr addObject:@"借款业务"];
                [headeImageArr addObject:@"moneyDebt"];
                
            }
            
            
            
            
            
            
            [self.table reloadData];
            
            
        }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
        {
            [[XLPlist sharePlist]deletePlistByPlistRoute:proactiveLogin ];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
            [[NSUserDefaults standardUserDefaults]synchronize];
//            UIViewController *start;
//            if ([[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
//                 start=[[StartUpLoginVC alloc]init];
//            } else {
              LoginController *start=[[LoginController alloc]init];
//            }
            
            NSLog(@"-----quit-----");
            //            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:start];
            //            nav.navigationBarHidden=YES;
            [self presentViewController:start animated:NO completion:^{
                self.myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake((screenWidth-150)/2, screenHeight-49-60, 150, 30)];  //起始高度设的大点
                self.myAlertLabel.text=@"会话过期，请重新登录";
                self.myAlertLabel.layer.cornerRadius=6;
                self.myAlertLabel.layer.masksToBounds = YES;
                
                
                self.myAlertLabel.font=[UIFont systemFontOfSize:14];
                self.myAlertLabel.textAlignment=NSTextAlignmentCenter;
                [start.view addSubview:self.myAlertLabel];
                self.myAlertLabel.textColor=[UIColor whiteColor];
                self.myAlertLabel.backgroundColor=[UIColor blackColor];
                [UIView animateWithDuration:1  //动画时间
                                      delay:3  //开始延迟时间
                                    options: UIViewAnimationCurveEaseOut  //弹入弹出
                                 animations:^{
                                     //                             self.myAlertLabel.frame = CGRectMake(100, self.view.frame.size.height, 200, 15);  //终止高度设的小于起始高度
                                     self.myAlertLabel.alpha=0;
                                     
                                     
                                 }
                                 completion:^(BOOL finished){
                                     if (finished)
                                         [self.myAlertLabel removeFromSuperview];  //移动后隐藏
                                 }];
                
                
                
                
            }];
            
            

            
            
            
        }else
        {
            
        }
        
        
        
        
        
    }];

    // Do any additional setup after loading the view from its nib.
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return firstCellHeight;
    }
    return otherCellHeight;
}
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}
//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    
    return headeImageArr.count;
    
}



//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   if(indexPath.section==1)
    {
        NSString*str=headeLabNameArr[indexPath.row];
        NSDictionary*proactiveLoginDic=      [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
        NSNumber*partyID=[proactiveLoginDic objectForKey:@"nodePartyId"];
        NSString*partyIDStr=[NSString stringWithFormat:@"%@",partyID];
        
        WYWebController*first=[WYWebController new];
        for (BusinessDtoListModal*modal in _businessDtoListArr) {
            if ([str isEqualToString:modal.name]) {
                NSLog(@"modal.businessStatus===%@",modal.businessStatus);
                if ([modal.businessStatus isEqualToString:@"OPENING"]||[modal.businessStatus isEqualToString:@"SIGNED"]) {
                    if ([str isEqualToString:@"银行业务"]) {
                        [MobClick event:@"um_yeji_more_page_bank_click_event"];
                    }else if ([str isEqualToString:@"电商业务"]){
                        [MobClick event:@"um_yeji_more_page_electricity_click_event"];
                    }else if ([str isEqualToString:@"充值缴费"]){
                        [MobClick event:@"um_yeji_more_page_czjf_click_event"];
                    }else if ([str isEqualToString:@"借款业务"]){
                        [MobClick event:@"um_yeji_more_page_loan_click_event"];
                    }
                    first.urlstr=[NSString stringWithFormat:@"%@?nodePartyId=%@",_busiVisisDtoArr[indexPath.row],partyIDStr];
                    first.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:first animated:YES];
                    
                }else
                {
                    self.myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-75, screenHeight/2-20, 150, 40)];  //起始高度设的大点
                    self.myAlertLabel.text=@"此业务尚未开通";
                    self.myAlertLabel.layer.cornerRadius=6;
                    self.myAlertLabel.layer.masksToBounds = YES;
                    
                    
                    self.myAlertLabel.font=[UIFont systemFontOfSize:14];
                    self.myAlertLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:self.myAlertLabel];
                    self.myAlertLabel.textColor=[UIColor whiteColor];
                    self.myAlertLabel.backgroundColor=[UIColor blackColor];
                    [UIView animateWithDuration:1  //动画时间
                                          delay:1  //开始延迟时间
                                        options: UIViewAnimationCurveEaseOut  //弹入弹出
                                     animations:^{
                                         //                             self.myAlertLabel.frame = CGRectMake(100, self.view.frame.size.height, 200, 15);  //终止高度设的小于起始高度
                                         self.myAlertLabel.alpha=0;
                                         
                                         
                                     }
                                     completion:^(BOOL finished){
                                         if (finished)
                                             [self.myAlertLabel removeFromSuperview];  //移动后隐藏
                                     }];
                    
                    
                }
            }
        }
        
        
    }
   
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
  BankMoreCell*cell=     [BankMoreCell bankMoreTableViewCellWith:tableView indexPath:indexPath nameArr:nil imageArr:nil];
    UIButton*calculateBtn=(UIButton*)[cell viewWithTag:1232];
        [calculateBtn addTarget:self action:@selector(calcuClick) forControlEvents:UIControlEventTouchUpInside];

        return   cell;

        
    }else
    {
        
         return   [BankMoreCell bankMoreTableViewCellWith:tableView indexPath:indexPath nameArr:headeLabNameArr imageArr:headeImageArr];
        
    }
    
    
    
}
-(void)calcuClick
{
    [MobClick event:@"um_yeji_more_page_earnings_calculate_entrance_click_event"];
    CalculateController*cal=[CalculateController new];
    cal.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:cal animated:YES];
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
