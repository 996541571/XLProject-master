//
//  NewUserView.h
//  XXProjectNew
//
//  Created by apple on 2016/10/24.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserView : UIView
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *claim;
@property (weak, nonatomic) IBOutlet UIView *bgView;
+(instancetype)userView;
@end
