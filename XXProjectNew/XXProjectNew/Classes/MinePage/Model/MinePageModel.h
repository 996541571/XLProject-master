//
//  MinePageModel.h
//  XXProjectNew
//
//  Created by apple on 12/14/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinePageModel : NSObject
@property(nonatomic,copy)NSString* aboutAppRow;
@property(nonatomic,copy)NSString* accountRow;
@property(nonatomic,copy)NSString* inviteRow;
@property(nonatomic,copy)NSString* resetPwRow;
@property(nonatomic,copy)NSString* userInfoRow;
@property(nonatomic,strong)NSDictionary* presentCell_dic;
@end
