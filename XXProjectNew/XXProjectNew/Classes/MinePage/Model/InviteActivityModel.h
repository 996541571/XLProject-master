//
//  InviteActivityModel.h
//  XXProjectNew
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteActivityModel : NSObject
//邀请人数
@property(nonatomic,copy)NSString* recCount;
//获得金额
//@property(nonatomic,copy)NSString* recAmtStr;
//

//头像地址
@property(nonatomic,copy)NSString* headImg;
//显示名字
@property(nonatomic,copy)NSString* commentName;
//名次
@property(nonatomic,copy)NSString* ranking;
//获得金额
@property(nonatomic,copy)NSString* recAmtStr;


@end
