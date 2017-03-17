//
//  AboutXLViewController.m
//  XXProjectNew
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "AboutXLViewController.h"
#import "MyCell.h"
#import "Masonry.h"
#import "NetRequest.h"
#import "NoticeTool.h"
#import "UIImage+attribute_change.h"
#import "MinePageViewModel.h"

@interface AboutXLViewController()<UIAlertViewDelegate>
@property(nonatomic,assign)BOOL isMustUpdate;
@property(nonatomic,copy)NSString* message;
@property(nonatomic,assign)NSInteger updateCellNum;
@end
//static NSString* reusedID = @"cell";


@implementation AboutXLViewController


-(void)loadView{
    [super loadView];
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = false;
    
    self.tabBarController.hidesBottomBarWhenPushed = true;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //    [self registerForCell];
    
    [self setupTableView];
    
    [self setNavigationBar];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = true;
    
    self.tabBarController.hidesBottomBarWhenPushed = true;
    
}



-(void)registerForCell{
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reusedID];
    
    UINib* nib = [UINib nibWithNibName:@"MyCell" bundle:nil];
    
    NSLog(@"%@",nib);
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"myForth"];
    
    
}

-(void)setNavigationBar{
    
    
    
    
    
    
    
    
    
    
    
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;

    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];
    
    

    
    
   UILabel* lable =[UILabel new];
    lable.text = @"关于乡邻";
    [lable sizeToFit];
    lable.textColor = KNavigationbarSystemColor;
    self.navigationItem.titleView = lable;
    
    
}


-(void)backToLastView{
    
    
    [self.navigationController popViewControllerAnimated:true];
    
}




#pragma mark "设置tableView"
-(void)setupTableView{
    
    self.tableView.sectionFooterHeight = 5;
    self.tableView.sectionHeaderHeight = 5;

    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/4+10)];
    
    UIView* realheadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/4)];
    
    UIView* spaceView = [[UIView alloc]initWithFrame:CGRectMake(0,screenWidth, screenWidth, 10)];
    
    //add a line
    
    UIView* separate_line = [UIView new];
    
    separate_line.backgroundColor = [UIColor lightGrayColor];
    
    separate_line.hidden = NO;
    
    [realheadView addSubview:separate_line];
    
    [separate_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@0.5);
        
        make.bottom.equalTo(realheadView);
        
        make.width.mas_equalTo(screenWidth);
        
        
        
    }];


    

    
    
    [headView addSubview:realheadView];
    [headView addSubview:spaceView];
    
    realheadView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = headView;
    
    
    UIImage* img = [UIImage imageNamed:@"aboutXL_Big"];
    
    
    UIImageView* imgView =[[UIImageView alloc]initWithImage:img];
    
    [headView addSubview:imgView];
    
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(realheadView);
        
        make.size.mas_equalTo(CGSizeMake(50, 50));

    }];
    
    
    
    //version_label
    
    
    UILabel* version_label = [UILabel new];
    
    NSString* local_version = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    version_label.text = [NSString stringWithFormat:@"乡邻 %@",local_version];
    
    version_label.font = [UIFont systemFontOfSize:12];
    
    version_label.textColor = [UIColor lightGrayColor];
    
    [version_label sizeToFit];
    
    [realheadView addSubview:version_label];

    [version_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgView.mas_bottom).offset(10);
        
        make.centerX.equalTo(realheadView.mas_centerX);
        
    }];
    
    
    
    
}



