//
//  MMPinView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPinView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import "MMPopupWindow.h"

#import "businessPopCell.h"
//#import <Masonry/Masonry.h>

@interface MMPinView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView      *backView;

@property (nonatomic, strong) UILabel     *lblStatus;
@property (nonatomic, strong) UILabel     *lblPhone;

@property (nonatomic, strong) UIView      *numberView;
@property (nonatomic, strong) NSArray     *numberArray;

@property (nonatomic, strong) UIButton    *btnCountDown;

//@property (nonatomic, strong) UITextField *tfPin;

@property (nonatomic, strong) UIButton    *btnClose;

@property (nonatomic, assign) BOOL        pinLocked;
@property (nonatomic, strong) NSString    *pinLockValue;

@property (nonatomic, strong) NSDate      *dateCountdown;
@property (nonatomic, assign) NSUInteger  nCountdown;

@property(nonatomic,strong)UILabel* amount_label;

@end

@implementation MMPinView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeCustom;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 200));
        }];
        
        self.withKeyboard = YES;
        
        self.backView = [UIView new];
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.backView.layer.cornerRadius = 5.0f;
        self.backView.clipsToBounds = YES;
        self.backView.backgroundColor = [UIColor whiteColor];
        
        self.btnClose = [UIButton mm_buttonWithTarget:self action:@selector(actionClose)];
        [self.backView addSubview:self.btnClose];
        [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 0, 0, 5));
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.btnClose setTitle:@"×" forState:UIControlStateNormal];
        [self.btnClose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.btnClose.titleLabel.font = [UIFont systemFontOfSize:20];
        
        self.lblStatus = [UILabel new];
        [self.backView addSubview:self.lblStatus];
        [self.lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 19, 0, 19));
            make.height.equalTo(@50);
        }];
        self.lblStatus.textColor = MMHexColor(0x333333FF);
        self.lblStatus.font = [UIFont boldSystemFontOfSize:15];
        self.lblStatus.text = @"请输入交易密码";
        
        
        //
        
        UIView* line_View_1 = [UIView new];
        
        line_View_1.backgroundColor = [UIColor lightGrayColor];
        
        [self.backView addSubview:line_View_1];
        
        [line_View_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.lblStatus.mas_bottom).offset(-10);
            
            make.centerX.equalTo(self.lblStatus);
            
            make.height.equalTo(@0.5);
            
            make.width.equalTo(@210);
            
        }];
        

        
        //
        self.lblStatus.textAlignment = NSTextAlignmentCenter;
        
        UIView *split = [UIView new];
        [self.backView addSubview:split];
        [split mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView);
            make.bottom.equalTo(self.lblStatus.mas_bottom);
            make.height.mas_equalTo(MM_SPLIT_WIDTH);
        }];
        
        self.lblPhone = [UILabel new];
        [self.backView addSubview:self.lblPhone];
        [self.lblPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 19, 0, 19));
            make.top.equalTo(self.lblStatus.mas_bottom).offset(0);
        }];
        self.lblPhone.numberOfLines = 0;
        self.lblPhone.textAlignment = NSTextAlignmentCenter;
        self.lblPhone.font = [UIFont systemFontOfSize:15];
//        self.lblPhone.textColor = MMHexColor(0x999999FF);
        self.lblPhone.textColor = title_Color;
        [self.lblPhone setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        [self.lblPhone setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        //
        
        self.lblPhone.text = [NSString stringWithFormat:@"乡邻红包"];

        //
        self.btnCountDown = [UIButton mm_buttonWithTarget:self action:@selector(actionResend)];
        [self.backView addSubview:self.btnCountDown];
        [self.btnCountDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 19, 0, 19));
            make.bottom.equalTo(self.backView.mas_bottom).offset(-20);
        }];
        self.btnCountDown.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.btnCountDown.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnCountDown setTitleColor:MMHexColor(0x999999FF) forState:UIControlStateDisabled];
        [self.btnCountDown setTitleColor:MMHexColor(0xE76153FF) forState:UIControlStateNormal];
        [self.btnCountDown setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        [self.btnCountDown setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        self.numberView = [UIView new];
        [self.backView addSubview:self.numberView];
        [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.lessThanOrEqualTo(self.lblPhone.mas_bottom);
            make.bottom.greaterThanOrEqualTo(self.btnCountDown.mas_top).offset(30);
            make.centerX.equalTo(self.backView);
            make.width.equalTo(@(220));
        }];
        [self.numberView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        [self.numberView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        self.numberArray = @[[UILabel new],[UILabel new],[UILabel new],[UILabel new],[UILabel new],[UILabel new]];
        
        for ( UILabel *label in self.numberArray )
        {
            [self.numberView addSubview:label];
            
            //修改
            
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = (text_Color).CGColor;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.numberView);
                make.width.height.equalTo(@29.30);
                
            }];
            
            label.font = [UIFont boldSystemFontOfSize:20];
//            label.textColor = MMHexColor(0xE76153FF);
            
            label.textColor = text_Color;
            
            label.textAlignment =  NSTextAlignmentCenter;
//            label.text = @"_";
        }
        
        
        [self.numberView mm_distributeSpacingHorizontallyWith:self.numberArray];
        
        self.tfPin = [UITextField new];
        [self addSubview:self.tfPin];
        self.tfPin.keyboardType = UIKeyboardTypeNumberPad;
        [self sendSubviewToBack:self.tfPin];
        //------------
        
        [self.tfPin addTarget:self action:@selector(pwDidInput:) forControlEvents:UIControlEventEditingChanged];
        
        self.tfPin.delegate = self;
        
        //--------------
        [self startCountDown];
    }
    
    return self;
}


