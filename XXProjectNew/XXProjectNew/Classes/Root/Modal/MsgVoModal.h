//
//  MsgVoModal.h
//  XXProjectNew
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgVoModal : NSObject
@property(nonatomic,retain)NSString*createTime;
@property(nonatomic,assign)BOOL isSave;
@property(nonatomic,retain)NSString*msgStatus;
@property(nonatomic,retain)NSString*msgTitle;
@property(nonatomic,retain)NSString*msgType;
@property(nonatomic,retain)NSString*praiseSign;
@property(nonatomic,retain)NSString*praises;
@property(nonatomic,retain)NSString*readNum;
@property(nonatomic,retain)NSString*updateTime;
//点击要跳转的
@property(nonatomic,retain)NSString*url;
//乡邻那种图片，判断是不是本地
@property(nonatomic,retain)NSString*titleImg;






@end
