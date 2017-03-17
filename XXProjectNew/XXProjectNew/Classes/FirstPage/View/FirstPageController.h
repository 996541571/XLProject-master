//
//  FirstPageController.h
//  XXProjectNew
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^updateMsgBlock)();
@interface FirstPageController : UIViewController
@property(nonatomic,strong)NSMutableArray*imageArr;
@property(nonatomic,strong)NSMutableArray*msgVoListArr;
@property(nonatomic,copy)updateMsgBlock msgBlock;
@end
