//
//  CoreStatusProtocol.h
//  CoreStatus
//
//  Created by 成林 on 15/7/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#ifndef CoreStatus_CoreStatusProtocol_h
#define CoreStatus_CoreStatusProtocol_h
#import "CoreNetworkStatus.h"

@protocol CoreStatusProtocol <NSObject>
@optional

@property (nonatomic,assign) NetworkStatus currentStatus;

/** 网络状态变更 */
-(void)coreNetworkChangeNoti:(NSNotification *)noti;

@end


#endif
