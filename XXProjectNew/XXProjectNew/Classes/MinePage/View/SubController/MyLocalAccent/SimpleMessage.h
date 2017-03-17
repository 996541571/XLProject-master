//
//  SimpleMessage.h
//  XXProjectNew
//
//  Created by apple on 1/9/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>

#define RCLocalMessageTypeIdentifier @"RC:SimpleMsg"
/**
 * 文本消息类定义
 */
@interface SimpleMessage : RCMessageContent <NSCoding,RCMessageContentView>

/**
 *  消息文本内容
 */
@property (nonatomic, strong) NSString * content;

/**
 *  附加消息 红包ID
 */
@property (nonatomic, strong) NSString * bribery_ID;

/**
 *  红包名称
 */
@property (nonatomic, strong) NSString * briberyName;

/**
 *  红包描述
 */
@property (nonatomic, copy) NSString * briberyDesc;




/**
 *  根据参数创建红包消息对象
 *
 *  @param content 文本消息内容
 *
 *  @return RDBriberyMessage 对象
 */
+ (instancetype)messageWithContent:(NSString *)content;



//红包金额

@property(nonatomic,copy) NSString* briberyAmount;


@end



