//
//  EarnMoneyController.h
//  XXProjectNew
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarnMoneyController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom_constraints;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,getter=isOther)BOOL other;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_top;

@end
