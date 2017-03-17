//
//  RewordView.h
//  XXProjectNew
//
//  Created by apple on 2016/11/11.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewordView : UIView
+(instancetype)rewordView;
@property (weak, nonatomic) IBOutlet UIButton *reword;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@end
