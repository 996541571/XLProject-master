//
//  DVRedPacketCheckTVC.h
//  XXProjectNew
//
//  Created by apple on 1/10/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVRedPacketCheckTVC : UITableViewController
@property(nonatomic,weak)UIImageView* iconImgView;
@property(nonatomic,weak)UILabel* userName_label;
@property(nonatomic,weak)UILabel* greetings_label;
@property(nonatomic,weak)UILabel* money_label;

@property(nonatomic,copy)NSString* packetID;

@property(nonatomic,assign)NSInteger index;


//
/*!
 发送者的用户ID
 */
@property(nonatomic, strong) NSString *senderUserId;

@property(nonatomic, strong) NSString *targetId;

//@property(nonatomic,strong)SimpleMessage* messageModel;


@property(nonatomic,strong)RCMessageModel* messageModel;

@end
