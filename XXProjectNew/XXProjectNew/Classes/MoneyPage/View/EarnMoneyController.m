//
//  EarnMoneyController.m
//  XXProjectNew
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 xianglin. All rights reserved.
//
#define headerHeight 0.015*screenHeight
#define fiestCellHeight 0.365*screenHeight
#define secondCellHeight 0.078*screenHeight
#define secondFirstNoDataHeight 0.312*screenHeight
#import "EarnMoneyController.h"
#import "CustomMoneyCell.h"
#import "RoundView.h"
#import "MoreMonthConroller.h"
#import "BusinessDtoListModal.h"
#import <QuartzCore/QuartzCore.h>
#import "NetRequest.h"




@interface EarnMoneyController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    NSMutableArray* headeImageArr;//存放业务明细图片
    NSMutableArray* headeLabNameArr;//存放业务明细标题
    RoundView*round;
    //圆youbian
    NSMutableArray*colorArr;
    NSMutableArray*nameArr;
    NSMutableArray*realDataArr;
    //最下面cell
    NSMutableArray*businessStatusArr;

    NSMutableArray*urlArr;
    BOOL isFirst;
    UILabel*secondCellNoDataLab;
    BOOL isSecondCellFirst;
    NSMutableArray *headNameArr;
    NSMutableArray *headImageArr;
//    int _count;
}
//@property (weak, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,retain)NSMutableArray*ProfitDtoArr;
@property(nonatomic,retain)NSMutableArray*busiVisisDtoArr;
//@property(nonatomic,retain)NSMutableArray*businessDtoListArr;
@property(nonatomic,retain)UILabel*myAlertLabel;
@property (nonatomic, getter=isPushing) BOOL pushing;
@property(nonatomic,strong)NSMutableArray* busi_urlArr;

@property(nonatomic,strong)NSDictionary* topLabel_Dic;
@property(nonatomic,strong)NSDictionary* topBtn_Dic;
//收益明细
@property(nonatomic,retain)NSMutableArray*profitDetailDtoArr;
@end

@implementation EarnMoneyController
-(void)removeRoundArrData
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"total"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"transferDataArr"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"labNameArr"];
    
}


-(void)setupUI{
    
    //
    
    if (self.isOther) {
        
        
        self.headerView.hidden = YES;
        
//        self.table_top.constant = -10;
        
        
        
    }
    
    
    
    
    UIView* headerview = [UIView new];
    
    headerview.backgroundColor = [UIColor whiteColor];
    
    headerview.frame = CGRectMake(0, 0, 0, 80);
    
    self.table.tableHeaderView = headerview;
    
    //setup headerview
    
    
#define btnWidth 30
#define btnHeight 30
    
    
//     _count = headNameArr.count;
    
    float xPlaceHolder = (screenWidth  - btnWidth*headNameArr.count)/(headNameArr.count+1);
//    NSArray* picArr = @[@"other_icon",@"mobile_icon",@"live_icon"];
//    NSArray* labNameArr = @[@"乡邻购",@"手机充值",@"水电煤"];
    CGFloat space = (headerview.bounds.size.height - btnHeight)/2;
    
    NSMutableDictionary* dic_label = [NSMutableDictionary dictionary];

    
    for (int i=0; i<headNameArr.count; i++) {
        
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        //计算frame
        //宽 = 左右边距 + 图标宽*数量+图标之间的间隙(数量+1)
        
        
        btn.frame=CGRectMake(xPlaceHolder+(btnWidth+xPlaceHolder)*i,space-10, btnWidth, btnHeight);
        
        [btn setBackgroundImage:[UIImage imageNamed:headImageArr[i]] forState:UIControlStateNormal];
        
        btn.tag= i ;
        
        [btn addTarget:self action:@selector(headerBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerview addSubview:btn];
        
        //label
        
        UILabel*label=[[UILabel alloc]init];
        
        label.text=headNameArr[i];
        
        label.font=[UIFont systemFontOfSize:12.0];
        label.textAlignment=NSTextAlignmentCenter;
        
        CGPoint btnPoint=btn.center;
        label.bounds=CGRectMake(0, 0, 70, 14);
        
        //间距,最好和icon的上下间距一起改
        label.center=CGPointMake(btnPoint.x, btnPoint.y+btnHeight/2+10+5);
        
        label.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerLabDidClick:)];
        
        label.tag = btn.tag;
        
        [label addGestureRecognizer:singleTapGestureRecognizer];

        
        
        
        
        label.textColor=RGB(102, 102, 102, 1);
        
        [headerview addSubview:label];
        
        
        
//        [dic_label setValue:label forKey:headNameArr[i]];
        
        [dic_label setObject:label forKey:headNameArr[i]];
        

        
        
        //添加分割线
        
      UIView  *separate_line = [UIView  new];
        
        [headerview addSubview:separate_line];
        
        separate_line.backgroundColor = [UIColor lightGrayColor];
        
        separate_line.hidden = NO;
        
        
        
        [separate_line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@0.5);
            
            make.bottom.equalTo(headerview);
            
            make.width.mas_equalTo(screenWidth);
            
            
            
        }];

        
        
        
        
        
        
    }
    
    self.topLabel_Dic = dic_label.copy;
    
    //back_btn
    
    
    
}


