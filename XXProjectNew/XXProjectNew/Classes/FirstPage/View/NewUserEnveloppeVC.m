//
//  NewUserEnveloppeVC.m
//  XXProjectNew
//
//  Created by apple on 2016/10/24.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "NewUserEnveloppeVC.h"

@interface NewUserEnveloppeVC ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end

@implementation NewUserEnveloppeVC
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.checkBtn.layer.cornerRadius = 5.f;
    self.checkBtn.clipsToBounds = YES;
//    __weak NewUserEnveloppeVC *weakSelf = self;
    
    NSArray *arr = [self.count componentsSeparatedByString:@"."];
    if (arr.count == 2 && [arr.lastObject length] >= 2) {
        self.count = [NSString stringWithFormat:@"%@.%@元",arr.firstObject,[arr.lastObject substringToIndex:2]];
    }else if (arr.count == 2 && [arr.lastObject length] == 1){
        self.count = [NSString stringWithFormat:@"%@.%@0元",arr.firstObject,arr.lastObject];
    }else{
        self.count = [NSString stringWithFormat:@"%@.00元",arr.firstObject];
    }
    self.amount.text = self.count;
}

//查看
- (IBAction)check:(UIButton *)sender {
    [MobClick event:@"um_new_user_hongbao_page_to_view_click_event"];
    NSDictionary*loginInfodic =[[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    WYWebController *web = [[WYWebController alloc]initWithNibName:@"WYWebController" bundle:nil];
    web.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
    web.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:web animated:YES];
}
////返回
//- (IBAction)pop:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
