//
//  DVViewController.m
//  XXProjectNew
//
//  Created by apple on 12/1/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "DVViewController.h"

@interface DVViewController ()

@end

@implementation DVViewController

//-(void)loadView{
//    
//    [super loadView];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBtn];
    self.navigationController.navigationBarHidden = NO;
    
}


-(void)setBackBtn{
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];
    
    
    
    
}

-(void)backToLastView{
    
    [self.navigationController popViewControllerAnimated:true];
    
    
}

@end
