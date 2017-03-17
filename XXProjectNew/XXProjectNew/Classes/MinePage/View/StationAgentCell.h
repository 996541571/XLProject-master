//
//  StationAgentCell.h
//  XXProjectNew
//
//  Created by apple on 2016/11/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationAgentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property(nonatomic,strong)UIView* separate_line;
@property(nonatomic,copy)NSString* logStr;
@property(nonatomic,weak)UIImageView* icon_imgV;

@property (weak, nonatomic) IBOutlet UIView *spot;
@property (weak, nonatomic) IBOutlet UIView *rect;
@property(weak,nonatomic)UILabel* log_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraints_trailing;

//@property(nonatomic,strong)NSString* logArr;

@end
