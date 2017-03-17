//
//  ContactsCell.h
//  XXProjectNew
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ContactsModel.h"
@class ContactsModel;
@interface ContactsCell : UITableViewCell
@property(nonatomic,strong)ContactsModel *model;
+(CGFloat)rowHeight;
@end