-(void)clear{
    
    for (int i = 0 ; i < 6 ; i++) {
        
        
            UILabel* label = self.numberArray[i];
            label.text = @"";
            
            
            
        }
        
        
        
    self.tfPin.text = @"";
    

    
    
}


-(void)pwDidInput:(UITextField*)textField{
    
    
    int i = (int)self.numberArray.count;
    
    //    self.marked_label.text = [NSString stringWithFormat:@"%td\10",textField.text.length];
    
    if (textField.text.length > i) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return ;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
        textField.text = [textField.text substringToIndex:range.location];
    }
    

    
    
    NSLog(@"%@",textField.text);
    
    NSInteger minNum = MIN(self.numberArray.count, textField.text.length);
    
    for (int i = 0 ; i < 6 ; i++) {
        
        if (minNum <= i) {
            
            
            UILabel* label = self.numberArray[i];
            
            label.text = @"";
        }else{
            
            UILabel* label = self.numberArray[i];
            
            label.text = @"*";

            
            
        }
        
        
        
    }
    
    
    if (minNum == 6) {
        
        
        //结束弹框
//        
//        dispatch_after(
//                       dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
//                       dispatch_get_main_queue(),
//                       ^{
//                           
//                           if (self.superview) {
//                               
//                               [self hide];
//                           }
//                           
//                       }
//                       );
        
        
        if (self.hadInputPWBlock) {
            
            self.hadInputPWBlock(self.tfPin.text,self);
            
        }
        
        
    }
    
}

/*
//限制字数
- (void)textFieldDidChange:(UITextField *)textField
{
    
//    NSArray* arr = @[@0,@10,@20,@0,@0];
    
    int i = (int)self.numberArray.count;
    
    //    self.marked_label.text = [NSString stringWithFormat:@"%td\10",textField.text.length];
    
    if (textField.text.length > i) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
        textField.text = [textField.text substringToIndex:range.location];
    }
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    
    
//    NSArray* arr = @[@0,@10,@20,@0,@0];
    
    int i = (int)self.numberArray.count;
    
    //    self.marked_label.text = [NSString stringWithFormat:@"%td\10",textField.text.length];
    
    if (textField.text.length > i) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return YES;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
        textField.text = [textField.text substringToIndex:range.location];
    }
    

    
    
    
    return YES;
    
}
 
 */
- (void)startCountDown
{
//    [self stopCountDown];
//    
//    self.nCountdown = 30;
//    
//    self.btnCountDown.enabled = NO;
//    
//    [self checkCountDown];
}

- (void)stopCountDown
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkCountDown) object:nil];
}

- (void)checkCountDown
{
//    if ( self.nCountdown == 0 )
//    {
//        self.btnCountDown.enabled = YES;
//        [self.btnCountDown setTitle:@"Resent" forState:UIControlStateNormal];
//    }
//    else
//    {
//        NSString *text = [NSString stringWithFormat:@"Receive in %@ secs", [@(self.nCountdown) stringValue]];
//        
//        [self.btnCountDown setTitle:text forState:UIControlStateDisabled];
//        
//        --self.nCountdown;
//        
//        [self performSelector:@selector(checkCountDown) withObject:nil afterDelay:1 inModes:@[NSRunLoopCommonModes]];
//    }
}


