//
//  DVConversationVC.h
//  XXProjectNew
//
//  Created by apple on 1/3/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@class DVConversationListVC;
@interface DVConversationVC : RCConversationViewController
@property(nonatomic,weak)DVConversationListVC* listVC;
@end
