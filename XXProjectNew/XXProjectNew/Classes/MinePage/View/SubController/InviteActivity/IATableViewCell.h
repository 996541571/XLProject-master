//
//  IATableViewCell.h
//  XXProjectNew
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  InviteActivityModel;
@interface IATableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Font_icon;
@property (weak, nonatomic) IBOutlet UILabel *rankNum_label;
@property (weak, nonatomic) IBOutlet UIImageView *head_icon;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *prize_label;
@property(nonatomic,strong) InviteActivityModel * cellModel;
@property(nonatomic,strong)NSArray* fontIcon_arr;
@end
