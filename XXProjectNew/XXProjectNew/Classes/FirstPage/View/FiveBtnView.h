//
//  FiveBtnView.h
//  XXProjectNew
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiveBtnView : UIView
@property(nonatomic,copy)void (^fiveBtnBlock)(NSString* urlStr,NSString *name);
@property(nonatomic,retain) NSMutableArray*urlArr;
@property(nonatomic,retain) NSMutableArray*fiveBtnArr;
@property(nonatomic,retain) NSMutableArray*businessStatusArr;
@property(nonatomic,strong) NSMutableArray *labNameArr;


- (instancetype)initWithFrame:(CGRect)frame withArr:(NSMutableArray*)transferArr;
//- (CGRect)getFrameFromView;





@end
