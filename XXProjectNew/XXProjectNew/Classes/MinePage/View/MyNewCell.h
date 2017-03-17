//
//  MyNewCell.h
//  XXProjectNew
//
//  Created by apple on 2016/11/15.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dot;
@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,strong)UIView* separate_line;

@end
