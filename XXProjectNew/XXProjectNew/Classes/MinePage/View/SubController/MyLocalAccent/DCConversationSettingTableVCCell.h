//
//  DCConversationSettingTableVCCell.h
//  XXProjectNew
//
//  Created by apple on 1/5/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    cellTypeSwich,
    cellTypeMiddle,
    cellTypeHeadV
} cellType;

@interface DCConversationSettingTableVCCell : UITableViewCell
@property(nonatomic,assign)cellType cellType;
@property(nonatomic,weak)UILabel* cell_label;
@property(nonatomic,weak)UISwitch* cell_switch;
@property(nonatomic,weak)UIImageView* head_imgV;
@property(nonatomic,weak)UILabel* detail_label;
@end
