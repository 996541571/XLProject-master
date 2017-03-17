//
//  WKWebVC.h
//  XXProjectNew
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RewardBlock) (NSString *result);
@interface WKWebVC : UIViewController
@property(nonatomic,strong)NSString *urlstr;
@property(nonatomic,copy)RewardBlock block;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,strong)NSString *msgTitle;
@property(nonatomic,strong)NSString *msgImage;
@property(nonatomic,strong)NSString *message;
@end
