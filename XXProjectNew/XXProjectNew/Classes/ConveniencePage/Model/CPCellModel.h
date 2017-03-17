//
//  CPCellModel.h
//  XXProjectNew
//
//  Created by apple on 12/9/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCellModel : NSObject

/*
 菜单名称
 */
@property(nonatomic,copy)NSString* mname;
/*
 菜单等级
 */
@property(nonatomic,copy)NSString* mlevel;
/*
 菜单类型
 */
@property(nonatomic,copy)NSString* busitype;
/*
 父菜单ID
 */
@property(nonatomic,copy)NSString* pid;
/*
 菜单ID
 */
@property(nonatomic,copy)NSString* mid;
/*
 菜单状态
 */
@property(nonatomic,copy)NSString* mstatus;
/*
 菜单排序
 */
@property(nonatomic,copy)NSString* morder;
/*
 业务链接
 */
@property(nonatomic,copy)NSString* murl;
/*
 图标logo
 */
@property(nonatomic,copy)NSString* imgurl;

@end