-(void)backToLastView{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



-(void)headerLabDidClick:(UITapGestureRecognizer*)tap{
    

    
    WYWebController*vc=[[WYWebController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    
    //清除缓存
//    [[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"] isEqualToString:@""];
    
//    vc.toDeleteCache = YES;

    
    
    [self.topLabel_Dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel* label, BOOL * _Nonnull stop) {
       
        //找出是点击的是字典里的哪个元素
        if (label.tag == tap.view.tag ) {
            
            if ([key  isEqualToString: @"乡邻购"]) {
                
                [MobClick event:@"um_other_business_page_top_shop_click_event"];
                
            }else if([key  isEqualToString: @"手机充值"]){
                
                [MobClick event:@"um_other_business_page_top_mobile_click_event"];
                
            }else if ([key  isEqualToString: @"水电煤"]){
                
                [MobClick event:@"um_other_business_page_top_life_click_event"];
                
            }
            
        }
        
    }];
    
    vc.urlstr = self.busi_urlArr[tap.view.tag];
    
    [self.navigationController pushViewController:vc animated:nil];
}


-(void)headerBtnDidClick:(UIButton*)btn{
    
    #pragma mark headerBtn 入口
    
    WYWebController*vc=[[WYWebController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;

    //清除缓存
//    [[[NSUserDefaults standardUserDefaults]objectForKey:@"cookie"] isEqualToString:@""];
//
//    vc.toDeleteCache = YES;
    
    [self.topLabel_Dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel* label, BOOL * _Nonnull stop) {
        
        //找出是点击的是字典里的哪个元素
        NSLog(@"%td,%td,%td",label.tag,btn.tag,self.topLabel_Dic.count);
        
        if (label.tag == btn.tag ) {
            
            if ([key  isEqualToString: @"乡邻购"]) {
                [MobClick event:@"um_other_business_page_top_shop_click_event"];
                WKWebVC *web = [[WKWebVC alloc]init];
                web.urlstr = self.busi_urlArr[btn.tag];
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
                return ;
            }else if([key  isEqualToString: @"手机充值"]){
                
                [MobClick event:@"um_other_business_page_top_mobile_click_event"];
                
            }else if ([key  isEqualToString: @"水电煤"]){
                
                [MobClick event:@"um_other_business_page_top_life_click_event"];
                
            }
            
        }
        
    }];
    vc.urlstr = self.busi_urlArr[btn.tag];
    [self.navigationController pushViewController:vc animated:nil];
}



-(void)viewWillDisappear:(BOOL)animated{
    
    if (self.isOther) {
        
        self.navigationController.navigationBarHidden = YES;
    }

    
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    if (self.isOther) {
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
        
        imgView.userInteractionEnabled = true;
        
        imgView.image = [UIImage imageNamed:@"back"];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
        
        [imgView addGestureRecognizer:singleTapGestureRecognizer];
        

        self.navigationController.navigationBarHidden = NO;
        self.bottom_constraints.constant = 0 ;
        
        
        self.title = @"赚钱";
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"total"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"transferDataArr"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"labNameArr"];
    
    
    isFirst=YES;
    isSecondCellFirst=YES;
    headNameArr = [NSMutableArray arrayWithCapacity:0];
    headImageArr = [NSMutableArray arrayWithCapacity:0];
    self.ProfitDtoArr=[NSMutableArray arrayWithCapacity:0];
    self.profitDetailDtoArr=[NSMutableArray arrayWithCapacity:0];
    self.busiVisisDtoArr=[NSMutableArray arrayWithCapacity:0];
    //    self.businessDtoListArr=[NSMutableArray arrayWithCapacity:0];
    businessStatusArr=[NSMutableArray arrayWithCapacity:0];
    colorArr=[NSMutableArray arrayWithCapacity:0];
    nameArr=[NSMutableArray arrayWithCapacity:0];
    urlArr=[NSMutableArray arrayWithCapacity:0];
    realDataArr=[NSMutableArray arrayWithCapacity:0];
    [self addEarnMoneyData];
    
    

    headeImageArr=[[NSMutableArray alloc]init];
    headeLabNameArr=[[NSMutableArray alloc]init];
    
    
    
    
    self.headerView.backgroundColor=RGB(246, 246, 246, 1);
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=NO;
    self.table.backgroundColor=RGB(233,233,233,1.0f);
    // Do any additional setup after loading the view from its nib.
    [self.table addHeaderWithCallback:^{
        [self addEarnMoneyData];
       
    }];
}
-(void)addEarnMoneyData
{
    headNameArr = [NSMutableArray arrayWithCapacity:0];
    headImageArr = [NSMutableArray arrayWithCapacity:0];
    self.ProfitDtoArr=[NSMutableArray arrayWithCapacity:0];
    self.profitDetailDtoArr=[NSMutableArray arrayWithCapacity:0];
    self.busiVisisDtoArr=[NSMutableArray arrayWithCapacity:0];
    //    self.businessDtoListArr=[NSMutableArray arrayWithCapacity:0];
    businessStatusArr=[NSMutableArray arrayWithCapacity:0];
    colorArr=[NSMutableArray arrayWithCapacity:0];
    nameArr=[NSMutableArray arrayWithCapacity:0];
    urlArr=[NSMutableArray arrayWithCapacity:0];
    realDataArr=[NSMutableArray arrayWithCapacity:0];
    headeImageArr=[[NSMutableArray alloc]init];
    headeLabNameArr=[[NSMutableArray alloc]init];
    [NetRequest earnMoneyPage:^(NSDictionary *responseDicionary, NSError *error) {
        isFirst=NO;
        NSLog(@"earnPage====%@",responseDicionary);
        [[NSUserDefaults standardUserDefaults]setObject:responseDicionary forKey:earnMoneyDataKey];

        if (([responseDicionary objectForKey:@"result"]!=nil)&&[[responseDicionary objectForKey:@"resultStatus"]intValue]==1000) {
            ProfitDtoModal*modal=[ProfitDtoModal new];
            
            //第一部分
            if ([[responseDicionary objectForKey:@"result"]objectForKey:@"profitDto"]) {
                NSString *currentTotal = [NSString stringWithFormat:@"%@",[[[responseDicionary objectForKey:@"result"]objectForKey:@"profitDto"]objectForKey:@"currentTotal"]];
                currentTotal = [self resetString:currentTotal];
                modal.currentTotal= currentTotal;
                modal.dataPeriod=[[[responseDicionary objectForKey:@"result"]objectForKey:@"profitDto"]objectForKey:@"dataPeriod"];
                modal.year=[modal.dataPeriod substringWithRange:NSMakeRange(2, 2)];
                modal.month=    [modal.dataPeriod substringFromIndex:4];
                if ([[modal.month substringWithRange:NSMakeRange(0, 1)]intValue]==0) {
                    modal.month=[modal.month substringWithRange:NSMakeRange(1, 1)];
                    NSLog(@"前一位是0，month===%@",modal.month);
                    
                    
                }
                NSLog(@"modal.dataPeriod===%@",modal.dataPeriod);
                modal.staticType=[[[responseDicionary objectForKey:@"result"]objectForKey:@"profitDto"]objectForKey:@"staticType"];
                
                
                NSString *total = [NSString stringWithFormat:@"%@",[[[responseDicionary objectForKey:@"result"]objectForKey:@"profitDto"]objectForKey:@"total"]];
                total = [self resetString:total];
                modal.total=total;
            }else
            {
                modal.month=@"";
                modal.currentTotal=@"暂无数据";
                modal.total=@"暂无数据";
                
            }
            [_ProfitDtoArr addObject:modal];

            
            //收益明细(第二部分)
            //收益明细（圆）右边开通哪些业务
            
            NSMutableArray* arr = [NSMutableArray array];
            NSDictionary *result = responseDicionary[@"result"];
            
            NSArray*businessDtoListArr=[[responseDicionary objectForKey:@"result"]objectForKey:@"businessDtoList"];
            
             NSDictionary*profitDetailDtoDic=[[responseDicionary objectForKey:@"result"]objectForKey:@"profitDetailDto"];
            
            NSDictionary *busiVisisDto = result[@"busiVisisDto"];
            
            if (businessDtoListArr.count!=0) {
                
                for (NSDictionary*dic in businessDtoListArr) {
                    
                    if ([dic[@"businessType"] isEqualToString:@"ESHOP"] && ![dic[@"h5url"] isEqualToString:@""]) {
                        [headNameArr addObject:@"乡邻购"];
                        [headImageArr addObject:@"other_icon"];
                        [arr addObject:dic[@"h5url"]];
                    }
                    if ([[NSString stringWithFormat:@"%@",dic[@"businessType"]] isEqualToString:@"ESHOP"]&&![[NSString stringWithFormat:@"%@",busiVisisDto[@"eshopManagerUrl"]] isEqualToString:@""] && busiVisisDto[@"eshopManagerUrl"] !=nil &&([dic[@"businessStatus"] isEqualToString:@"SIGNED"]||[dic[@"businessStatus"] isEqualToString:@"OPENING"])) {
                        [headeLabNameArr addObject:@"电商业务"];
                        [headeImageArr addObject:@"other_icon"];
                        [urlArr addObject:[NSString stringWithFormat:@"%@",busiVisisDto[@"eshopManagerUrl"]]];
   
                        [businessStatusArr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessStatus"]]];
                    }
                    
                    if ([[NSString stringWithFormat:@"%@",dic[@"businessType"]] isEqualToString:@"ESHOP"]) {
                        
                        [colorArr addObject:RGB(255, 166, 165, 1)];
                        [nameArr addObject:@"电商"];
                        
                        if ([profitDetailDtoDic objectForKey:@"eshopProfit"]&& [profitDetailDtoDic.allKeys containsObject:@"eshopProfit"]) {
                            [realDataArr addObject:[self resetString:[NSString stringWithFormat:@"%@",[profitDetailDtoDic objectForKey:@"eshopProfit"]]]];
                        }else
                        {
                            [realDataArr addObject:@"0.00"];
                        }

                        
                    }
                    
                }
                for (NSDictionary *dic in businessDtoListArr){
                    if ([dic[@"businessType"]isEqualToString:@"MOBILERECHARGE"] && ([dic[@"businessStatus"] isEqualToString:@"OPENING"]||[dic[@"businessStatus"] isEqualToString:@"SIGNED"]) && ![dic[@"h5url"] isEqualToString:@""] && dic[@"h5url"] != nil) {
                        [headNameArr addObject:@"手机充值"];
                        [headImageArr addObject:@"moneyCharge"];
                        [arr addObject:dic[@"h5url"]];
                    }
                    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessType"]] isEqualToString:@"MOBILERECHARGE"]&&![[NSString stringWithFormat:@"%@",[[[responseDicionary objectForKey:@"result" ] objectForKey:@"busiVisisDto"] objectForKey:@"mobileChargeUrl"]]isEqualToString:@""] && [[responseDicionary[@"result"] objectForKey:@"busiVisisDto"] objectForKey:@"mobileChargeUrl"] !=nil &&([dic[@"businessStatus"] isEqualToString:@"SIGNED"]||[dic[@"businessStatus"] isEqualToString:@"OPENING"])) {
                        
                        [headeLabNameArr addObject:@"手机充值"];
                        [headeImageArr addObject:@"moneyCharge"];
                        [businessStatusArr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessStatus"]]];
                        [urlArr addObject:[NSString stringWithFormat:@"%@",[[[responseDicionary objectForKey:@"result" ] objectForKey:@"busiVisisDto" ] objectForKey:@"mobileChargeUrl"]]];
                        
                    }
                    
                    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessType"]] isEqualToString:@"MOBILERECHARGE"]) {
                        [colorArr addObject:RGB(255, 237, 184, 1)];
                        [nameArr addObject:@"话费"];
                        if ([profitDetailDtoDic objectForKey:@"mobileEchargeProfit"]&& [profitDetailDtoDic.allKeys containsObject:@"mobileEchargeProfit"]) {
                            [realDataArr addObject:[self resetString:[NSString stringWithFormat:@"%@",[profitDetailDtoDic objectForKey:@"mobileEchargeProfit"]]]];
                        }else
                        {
                            [realDataArr addObject:@"0.00"];
                        }
                    }

                }
                for (NSDictionary *dic in businessDtoListArr) {
                        if ([dic[@"businessType"]isEqualToString:@"LIVE"] && ([dic[@"businessStatus"] isEqualToString:@"OPENING"]||[dic[@"businessStatus"] isEqualToString:@"SIGNED"]) && ![dic[@"h5url"] isEqualToString:@""] && dic[@"h5url"] != nil) {
                            [headNameArr addObject:@"水电煤"];
                            [headImageArr addObject:@"lifeCharge"];
                            [arr addObject:dic[@"h5url"]];
                        }
                    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessType"]] isEqualToString:@"LIVE"]&&![[NSString stringWithFormat:@"%@",[[[responseDicionary objectForKey:@"result" ] objectForKey:@"busiVisisDto"] objectForKey:@"lifeMangerUrl"]]isEqualToString:@""] && [[responseDicionary[@"result"] objectForKey:@"busiVisisDto"] objectForKey:@"lifeMangerUrl"] !=nil&&([dic[@"businessStatus"] isEqualToString:@"SIGNED"]||[dic[@"businessStatus"] isEqualToString:@"OPENING"])) {
                        
                        [headeLabNameArr addObject:@"水电煤"];
                        [headeImageArr addObject:@"lifeCharge"];
                        [businessStatusArr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessStatus"]]];
                        [urlArr addObject:[NSString stringWithFormat:@"%@",[[[responseDicionary objectForKey:@"result" ] objectForKey:@"busiVisisDto" ] objectForKey:@"lifeMangerUrl"]]];
                        
                    }

            }
                self.busi_urlArr = [NSMutableArray arrayWithArray:arr];
        }
            
            if ([profitDetailDtoDic objectForKey:@"liveEchargeProfit"]&& [profitDetailDtoDic.allKeys containsObject:@"liveEchargeProfit"]) {
                [colorArr addObject:RGB(186, 244, 237, 1)];
                [nameArr addObject:@"水电煤"];
                [realDataArr addObject:[self resetString:[NSString stringWithFormat:@"%@",[profitDetailDtoDic objectForKey:@"liveEchargeProfit"]]]];
            }
            //收益明细(圆值第二部分)
            ProfitDetailDtoModal*detailModal=[ProfitDetailDtoModal new];
            
           
            if (profitDetailDtoDic!=nil) {
                detailModal.month=[profitDetailDtoDic objectForKey:@"month"];
                NSLog(@"detailModal.month====%@",[detailModal.month class]);
                if ([[detailModal.month substringWithRange:NSMakeRange(0, 1)]intValue]==0 ) {
                    detailModal.month=[detailModal.month substringWithRange:NSMakeRange(1, 1)];
                    NSLog(@"detailModal.month====%@",detailModal.month );
                }
                detailModal.total=[profitDetailDtoDic objectForKey:@"total"];
                detailModal.totalProfit=[profitDetailDtoDic objectForKey:@"totalProfit"];
                detailModal.year=[profitDetailDtoDic objectForKey:@"year"];
                
                
                //判断是4个里面的哪几个

                if ([profitDetailDtoDic objectForKey:@"eshopProfit"]) {
                    [detailModal.dataArr addObject:[NSString stringWithFormat:@"%@",[profitDetailDtoDic objectForKey:@"eshopProfit"]]];
                    [detailModal.transferdDataArr addObject:[profitDetailDtoDic objectForKey:@"eshopProfit"]];
                    
                    
                    [detailModal.labNameArr addObject:@"电商"];
                    [detailModal.colorArr addObject:RGB(255, 166, 165, 1)];
                    
                }
                else
                {
                    [detailModal.dataArr addObject:@"暂无数据"];
                    [detailModal.transferdDataArr addObject:@"0"];
                    
                    
                    [detailModal.labNameArr addObject:@"电商"];
                    [detailModal.colorArr addObject:RGB(255, 166, 165, 1)];
                    
                }
                if ([profitDetailDtoDic objectForKey:@"mobileEchargeProfit"]) {
                    [detailModal.dataArr addObject:[NSString stringWithFormat:@"%@",[profitDetailDtoDic objectForKey:@"mobileEchargeProfit"]]];
                    [detailModal.transferdDataArr addObject:[profitDetailDtoDic objectForKey:@"mobileEchargeProfit"]];
                    
                    
                    [detailModal.labNameArr addObject:@"话费"];
                    [detailModal.colorArr addObject:RGB(255, 237, 184, 1)];
                    
                }
                else
                {
                    [detailModal.dataArr addObject:@"暂无数据"];
                    [detailModal.transferdDataArr addObject:@"0"];
                    
                    
                    [detailModal.labNameArr addObject:@"话费"];
                    [detailModal.colorArr addObject:RGB(255, 237, 184, 1)];
                    
                }
                
                if ([profitDetailDtoDic objectForKey:@"liveEchargeProfit"]) {
                    [detailModal.dataArr addObject:[NSString stringWithFormat:@"%@",[profitDetailDtoDic objectForKey:@"liveEchargeProfit"]]];
                    [detailModal.transferdDataArr addObject:[profitDetailDtoDic objectForKey:@"liveEchargeProfit"]];
                    
                    //[detailModal.dataArr addObject:@"500"];
                    
                    [detailModal.labNameArr addObject:@"水电煤"];
                    [detailModal.colorArr addObject:RGB(186, 244, 237, 1)];
                    
                    
                }
                else
                {
                    [detailModal.dataArr addObject:@"暂无数据"];
                    //[detailModal.dataArr addObject:@"500"];
                    [detailModal.transferdDataArr addObject:@"0"];
                    
                    
                    [detailModal.labNameArr addObject:@"水电煤"];
                    [detailModal.colorArr addObject:RGB(186, 244, 237, 1)];
                    
                }
                [self.profitDetailDtoArr addObject:detailModal];
                
                NSMutableArray*Arr=[NSMutableArray arrayWithArray:detailModal.dataArr];
                NSLog(@"detailModal.dataArr.count====%lu",(unsigned long)detailModal.dataArr.count);
                NSArray*transferdDataArr=[NSArray arrayWithArray:detailModal.transferdDataArr];
                NSArray*labNameArr=[NSArray arrayWithArray:detailModal.labNameArr];
                //总值
                
                [[NSUserDefaults standardUserDefaults]setObject:detailModal.total forKey:@"total"];
                
                [[NSUserDefaults standardUserDefaults]setObject:transferdDataArr forKey:@"transferDataArr"];
                
                [[NSUserDefaults standardUserDefaults]setObject:labNameArr forKey:@"labNameArr"];
                NSLog(@"----self.profitDetailDtoArr.count===%lu==content=%@",(unsigned long)self.profitDetailDtoArr.count,self.profitDetailDtoArr);
            }else
            {
                [self removeRoundArrData];
                detailModal.month=@"";
                [detailModal.dataArr addObject:@"暂无数据"];
                [detailModal.transferdDataArr addObject:@"0"];
    
                
                
                [detailModal.labNameArr addObject:@"电商"];
                [detailModal.colorArr addObject:RGB(255, 166, 165, 1)];
                [detailModal.dataArr addObject:@"暂无数据"];
                [detailModal.transferdDataArr addObject:@"0"];
                
                
                [detailModal.labNameArr addObject:@"话费"];
                [detailModal.colorArr addObject:RGB(255, 237, 184, 1)];
                [detailModal.dataArr addObject:@"暂无数据"];
                [detailModal.transferdDataArr addObject:@"0"];
                
                [detailModal.dataArr addObject:@"暂无数据"];
                [detailModal.transferdDataArr addObject:@"0"];
                [detailModal.labNameArr addObject:@"水电煤"];
                [detailModal.colorArr addObject:RGB(186, 244, 237, 1)];
                
                //总值

                [self.profitDetailDtoArr addObject:detailModal];
            }
            [self setupUI];
            [self.table reloadData];
            
            
        }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000)
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"total"];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"transferDataArr"];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"labNameArr"];
            NSLog(@"----vvv%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"total"]);

            [[NoticeTool notice]expireNoticeOnController:self];
        }else
        {
            [[NoticeTool notice] showTips:responseDicionary[@"tips"] onController:self];
            [self.table headerEndRefreshing];
                  [self.table reloadData];
        }
        [self.table headerEndRefreshing];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return fiestCellHeight;
    }else
    {
        if (indexPath.row==0) {
            return 0.1*screenHeight;
        }else
        {
            return secondCellHeight;
            
        }
        
    }
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
    if (section==1) {
        return headeImageArr.count+1;
    }
    
    return 1;
    
}

