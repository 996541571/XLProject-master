//
//  MineController.m
//  XXProjectNew
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define footer 0.016*screenHeight
#define firstCellHeight 0.245*screenHeight
#define secondOrForth 0.078*screenHeight
#define third 0.14*screenHeight
#define fifth 0.089*screenHeight
#import "MineController.h"
#import "StartUpLoginVC.h"
#import "AboutXLViewController.h"

//appgw-test

#import "MyCell.h"


@interface MineController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray* headeImageArr;
    NSMutableArray* headeLabNameArr;
    NSMutableArray*headeImageArr1;
    NSMutableArray* headeLabNameArr1;
    NSMutableArray*transferImageArr;

    NSMutableArray*transferNameArr;
    BOOL isFirst;
    UILabel*label;

}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MineController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = true;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [NetRequest searchStationInfo:^(NSDictionary *responseDicionary, NSError *error) {
//        NSLog(@"sesarchStation===%@",responseDicionary);
//    }];
    isFirst=YES;
    [NetRequest whetherCountExist:^(NSDictionary *responseDicionary, NSError *error) {
        NSLog(@"whetherCountExist===%@",responseDicionary);
        isFirst=NO;
        if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000) {
            [headeImageArr removeAllObjects];
            [headeLabNameArr removeAllObjects];
//            headeImageArr=[[NSMutableArray alloc]initWithObjects:@"station",@"receive",@"calculateImage", nil];
            [headeImageArr addObject:@"station"];
            [headeImageArr addObject:@"receive"];
            [headeImageArr addObject:@"calculateImage"];

           // headeLabNameArr=[[NSMutableArray alloc]initWithObjects:@"站长个人信息",@"收款账户",@"赚钱计算器", nil];
            [headeLabNameArr addObject:@"站长个人信息"];
            [headeLabNameArr addObject:@"收款账户"];
            [headeLabNameArr addObject:@"赚钱计算器"];


            

            
            [self.table reloadData];

            
        }
       

    }];
    self.table.delegate=self;
    self.table.dataSource=self;
    headeImageArr=[[NSMutableArray alloc]initWithObjects:@"station" ,@"calculateImage",nil];
    headeLabNameArr=[[NSMutableArray alloc]initWithObjects:@"站长个人信息" ,@"赚钱计算器",nil];

    
    headeImageArr1=[[NSMutableArray alloc]initWithObjects:@"search",@"connectManager", nil];
    headeLabNameArr1=[[NSMutableArray alloc]initWithObjects:@"调查问卷",@"联系客服经理", nil];
    transferImageArr=[[NSMutableArray alloc]init];
    transferNameArr=[[NSMutableArray alloc]init];
    //    self.table.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.table.backgroundColor=RGB(233,233,233,1.0f);

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==4) {
        return fifth;
    }
    if (indexPath.section==0) {
        return firstCellHeight;
    }else if(indexPath.section==2)
    {
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            return third + 10;
        }
        return third;
     }else
     {
         return secondOrForth;
     }
}

//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}
//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return headeImageArr.count;
    }else if(section==3)
    {
//        return headeImageArr1.count;
        return 1;
    }
    
    return 1;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3) {
        return footer*2;
    }else if (section == 4){
        return 0.01;
    }
    return footer;
   
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame=CGRectMake(0, 0, screenWidth, footer);
    
    view.backgroundColor = RGB(233,233,233,1.0f);
    
    
    return view;
    
    
}


#pragma mark "响应事件"
//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0||indexPath.section==4) {
        return;
    }
    WYWebController*first=[WYWebController new];
    NSDictionary*loginInfodic =[XLPlist getPlistDicByAppendPlistRoute:proactiveLogin];
    if (indexPath.section==1) {
        if (headeImageArr.count==3) {
            if (indexPath.row==0) {
                [MobClick event:@"um_mine_page_manager_info_click_event"];
                NSString*partyStr=[NSString stringWithFormat:@"%@",[loginInfodic objectForKey:@"nodeManagerPartyId"]];
                
                NSLog(@"-----%@",[NSString stringWithFormat:@"%@/home/nodeManager/personaInfo.html?partyId=%@",ENV_H5_URL,partyStr ]);
                first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/personaInfo.html?partyId=%@",ENV_H5_URL,partyStr ];
                first.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:first animated:YES];
                
            }else if(indexPath.row==1)
            {
                [MobClick event:@"um_mine_page_payment_account_click_event"];
//                first.urlstr=[NSString stringWithFormat:@"https://h5cau-dev.xianglin.cn/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%ld",[[loginInfodic objectForKey:@"mobilePhone"]integerValue]];
                NSLog(@"shoukuan===%@",[NSString stringWithFormat:@"https://h5cau-test.xianglin.cn/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",[loginInfodic objectForKey:@"mobilePhone"]]);
            first.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
                NSLog(@"---account---%@",first.urlstr);
                first.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:first animated:YES];

                
            }else
            {
                [MobClick event:@"um_mine_page_earnings_calculate_entrance_click_event"];
                CalculateController*cal=[CalculateController new];
                cal.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:cal animated:YES];
            }

            
        }else if (headeImageArr.count==2)
        {
            if (indexPath.row==0) {
                [MobClick event:@"um_mine_page_manager_info_click_event"];
                NSString*partyStr=[NSString stringWithFormat:@"%@",[loginInfodic objectForKey:@"nodePartyId"]];
                
                
                first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/personaInfo.html?partyId=%d",ENV_H5_URL,[partyStr intValue]];
                first.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:first animated:YES];

                
            }else
            {
                [MobClick event:@"um_mine_page_earnings_calculate_entrance_click_event"];
                CalculateController*cal=[CalculateController new];
                cal.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:cal animated:YES];
                
            }
        }
        

       
        
    }else if (indexPath.section==2)
    {
        [MobClick event:@"um_mine_page_business_manage_click_event"];
        NSString*partyStr=[NSString stringWithFormat:@"%@",[loginInfodic objectForKey:@"nodePartyId"]];
        
        first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/management.html?nodePartyId=%@",ENV_H5_URL,partyStr];
        first.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:first animated:YES];

    }else
    {
        
//        if (indexPath.row==0) {
//            [MobClick event:@"um_mine_page_questionnaire_click_event"];
//            NSLog(@"000===%@",[NSString stringWithFormat:@"%@/home/nodeManager/questions.html",ENV_H5_URL]);
//            first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/questions.html",ENV_H5_URL];
//            first.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:first animated:YES];
//
//            
//        }else if (indexPath.row==1)
//        {
//            [MobClick event:@"um_mine_page_contact_manager_click_event"];
//            NSLog(@"-------%@====",[NSString stringWithFormat:@"%@/home/nodeManager/contactManager.html",ENV_H5_URL]);
//            first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/contactManager.html",ENV_H5_URL];
//            first.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:first animated:YES];
//
//            
//            
//        }
        
        
        
        AboutXLViewController* vc = [AboutXLViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:true];
        
        vc.MineViewController_transferImageArr = headeImageArr1;
        vc.MineViewController_transferNameArr = headeLabNameArr1;
        
        self.navigationController.navigationBarHidden = NO;
        
        
        
        
    }


}

