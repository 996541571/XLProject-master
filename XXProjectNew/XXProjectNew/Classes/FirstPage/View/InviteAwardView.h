//
//  InviteAwardView.h
//  XXProjectNew
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteAwardView : UIView
@property (weak, nonatomic) IBOutlet UIButton *check;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *close;
+(instancetype)awardView;

@end