#pragma mark - Table view data source



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (([MinePageViewModel model].user == visitor || [MinePageViewModel model].user == villager) && indexPath.section == 0) {
        
        return 0;
        
    }
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    static NSInteger rowNumber = 0 ;
    

    
    
    switch (section) {
        case 0:
            
            rowNumber = 2;
            
            break;
            
        case 1:
            
            //根据参数返回行
        
        
            rowNumber = self.updateCellNum;
            
            
        {
        
            NSArray *requestArr = @[@{@"deviceType":@"IOS"}];
            [NetRequest requetWithParams:requestArr requestName:@"app.XLAppIndexPageService.version" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
                
                
                
                NSDictionary*  result = responseDicionary[@"result"];
                
                NSString* resultStatus = (NSString*)responseDicionary[@"resultStatus"];
                
                NSString* version = result[@"version"];
                
                NSString* local_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                //如果连接正常
                if (resultStatus.integerValue == 1000) {
                    
                    NSLog(@"%@-----%@",version,local_version);
                    
                    //如果等于-1
                    if ([result[@"updateLevel"] integerValue] == -1) {
                        //判断是否是最新版本
                        
                        
                        
                    }else{
                        
                        
//                        rowNumber = 1;
                        
                        if (!self.updateCellNum) {
                            
                            
                            self.updateCellNum = 1;
                            
                            [self.tableView reloadData];
                        }
                        
                        
                    }}else{
                        
                        
                        
                    }
            }];
            
        
        }
            
            break;

            
        default:
            break;
    }
    
    
    return rowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([MinePageViewModel model].user == visitor || [MinePageViewModel model].user == villager) && indexPath.section == 0) {

        
       MyCell* cell = [[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:nil options:nil][5];
        
        
        return cell;
        
        
    }
    
    MyCell *cell;
    cell = [[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:nil options:nil][3];
    
    
    

    
    
    UIImageView*imgView= (UIImageView*)[cell viewWithTag:9003];
    UILabel*contentLab= (UILabel*)[cell viewWithTag:9004];
    imgView.image=[UIImage imageNamed:self.MineViewController_transferImageArr[indexPath.row]];
    
    
    if (indexPath.section == 1) {
        
        contentLab.text= @"检查新版本";
        
        imgView.image=[UIImage imageNamed:@"xlUpdate"];

    }
   
    
    if (indexPath.section == 0) {
        
        
        contentLab.text=self.MineViewController_transferNameArr[indexPath.row];
    }
    
    
    return cell;
}


#pragma mark "点击响应"
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    
    WYWebController*first=[WYWebController new];
    first.hidesBottomBarWhenPushed=YES;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/questions.html",ENV_H5_URL];
            [MobClick event:@"um_mine_page_questionnaire_click_event"];
            
        }else if (indexPath.row == 1){
            
            first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/contactManager.html",ENV_H5_URL];
            [MobClick event:@"um_mine_page_contact_manager_click_event"];
        }
        
        
        
        [self.navigationController pushViewController:first animated:YES];
        
    }else if (indexPath.section == 1){
        
        
        NSLog(@"检查版本");
        
//            first.urlstr=[NSString stringWithFormat:@"%@/home/nodeManager/contactManager.html",ENV_H5_URL];
        
        [self checkVersion];
        
        
        
        
        
    }
    
}

-(void)checkVersion
{
//    [[NoticeTool notice] showTips:@"当前版本已是最新版本" onController:self];
    NSArray *requestArr = @[@{@"deviceType":@"IOS"}];
    [NetRequest requetWithParams:requestArr requestName:@"app.XLAppIndexPageService.version" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
     
        
        
        NSDictionary*  result = responseDicionary[@"result"];
        
        NSString* resultStatus = (NSString*)responseDicionary[@"resultStatus"];
        
        NSString* version = result[@"version"];
        
        NSString* local_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        //如果连接正常
        if (resultStatus.integerValue == 1000) {
            
            NSLog(@"%@-----%@",version,local_version);
            
            //如果等于-1
            if ([result[@"updateLevel"] integerValue] == -1) {
                //判断是否是最新版本
                
                    [[NoticeTool notice]showTips:@"当前已是最新版本" onController:self.navigationController];
                
                return ;
                
//                    [[NoticeTool notice]showTips:@"有新版本了,请前往AppStore更新" onController:self.navigationController];
                
                
            } else {
                
                //如果等于0或者1
                //判断大小
                
                NSString *version_after = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                NSString* local_version_after= [local_version stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                NSLog(@"%@,%@",version_after,local_version_after);
                
                //如果有新版本
                if (version_after.integerValue > local_version_after.integerValue) {
                    NSString *cancel;
                    if ([result[@"updateLevel"] integerValue] == 0) {
                        cancel = @"取消";
                        _isMustUpdate = NO;
                    } else {
                        cancel = nil;
                        _isMustUpdate = YES;
                    }
                    
                    NSString* message = result[@"desc"];
                    
                    self.message = message;
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:@"确定", nil];
//                    [alert show];
                    
                 
                    
                    
                    //如果你的系统大于等于7.0
                    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
                    {
                        CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(240,400) lineBreakMode:NSLineBreakByTruncatingTail];
                        
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(+10, 0,260, size.height)];
                        
//                        UILabel* textLabel = [UILabel new];
                        
                        textLabel.font = [UIFont systemFontOfSize:15];
                        textLabel.textColor = [UIColor blackColor];
                        textLabel.backgroundColor = [UIColor clearColor];
                        textLabel.lineBreakMode =NSLineBreakByWordWrapping;
                        textLabel.numberOfLines =0;
                        textLabel.text = message;
                        
                        if (size.height > 20) {
                            
                            textLabel.textAlignment =NSTextAlignmentLeft;
                        }else{
                            
                            textLabel.textAlignment = NSTextAlignmentCenter;
                        }
                        
                        
                        UIView* textView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, 280, size.height)];
                        [textView addSubview:textLabel];
                        [alert setValue:textView forKey:@"accessoryView"];
                        
                        alert.message =@"";
                    }else{
                        NSInteger count = 0;
                        for( UIView * view in alert.subviews )
                        {
                            if( [view isKindOfClass:[UILabel class]] )
                            {
                                count ++;
                                if ( count == 2 ) { //仅对message左对齐
                                    UILabel* label = (UILabel*) view;
                                    label.textAlignment =NSTextAlignmentLeft;
                                }
                            }
                        }
                    }
                    [alert show];
                    

                    
                    
                    //如果版本一样
                }else if (version_after.integerValue == local_version_after.integerValue){
                    
                    [[NoticeTool notice]showTips:@"当前已是最新版本" onController:self.navigationController];
                    
                    
                    //本地版本大于最新版本
                }else{
                    
                    [[NoticeTool notice]showTips:@"当前已是最新版本" onController:self.navigationController];
                    
                    
                    
                }

        
        
    }

        }else if ([[responseDicionary objectForKey:@"resultStatus"]intValue]==2000){
            [[NoticeTool notice] expireNoticeOnController:self];
        }