//设置区域的名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame=CGRectMake(0, 0, screenWidth, headerHeight);
    
    view.backgroundColor = RGB(233,233,233,1.0f);
    
    
    return view;
    
    
}


//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row!=0) {
        NSDictionary*proactiveLoginDic=      [[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];
        NSNumber*partyID=[proactiveLoginDic objectForKey:@"nodePartyId"];
        NSString*partyIDStr=[NSString stringWithFormat:@"%@",partyID];
        WYWebController*first=[WYWebController new];
        if ([businessStatusArr[indexPath.row-1] isEqualToString:@"SIGNED"]||[businessStatusArr[indexPath.row-1] isEqualToString:@"OPENING"]) {
            
            first.urlstr=[NSString stringWithFormat:@"%@?nodePartyId=%@",urlArr[indexPath.row-1],partyIDStr];
            first.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:first animated:YES];
            NSString*str=headeLabNameArr[indexPath.row-1];
            if ([str isEqualToString:@"银行业务"]) {
                [MobClick event:@"um_make_money_page_bank_click_event"];
            }else if ([str isEqualToString:@"电商业务"]){
                [MobClick event:@"um_make_money_page_electricity_click_event"];
            }else if ([str isEqualToString:@"手机充值"]){
                [MobClick event:@"um_make_money_page_mobile_click_event"];
            }else if ([str isEqualToString:@"借款业务"]){
                [MobClick event:@"um_make_money_page_loan_click_event"];
            }else if ([str isEqualToString:@"水电煤"]){
                //水电煤
                [MobClick event:@"um_make_money_page_czjf_click_event"];
            }
            
        }else
        {
            [[NoticeTool notice]showTips:@"此业务尚未开通" onController:self];
            
        }
        
        
        
    }
    
}
-(RoundView*)addRoundWithDownView:(UIView*)downView
{
    [round removeFromSuperview];
    round=[[RoundView alloc]initWithFrame:CGRectMake(0, 0.25*downView.frame.size.height, 0.5*screenWidth, 0.7*downView.frame.size.height)];
    NSLog(@"roundRect====%@",NSStringFromCGRect(round.frame));
    
    //    round.backgroundColor=[UIColor redColor];
    //               round.tag=4444;
    round.backgroundColor=[UIColor clearColor];
    [ downView addSubview:round];
    return round;
    
}
#pragma mark "显示cell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomMoneyCell*cell=   [CustomMoneyCell FillTableViewCellWith:tableView indexPath:indexPath imgNameStrArr:headeImageArr labelNameArr:headeLabNameArr ProfitDtoArr:self.ProfitDtoArr];
    

    //自定义cell分割线
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
      cell.separate_line.hidden = NO;
    
    if ( (headeImageArr.count && indexPath.row + 1 == [tableView numberOfRowsInSection:indexPath.section]) || indexPath.row == 0 ) {
    
//          cell.separate_line.hidden = YES;
        
    }else{
        
        [cell.separate_line mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell).offset(15);
        }];
        
        
    }
    
    
    if (indexPath.section==0) {
        
        if (self.ProfitDtoArr!=nil&&self.ProfitDtoArr.count==1&&!isFirst) {
            ProfitDtoModal*modal=self.ProfitDtoArr[0];
            //
            UILabel*leftNumLab= (UILabel*)[cell viewWithTag:8000];
            leftNumLab.text=modal.currentTotal;
            UILabel*rightNumLab= (UILabel*)[cell viewWithTag:8001];
            rightNumLab.text=modal.total;
            UILabel*leftDownLab= (UILabel*)[cell viewWithTag:8002];
            leftDownLab.text=[NSString stringWithFormat:@"%@月收益",modal.month];
            UILabel*rightDownLab= (UILabel*)[cell viewWithTag:8003];
            rightDownLab.text=@"累积收益(16年5月开始累计)";
            
        }
        if (isFirst) {
            UIButton*moreBtn=(UIButton*)[cell viewWithTag:1111];
            [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        
        
        UIView*downView=(UIView*)[cell viewWithTag:4321];
        
        UILabel*imageLab= (UILabel*)[downView viewWithTag:1200];
        
        UILabel*imageLab1= (UILabel*)[downView viewWithTag:1201];
        UILabel*imageLab2= (UILabel*)[downView viewWithTag:1202];
        UILabel*imageLab3= (UILabel*)[downView viewWithTag:1203];
        UILabel*lab= (UILabel*)[downView viewWithTag:3500];
        UILabel*lab1= (UILabel*)[downView viewWithTag:3501];
        UILabel*lab2= (UILabel*)[downView viewWithTag:3502];
        UILabel*lab3= (UILabel*)[downView viewWithTag:3503];
        UILabel*noOpenLab= (UILabel*)[cell viewWithTag:1222];
        noOpenLab.hidden=YES;
        
       
        
        if (![CoreStatus isNetworkEnable]&&!isFirst) {
            imageLab.hidden=YES;
            imageLab1.hidden=YES;
            imageLab2.hidden=YES;
            imageLab3.hidden=YES;
            lab.hidden=YES;
            lab1.hidden=YES;
            lab2.hidden=YES;
            lab3.hidden=YES;
            noOpenLab.hidden=NO;
            noOpenLab.text=@"暂无数据";
            [self addRoundWithDownView:downView];
            [[NoticeTool notice]showTips:@"网络无法连接" onController:self];
            
        }else
        {
            if (nameArr.count==0&&!isFirst) {
                [self addRoundWithDownView:downView];
                
                
                imageLab.hidden=YES;
                imageLab1.hidden=YES;
                imageLab2.hidden=YES;
                imageLab3.hidden=YES;
                lab.hidden=YES;
                lab1.hidden=YES;
                lab2.hidden=YES;
                lab3.hidden=YES;
                noOpenLab.hidden=NO;
                noOpenLab.hidden=NO;
                noOpenLab.text=@"暂无数据";
                
                
                
            }
            else if(nameArr.count!=0)
            {
                imageLab.hidden=YES;
                imageLab1.hidden=YES;
                imageLab2.hidden=YES;
                imageLab3.hidden=YES;
                lab.hidden=YES;
                lab1.hidden=YES;
                lab2.hidden=YES;
                lab3.hidden=YES;
                noOpenLab.hidden=YES;
                
                
                
                if (nameArr.count!=0) {
                    noOpenLab.hidden=YES;
                    [self addRoundWithDownView:downView]
                    ;
                    
                    
                    ProfitDetailDtoModal*detailModal=_profitDetailDtoArr[0];
                    
                    
                    
                    
                    UILabel*circleLabel=(UILabel*)[downView viewWithTag:3333];
                    circleLabel.text=[NSString stringWithFormat:@"%@月收益明细",detailModal.month];
                    //判断圆右边显示的数据
                    
                    
                    
                    if (nameArr.count==4) {
                        
                        imageLab.hidden=NO;
                        imageLab1.hidden=NO;
                        imageLab2.hidden=NO;
                        imageLab3.hidden=NO;
                        lab.hidden=NO;
                        lab1.hidden=NO;
                        lab2.hidden=NO;
                        lab3.hidden=NO;
                        //MOBILERECHARGE
                        
                        for(int i=0;i<4;i++) {
                            if(i==0)
                            {
                                
                                imageLab.backgroundColor=colorArr[0];
                                if ([realDataArr[0] isEqualToString:@"暂无数据"]) {
                                    lab.text=[NSString stringWithFormat:@"%@：%@",nameArr[0],realDataArr[0]];

                                }else
                                {
                                    lab.text=[NSString stringWithFormat:@"%@：%@元",nameArr[0],realDataArr[0]];

                                }
                                
                            }else if (i==1)
                            {
                                
                                imageLab1.backgroundColor=colorArr[1];
                                if ([realDataArr[1] isEqualToString:@"暂无数据"]) {
                                    lab1.text=[NSString stringWithFormat:@"%@：%@",nameArr[1],realDataArr[1]];
                                    
                                }else
                                {
                                    lab1.text=[NSString stringWithFormat:@"%@：%@元",nameArr[1],realDataArr[1]];
                                    
                                }

                                
                                
                            }else if(i==2)
                            {
                                imageLab2.backgroundColor=colorArr[2];
                                if ([realDataArr[2] isEqualToString:@"暂无数据"]) {
                                    lab2.text=[NSString stringWithFormat:@"%@：%@",nameArr[2],realDataArr[2]];
                                    
                                }else
                                {
                                    lab2.text=[NSString stringWithFormat:@"%@：%@元",nameArr[2],realDataArr[2]];
                                    
                                }

                                
                                
                                
                            }else
                            {
                                imageLab3.backgroundColor=colorArr[3];
                                if ([realDataArr[3] isEqualToString:@"暂无数据"]) {
                                    lab3.text=[NSString stringWithFormat:@"%@：%@",nameArr[3],realDataArr[3]];
                                    
                                }else
                                {
                                    lab3.text=[NSString stringWithFormat:@"%@：%@元",nameArr[3],realDataArr[3]];
                                    
                                }

                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                    }else if (nameArr.count==3)
                    {
                         NSLog(@"detailModal.dataArr[0]=%@=detailModal.dataArr[1]=%@==detailModal.dataArr[2]=%@",detailModal.dataArr[0],detailModal.dataArr[1],detailModal.dataArr[2]);
                        
                        imageLab.hidden=NO;
                        imageLab1.hidden=NO;
                        imageLab2.hidden=NO;
                        imageLab3.hidden=YES;
                        lab.hidden=NO;
                        lab1.hidden=NO;
                        lab2.hidden=NO;
                        lab3.hidden=YES;
                        for(int i=0;i<3;i++) {
                            if(i==0)
                            {
                                
                                imageLab.backgroundColor=colorArr[0];
                                if ([realDataArr[0] isEqualToString:@"0.00"]) {
                                    lab.text=[NSString stringWithFormat:@"%@：%@",nameArr[0],realDataArr[0]];
                                    
                                }else
                                {
                                    lab.text=[NSString stringWithFormat:@"%@：%@元",nameArr[0],realDataArr[0]];
                                    
                                }
                                
                            }else if (i==1)
                            {
                                
                                imageLab1.backgroundColor=colorArr[1];
                                if ([realDataArr[1] isEqualToString:@"0.00"]) {
                                    lab1.text=[NSString stringWithFormat:@"%@：%@",nameArr[1],realDataArr[1]];
                                    
                                }else
                                {
                                    lab1.text=[NSString stringWithFormat:@"%@：%@元",nameArr[1],realDataArr[1]];
                                    
                                }
                                
                                
                            }else
                            {
                                imageLab2.backgroundColor=colorArr[2];
                                if ([realDataArr[2] isEqualToString:@"0.00"]) {
                                    lab2.text=[NSString stringWithFormat:@"%@：%@",nameArr[2],realDataArr[2]];
                                    
                                }else
                                {
                                    lab2.text=[NSString stringWithFormat:@"%@：%@元",nameArr[2],realDataArr[2]];
                                    
                                }
                                
                                

                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }else if (nameArr.count==2)
                    {
                        
                        
                        NSLog(@"----detailModal.dataArr=%@==索引1对应==%@",detailModal.dataArr,detailModal.dataArr[1]);
                        NSLog(@"lab1.text===%@",lab1.text);
                        NSLog(@"lab2.text===%@==detailModal.dataArr[1]===%@",lab2.text,detailModal.dataArr[1]);
                        lab1.hidden=NO;
                        lab2.hidden=NO;
                        imageLab1.hidden=NO;
                        imageLab2.hidden=NO;
                        
                        lab.hidden=YES;
                        lab3.hidden=YES;
                        //                           imageLab1.backgroundColor=detailModal.colorArr[0];
                        //
                        //                           imageLab2.backgroundColor=detailModal.colorArr[1];
                        imageLab.hidden=YES;
                        imageLab3.hidden=YES;
                        for(int i=0;i<2;i++) {
                            if(i==0)
                            {
                                
                                imageLab1.backgroundColor=colorArr[0];
                                if ([realDataArr[0] isEqualToString:@"0.00"]) {
                                    lab1.text=[NSString stringWithFormat:@"%@：%@",nameArr[0],realDataArr[0]];

                                }else
                                {
                                    lab1.text=[NSString stringWithFormat:@"%@：%@元",nameArr[0],realDataArr[0]];

                                }
                                
                            }else
                            {
                                
                                imageLab2.backgroundColor=colorArr[1];
                                if ([realDataArr[1] isEqualToString:@"0.00"]) {
                                    lab2.text=[NSString stringWithFormat:@"%@：%@",nameArr[1],realDataArr[1]];

                                }else{
                                lab2.text=[NSString stringWithFormat:@"%@：%@元",nameArr[1],realDataArr[1]];
                                }
                                
                                
                            }
                            
                        }
                        
                        
                    }else
                    {
                        lab2.hidden=YES;
                        lab3.hidden=YES;
                        lab.hidden=YES;
                        //                           imageLab1.backgroundColor=detailModal.colorArr[0];
                        imageLab.hidden=YES;
                        imageLab2.hidden=YES;
                        imageLab3.hidden=YES;
                        lab1.hidden=NO;
                        imageLab1.hidden=NO;
                        imageLab1.backgroundColor=colorArr[0];
                        if ([realDataArr[0] isEqualToString:@"0.00"]) {
                            lab1.text=[NSString stringWithFormat:@"%@：%@",nameArr[0],realDataArr[0]];

                        }else
                        {
                            lab1.text=[NSString stringWithFormat:@"%@：%@元",nameArr[0],realDataArr[0]];

                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
            }
            
            
            
        }
        
        
        
        
        
        
    }else
    {
        if (!isFirst&&headeImageArr.count==0) {
            [secondCellNoDataLab removeFromSuperview];
            
            secondCellNoDataLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.65*screenHeight, screenWidth, 40)];
            
            secondCellNoDataLab.text=@"暂无数据";
            secondCellNoDataLab.textColor=RGB(170, 170, 170, 1);
            secondCellNoDataLab.textAlignment=NSTextAlignmentCenter;
            [self.table addSubview:secondCellNoDataLab];
            
            
        }else
        {
            [secondCellNoDataLab removeFromSuperview];
            
        }
        
    }
    
    
    
    
    return   cell;
    
    
}

//更多月份
-(void)moreClick
{
    [MobClick event:@"um_make_money_page_more_month_click_event"];
    MoreMonthConroller*more=[MoreMonthConroller new];
    more.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:more animated:YES];
}

-(NSString *)resetString:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"."];
    if (arr.count == 2) {
        NSString *last = arr.lastObject;
        
        if (last.length >= 2) {
            last = [last substringToIndex:2];
            str = [NSString stringWithFormat:@"%@.%@",arr.firstObject,last];
        }else if (last.length == 1){
            str = [NSString stringWithFormat:@"%@.%@0",arr.firstObject,last];
        }else{
            str = [str stringByAppendingString:@".00"];
        }
        
    }else{
        str = [str stringByAppendingString:@".00"];
    }
    return str;
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
