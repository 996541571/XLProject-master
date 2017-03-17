//
//  NaviViewController.m
//  XXProjectNew
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "NaviViewController.h"

@interface NaviViewController ()<UINavigationControllerDelegate>
@property (nonatomic, getter=isPushing) BOOL pushing;

@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.pushing == YES) {
        NSLog(@"被拦截");
        return;
    } else {
        NSLog(@"push");
        self.pushing = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushing = NO;
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