#pragma mark "显示cell"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1)
    {
        transferImageArr= headeImageArr;
            transferNameArr=headeLabNameArr;
        
    }
    if (indexPath.section==3)
    {
       transferImageArr= headeImageArr1;
       transferNameArr= headeLabNameArr1;
    }
    
    MyCell*cell=[MyCell myTableViewCellWith:tableView indexPath:indexPath imgNameStrArr:transferImageArr labelNameArr:transferNameArr];
    
    if (indexPath.section==1) {
        NSLog(@"---insecton==%ld===inrow==%ld",(long)indexPath.section,(long)indexPath.row);
        UIImageView*imgView= (UIImageView*)[cell viewWithTag:9001];
        imgView.image=[UIImage imageNamed:transferImageArr[indexPath.row]];
        NSLog(@"---section1-imageName=====%@",transferNameArr[indexPath.row]);
        UILabel*contentLab= (UILabel*)[cell viewWithTag:9002];
        contentLab.text=transferNameArr[indexPath.row];
    }
    if (indexPath.section==2&&isFirst) {
//        UIImageView*imgView= (UIImageView*)[cell viewWithTag:4500];
        [label removeFromSuperview];
        label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:14];
        label.text=@"查看零余额卡、休眠卡、银行未统计卡、即将到期业务提醒、交易记录等";
        label.numberOfLines=0;
        label.textColor=RGB(170, 170, 170, 1);
        label.lineBreakMode=NSLineBreakByWordWrapping;
        //        label.textAlignment=NSTextAlignmentCenter;
//        CGSize size=CGSizeMake(0.89*screenWidth, 4);
//        CGSize expectSize=[label sizeThatFits:size];
        //        label.textColor=RGB(47, 150, 255, 1);
        label.frame=CGRectMake(0.1*screenWidth, 0.5*third, 0.89*screenWidth, 0.45*third);
         CGRect txtFrame = label.frame;
        txtFrame.size.height =[label.text boundingRectWithSize:
                               CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil].size.height;
        label.frame = CGRectMake(0.05*screenWidth, 0.5*third, 0.89*screenWidth, txtFrame.size.height);
        [cell addSubview:label];
        
        
    }
    if (indexPath.section==3)
    {
//        NSLog(@"---insecton==%ld===inrow==%ld",(long)indexPath.section,(long)indexPath.row);
        UIImageView*imgView= (UIImageView*)[cell viewWithTag:9003];
//        imgView.image=[UIImage imageNamed:transferImageArr[indexPath.row]];
        UILabel*contentLab= (UILabel*)[cell viewWithTag:9004];
//        contentLab.text=transferNameArr[indexPath.row];
//        NSLog(@"---section3-imageName=====%@",transferImageArr[indexPath.row]);
        
        contentLab.text = @"关于乡邻";
        imgView.image=[UIImage imageNamed:@"aboutXL"];

        
    }

    if (indexPath.section==4) {
        UIButton*quitBtn=(UIButton*)([cell viewWithTag:9005]);
        [quitBtn addTarget:self action:@selector(quitPress) forControlEvents:UIControlEventTouchUpInside];
        
    }
        return   cell;
    
    
}
-(void)quitPress
{
    UIAlertView *alview = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alview show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [NetRequest quitLogin:^(NSDictionary *responseDicionary, NSError *error) {
            NSLog(@"quitDic=======%@",responseDicionary);
            if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==1000) {
                [XLPlist deletePlistByPlistRoute:proactiveLogin ];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cookie"];
//                UIViewController *start;
//                if ([[NSUserDefaults standardUserDefaults] boolForKey:isNumberLogin]) {
//                    start=[[StartUpLoginVC alloc]init];
//                } else {
                   PhoneNumLoginVC *start=[[PhoneNumLoginVC alloc]init];
//                }
                
                NSLog(@"-----quit-----");
                [self presentViewController:start animated:NO completion:nil];
                [MobClick event:@"um_logout_page_sure_event"];
            }
        }];
    }
}





@end