//        NSLog(@"%@",responseDicionary);
    }];
}



#pragma mark "alertView代理方法"

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex ) {
        
        
        [alertView show];
        
        
        //https://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8
        
        NSURL* url = [[NSURL alloc]initWithString:@"itms-apps://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8"];
        
        [[UIApplication sharedApplication]openURL:url];
        
        
    }
    
    if (alertView.numberOfButtons == 1) {
        
        
        [alertView show];
        
        
        //https://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8
        
        NSURL* url = [[NSURL alloc]initWithString:@"itms-apps://itunes.apple.com/cn/app/xiang-lin/id1159597834?mt=8"];
        
        [[UIApplication sharedApplication]openURL:url];

        
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.numberOfButtons == 1) {
        
        
        
        NSString* message = self.message;
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //                    [alert show];
        
        alert.delegate = self;
        
        
        //如果你的系统大于等于7.0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(240,400) lineBreakMode:NSLineBreakByTruncatingTail];
            
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(+10, 0,260, size.height)];
            
            //                        UILabel* textLabel = [UILabel new];
            
            textLabel.font = [UIFont systemFontOfSize:15];
            textLabel.textColor = [UIColor blackColor];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.lineBreakMode =NSLineBreakByWordWrapping;
            textLabel.numberOfLines =0;
            textLabel.text = message;
            
            if (size.height > 20) {
                
                textLabel.textAlignment =NSTextAlignmentLeft;
            }else{
                
                textLabel.textAlignment = NSTextAlignmentCenter;
            }
            
            
            UIView* textView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, 280, size.height)];
            [textView addSubview:textLabel];
            [alert setValue:textView forKey:@"accessoryView"];
            
            alert.message =@"";
        }else{
            NSInteger count = 0;
            for( UIView * view in alert.subviews )
            {
                if( [view isKindOfClass:[UILabel class]] )
                {
                    count ++;
                    if ( count == 2 ) { //仅对message左对齐
                        UILabel* label = (UILabel*) view;
                        label.textAlignment =NSTextAlignmentLeft;
                    }
                }
            }
        }
        [alert show];
        
        
    }

    
}
//- (void)willPresentAlertView:(UIAlertView *)alertView{
//    UIView * view = [alertView.subviews objectAtIndex:2];
    
//    NSLog(@"%@",alertView.subviews);
    
//    for (UIView* view  in alertView.subviews) {
//        
//        
//        if([view isKindOfClass:[UILabel class]]){
//            UILabel* label = (UILabel*) view;
//            label.textAlignment = UITextAlignmentLeft;
//        }
//        
//    }
    
//}

@end
