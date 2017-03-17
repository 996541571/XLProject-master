//
//  ScrollToNextVC.h
//  XXProjectNew
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RewardBlock) (NSString *result);
@interface WYWebController : UIViewController
@property(nonatomic,retain)NSString*urlstr;
@property(nonatomic,retain)UIWebView*myWeb;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,copy)RewardBlock block;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,getter=isDelete)BOOL toDeleteCache;


//关闭网页的回调
@property(nonatomic,copy)void(^close_blcok)();

@end