-(void)setMoneyText:(NSString *)moneyText{
    
    _moneyText = moneyText;
    
//    self.lblPhone.text = [NSString stringWithFormat:@"乡邻红包\n\n¥%.2f",[_moneyText doubleValue]];
    
    if (!self.amount_label) {
        
        
        UILabel* label =  [UILabel labelWithText:[NSString stringWithFormat:@"¥%.2f",[_moneyText doubleValue]] andColor:title_Color andFontSize:24 andSuperview:self.backView];
        
        self.amount_label = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.lblPhone.mas_bottom);
            
            make.centerX.equalTo(self.lblPhone);
        }];
        
        
        
    }
    
    
    
    businessPopCell * cell =  [[[NSBundle mainBundle]loadNibNamed:@"businesspopView" owner:nil options:nil] firstObject];
    
    [self.backView addSubview:cell];
    
//    cell.backgroundColor = [UIColor redColor];
    
    
    UIView* line_View_1 = [UIView new];
    
    line_View_1.backgroundColor = [UIColor lightGrayColor];
    
    [self.backView addSubview:line_View_1];
    
    [line_View_1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.amount_label.mas_bottom).offset(5);
        
        make.centerX.equalTo(self.lblPhone);
        
        make.height.equalTo(@0.5);
        
        make.width.equalTo(@210);

    }];
    
    
    UIView* line_View_2 = [UIView new];
    
    line_View_2.backgroundColor = [UIColor lightGrayColor];
    
    [self.backView addSubview:line_View_2];
    
    [line_View_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cell.mas_bottom);
        
        make.centerX.equalTo(self.lblPhone);
        
        make.height.equalTo(@0.5);
        
        make.width.equalTo(@210);
        
    }];

    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMyAmount)];
    
    [cell addGestureRecognizer:tap];
    
//    cell.amount_label.text = [NSString stringWithFormat:@"账户余额(剩余%.2lf元)",[self.restAmount doubleValue] ];
    
    NSString* str = [NSString stringWithFormat:@"账户余额(剩余%.2lf元)",[self.restAmount doubleValue] ];
    
    
//    NSAttributedString* attibuteStr = [NSString stringWithFormat:@"账户余额(剩余%.2lf元)",[self.restAmount doubleValue] ];
    
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
//        [AttributedStr addAttribute:NSFontAttributeName
//    
//                              value:[UIFont systemFontOfSize:13.0]
//    
//                              range:NSMakeRange(label.text.length - 1, 1)];
    
    
//        NSUInteger u = label.text.length;
    
//        [AttributedStr addAttributes:@{NSForegroundColorAttributeName :title_Color}
//                               range:NSMakeRange(0, 4)];
    
    [AttributedStr addAttributes:@{NSForegroundColorAttributeName :RGB(102, 102, 102, 1)}
                           range:NSMakeRange(4, str.length - 4)];
    
        cell.amount_label.attributedText = AttributedStr;

    
    
    
    
    
//    cell.amount_label.textColor = text_Color;
    
    
    [cell.amount_label sizeToFit];
    
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.amount_label.mas_bottom).offset(10);
        
        make.centerX.equalTo(self.lblPhone);
        
//        make.bottom.equalTo(self.numberView.mas_top);
        
        make.height.equalTo(@30);
        
        make.width.equalTo(@210);
        
        
        
    }];
    
    
}


-(void)touchMyAmount
{
    
    

    return;
    
    
    WYWebController*first=[WYWebController new];
    first.hidesBottomBarWhenPushed=YES;
    NSDictionary*loginInfodic =[[XLPlist sharePlist]getPlistDicByAppendPlistRoute:proactiveLogin];

    first.urlstr=[NSString stringWithFormat:@"%@/home/network/nodeManager/accountBalance.html?markFlag=true&mobilePhone=%@",ENV_H5CAU_URL,[loginInfodic objectForKey:@"mobilePhone"]];
    NSLog(@"---account---%@",first.urlstr);
    
    first.close_blcok = ^(){
        
        
        [self show];
        
    };
    
    [self.vc.navigationController pushViewController:first animated:YES];
    
    
    [self hide];

}


- (void)actionClose
{
    [self hide];
}

- (void)actionResend
{
    [self startCountDown];
}

- (void)showKeyboard
{
    [self.tfPin becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.tfPin resignFirstResponder];
}

@end
