//
//  InviteActivityViewModel.h
//  XXProjectNew
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InviteActivityModel;
@interface InviteActivityViewModel : NSObject
+(instancetype)model;

-(void)obtainWebDataWithSuccess:(void (^)())success ;
@property(nonatomic,strong)NSArray<InviteActivityModel*>* rank_arr;
@property(nonatomic,strong)InviteActivityModel* myRank;
@property(nonatomic,copy)NSString* recCount;
@property(nonatomic,copy)NSString* recAmtStr;
@property(nonatomic,copy)NSString* wxHref;
@property(nonatomic,copy)NSString* pyqHref;
@property(nonatomic,copy)NSString* amt;
@property(nonatomic,copy)NSString* detail;
@property(nonatomic,copy)NSString* desc;
//微信
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* msg;

//二维码
@property(nonatomic,copy)NSString* qrCode;

-(void)obtaininviteUserRankingDataWithSuccess:(void(^)())success;


@end
