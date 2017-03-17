//
//  RedPacketBaseCell.h
//  XXProjectNew
//
//  Created by apple on 1/9/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class SimpleMessage;
/*!
 测试消息Cell
 */
@interface RedPacketBaseCell : RCMessageCell


/**
 * 红包描述消息显示Label
 */
@property(strong, nonatomic) UILabel *descLabel;

/**
 * 查看/领取 红包文字描述消息显示Label
 */
@property(strong, nonatomic) UILabel *subNameLabel;

/**
 * 红包名称显示Label
 */
@property(strong, nonatomic) UILabel *nameLabel;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *briberyBackgroundView;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 设置消息数据模型
 *
 * @param model 消息数据模型
 */
//- (void)setDataModel:(RCMessageModel *)model;


@end
