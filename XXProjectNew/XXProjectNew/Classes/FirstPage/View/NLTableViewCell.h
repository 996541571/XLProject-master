//
//  NLTableViewCell.h
//  XXProjectNew
//
//  Created by apple on 11/24/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsListPageModel;
@interface NLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title_lable;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *source_label;
@property(nonatomic,strong)NewsListPageModel* model;
@property (weak, nonatomic) IBOutlet UIView *insideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_trailing_constraint;
//分割线
@property(nonatomic,strong)UIView* separate_line;

@end
