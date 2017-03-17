//
//  RewordView.m
//  XXProjectNew
//
//  Created by apple on 2016/11/11.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "RewordView.h" 
@interface RewordView ()<UITextFieldDelegate>
{
    BOOL _hasDot;
}




@end
@implementation RewordView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 10.f;
    self.bgView.clipsToBounds = YES;
    self.reword.layer.cornerRadius = 20.f;
    self.reword.clipsToBounds = YES;
    self.textField.enabled = NO;
    self.textField.delegate = self;
    self.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    self.bgView.cancelsTouchesInView = YES;
    
}
+(instancetype)rewordView
{
    return [[NSBundle mainBundle] loadNibNamed:@"RewordView" owner:nil options:nil].lastObject;
}
- (IBAction)close:(UIButton *)sender {
    self.textField.text = @"0.88";
    [sender setTitle:@"修改金额" forState:UIControlStateNormal];
    self.reword.backgroundColor = blueColor;
    [self removeFromSuperview];
}
- (IBAction)modify:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"修改金额"]) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        self.textField.enabled = YES;
        self.textField.text = @"";
        self.reword.enabled = NO;
        self.reword.backgroundColor = RGB(204, 204, 204, 1);
        [self.textField becomeFirstResponder];
    } else {
//        if ([self.textField.text isEqualToString:@""]) {
            self.textField.text = @"0.88";
//        }
        self.reword.enabled = YES;
        self.reword.backgroundColor = blueColor;
        self.textField.enabled = NO;
        [sender setTitle:@"修改金额" forState:UIControlStateNormal];
        [self.textField resignFirstResponder];
    }
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@--%@",textField.text,string);
    NSString *text = [textField.text stringByAppendingString:string];
    if ([text floatValue] > 200.00) {
        [self invalidInput];
        [[NoticeTool notice] showTips:@"打赏最高金额为200元" onView:self];
        return NO;
    }
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _hasDot = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [self invalidInput];
                    [[NoticeTool notice]showTips:@"第一个数字不能为小数点" onView:self];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }

            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_hasDot)//text中还没有小数点
                {
                    _hasDot = YES;
                    return YES;
                    
                }else{
                    [self invalidInput];
                    [[NoticeTool notice]showTips:@"您已经输入过小数点了" onView:self];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_hasDot) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [self invalidInput];
                        [[NoticeTool notice] showTips:@"最多输入两位小数" onView:self];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
    
        }else{//输入的数据格式不正确
//            [self showError:@"亲，您输入的格式不正确"];
            [self invalidInput];
            [[NoticeTool notice] showTips:@"您输入的格式不正确" onView:self];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0.88";
        [self.modifyBtn setTitle:@"修改金额" forState:UIControlStateNormal];
    }
    self.reword.enabled = YES;
    self.reword.backgroundColor = blueColor;
    self.textField.enabled = NO;
    [textField resignFirstResponder];
    return YES;
}
-(void)invalidInput
{
    [self.textField resignFirstResponder];
    self.textField.text = @"0.88";
    [self.modifyBtn setTitle:@"修改金额" forState:UIControlStateNormal];
    self.textField.enabled = NO;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.textField.text = @"0.88";
//    [self endEditing:YES];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
