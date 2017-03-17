//
//  CPTableViewcell.h
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConveniencePageModel;
@interface CPTableViewcell : UITableViewCell
@property(nonatomic,weak)UILabel* title_label;
@property(nonatomic,strong) ConveniencePageModel* cell_model;
@property(nonatomic,strong)NSArray* btn_arr;
@property(nonatomic,copy)void (^block)(DVButton* btn,NSInteger cell_tag);
@end
