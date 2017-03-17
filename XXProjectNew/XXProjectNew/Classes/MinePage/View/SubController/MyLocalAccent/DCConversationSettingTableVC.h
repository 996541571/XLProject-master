//
//  DCConversationSettingTableVC.h
//  XXProjectNew
//
//  Created by apple on 1/3/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface DCConversationSettingTableVC : UITableViewController
/*!
 目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;

//弱引用
@property(nonatomic,weak)DVConversationListVC* listVC;

//弱引用聊天界面
@property(nonatomic,weak)DVConversationVC* conversationVC;

@end
