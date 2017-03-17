//
//  CalculateController.m
//  XXProjectNew
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "CalculateController.h"

@interface CalculateController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    BOOL isHaveDian ;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aspect;
@property (weak, nonatomic) IBOutlet UIButton *earnClearBtn;
@property (weak, nonatomic) IBOutlet UIButton *earnCalcuBtn;
@property (weak, nonatomic) IBOutlet UIButton *storageClarnBtn;
@property (weak, nonatomic) IBOutlet UIButton *storageCalcuBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *viewOn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UITextField *textFld1;
@property (weak, nonatomic) IBOutlet UITextField *textFld2;
@property (weak, nonatomic) IBOutlet UITextField *textFld3;
@property (weak, nonatomic) IBOutlet UITextField *textFld4;
@property (weak, nonatomic) IBOutlet UIImageView *explainImgView;
@property (weak, nonatomic) IBOutlet UITextField *textFld5;
@property (weak, nonatomic) IBOutlet UITextField *textFld6;
@property (weak, nonatomic) IBOutlet UILabel *earnValueLab;
@property (weak, nonatomic) IBOutlet UILabel *storerageValueLab;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UILabel *myAlertLabel;
@end

@implementation CalculateController
-(UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    }
    return _tap;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.textFld2 || textField == self.textFld5) {
        NSString *text = [textField.text stringByAppendingString:string];
        if ([text integerValue] > 1000) {
            [textField resignFirstResponder];
            textField.text = @"";
            [self showAlertWithTips:@"利率不能大于1000"];
            return NO;
        }
    }
    if (textField!=self.textFld2&&textField!=self.textFld5) {
        
        if([textField.text length] == 0){
            unichar single = [string characterAtIndex:0];//当前输入的字符

            if(single == '.') {
                [self showError:@"亲，第一个数字不能为小数点"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
            if (single == '0') {
                [self showError:@"亲，第一个数字不能为0"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }

        return [self validateNumber:string];

    }else
    {
        
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        NSLog(@"string===%lu",(unsigned long)string.length);
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [self showError:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [self showError:@"亲，您已经输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 3) {
                            return YES;
                        }else{
                            [self showError:@"亲，您最多输入两位小数"];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [self showError:@"亲，您输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }

    }
    return NO;
}
- (void)showError:(NSString *)errorString
{
//    [(AppDelegate *)[UIApplication sharedApplication].delegate showErrorView:errorString];
//    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeErrorView2) userInfo:nil repeats:NO];
//    
//    [self.moneyTf resignFirstResponder];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"------%d", (int)(scrollView.contentOffset.x/scrollView.frame.size.width));
    float a=scrollView.contentOffset.x/scrollView.frame.size.width;
    int b=(int)a;
    self.seg.selectedSegmentIndex=b;
    NSLog(@"self.seg.selectedSegmentIndex===%ld",(long)self.seg.selectedSegmentIndex);
    
//    if(self.seg.selectedSegmentIndex==0)
//    {
//        [self.textFld1 becomeFirstResponder];
//
//    }else
//    {
//        [self.textFld4 becomeFirstResponder];
//
//    }

    


}
- (IBAction)backPress:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)segChange:(UISegmentedControl *)sender {
    

    if (sender.selectedSegmentIndex==0) {
        [self.scroll scrollRectToVisible:CGRectMake(0, 0, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
        NSLog(@"赚");
//        [self.textFld1 becomeFirstResponder];

    }else
    {
        [self.scroll scrollRectToVisible:CGRectMake(self.scroll.frame.size.width, 0, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
        NSLog(@"存");
//        [self.textFld4 becomeFirstResponder];

    }
}


//赚钱--清空
- (IBAction)earnClear:(UIButton *)sender {
    self.textFld1.text=@"";
    self.textFld2.text=@"";
    self.textFld3.text=@"";
    
    
//    NSMutableString *str1 = (NSMutableString *)[self countNumAndChangeformat:arr.firstObject];
//    [str1 appendString:[NSString stringWithFormat:@".%@",arr.lastObject]];
    
    self.earnValueLab.text=  [NSString stringWithFormat:@"预计我能赚 %@ 元 ",@"0"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.earnValueLab.text];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,self.earnValueLab.text.length-7)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(5, self.earnValueLab.text.length-7)];
    

    self.earnValueLab.attributedText=str;

   
}




#pragma mark "改变赚钱的富文本"
- (IBAction)earnRightNowCalcu:(UIButton *)sender {
    if ([self.textFld1.text isEqualToString:@""]) {
        [self showAlertWithTips:@"请输入存款金额"];
    }else if ([self.textFld2.text isEqualToString:@""]) {
        [self showAlertWithTips:@"请输入评价收益率"];
    }else if ([self.textFld3.text isEqualToString:@""]) {
        [self showAlertWithTips:@"请输入存款期限"];
    }
    self.earnValueLab.adjustsFontSizeToFitWidth = YES;
//    if (self.textFld1.text.length>11) {
//        self.earnValueLab.text=@"钱太多了，装不下了～～";
//        self.earnValueLab.textColor=[UIColor redColor];
//    }
    float value=[self.textFld1.text floatValue]*10000*[self.textFld2.text floatValue]/1000*([self.textFld3.text floatValue]/12);
    if (value < 0.01) {
        if (value != 0) {
            self.earnValueLab.text= @"计算超出范围了，请输入合理的数值哦";
            self.earnValueLab.textColor = [UIColor redColor];
        }
        
    }else if (value >= 1000000000000){
        self.earnValueLab.text= @"钱太多了，装不下了～～";
        self.earnValueLab.textColor = [UIColor redColor];
    }else{
//        NSString *valueStr=[NSString stringWithFormat:@"%f",value];
        NSString *result = [NSString stringWithFormat:@"%.2lf 元",value];
        if ([result rangeOfString:@"."].location != NSNotFound) {
            NSArray *arr = [result componentsSeparatedByString:@"."];
            
            NSMutableString *str1 = (NSMutableString *)[self countNumAndChangeformat:arr.firstObject];
            [str1 appendString:[NSString stringWithFormat:@".%@",arr.lastObject]];
            self.earnValueLab.text=  [NSString stringWithFormat:@"预计我能赚 %@ ",str1];
//            self.earnValueLab.textColor = RGB(255, 0, 0, 1);
        }
//        self.earnValueLab.text=[NSString stringWithFormat:@"预计我能赚%.2lf元",value];
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.earnValueLab.text];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,self.earnValueLab.text.length-7)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(5, self.earnValueLab.text.length-7)];
        
//         [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16] range:NSMakeRange(5, self.earnValueLab.text.length-6)];
        self.earnValueLab.attributedText=str;
    }

}

-(void)showAlertWithTips:(NSString *)tips
{
    self.myAlertLabel=[[UILabel alloc] initWithFrame:CGRectMake((screenWidth-150)/2, screenHeight-49-60, 150, 30)];  //起始高度设的大点
    self.myAlertLabel.text= tips;
    self.myAlertLabel.layer.cornerRadius=6;
    self.myAlertLabel.layer.masksToBounds = YES;
    
    
    self.myAlertLabel.font=[UIFont systemFontOfSize:14];
    self.myAlertLabel.textAlignment=NSTextAlignmentCenter;
    UIWindow *widow = [[UIApplication sharedApplication].delegate window];
    [widow addSubview:self.myAlertLabel];
    self.myAlertLabel.textColor=[UIColor whiteColor];
    self.myAlertLabel.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:1  //动画时间
                          delay:3  //开始延迟时间
                        options: UIViewAnimationCurveEaseOut  //弹入弹出
                     animations:^{
                         //                             self.myAlertLabel.frame = CGRectMake(100, self.view.frame.size.height, 200, 15);  //终止高度设的小于起始高度
                         self.myAlertLabel.alpha=0;
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.myAlertLabel removeFromSuperview];  //移动后隐藏
                     }];

}

//存钱清空

- (IBAction)storageClear:(UIButton *)sender {
    self.textFld4.text=@"";
    self.textFld5.text=@"";
    self.textFld6.text=@"";
//    [self.textFld4 becomeFirstResponder];
    
    self.storerageValueLab.text=  [NSString stringWithFormat:@"预计我要存 %@ 万元 ",@"0"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.storerageValueLab.text];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(5, 2)];
    
    
    self.storerageValueLab.attributedText=str;

    
    
    
    
    
}
- (IBAction)storageNowCalcu:(id)sender {
    if ([self.textFld4.text isEqualToString:@""]) {
        [self showAlertWithTips:@"请输入我想赚多少钱"];
//        [self resetValueLab:@"预计我要存0万元"] ;
    }else if ([self.textFld5.text isEqualToString:@""]) {
        [self showAlertWithTips:@"请输入年均收益率"];
//        [self resetValueLab:@"预计我要存0万元"] ;
    }else if ([self.textFld6.text isEqualToString:@""]) {
        [self showAlertWithTips:@"请输入存款期限"];
//        [self resetValueLab:@"预计我要存0万元"] ;
    }
//    else if (self.textFld4.text.length>11) {
//        self.storerageValueLab.text=@"钱太多了，装不下了～～";
//        self.storerageValueLab.textColor=[UIColor redColor];
//    }
    else{
        NSLog(@"%f-%f-%f",[self.textFld4.text floatValue],[self.textFld5.text floatValue],[self.textFld6.text floatValue]);
        NSDecimalNumberHandler*roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp
                                          scale:2
 
                                          raiseOnExactness:NO
                                          
                                          raiseOnOverflow:NO
                                          
                                          raiseOnUnderflow:NO
                                          
                                          raiseOnDivideByZero:YES];
        NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:self.textFld4.text];
        NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:self.textFld5.text];
        NSDecimalNumber *c = [NSDecimalNumber decimalNumberWithString:self.textFld6.text];
        NSDecimalNumber *d = [NSDecimalNumber decimalNumberWithString:@"1000"];
        NSDecimalNumber *tw = [NSDecimalNumber decimalNumberWithString:@"12.00"];
        NSDecimalNumber *w = [NSDecimalNumber decimalNumberWithString:@"10000"];
        NSDecimalNumber *r1 = [a decimalNumberByDividingBy:b];
        NSDecimalNumber *r2 = [r1 decimalNumberByMultiplyingBy:d];
        NSDecimalNumber *r3 = [tw decimalNumberByDividingBy:c];
        NSDecimalNumber *r4 = [r2 decimalNumberByMultiplyingBy:r3];
        NSDecimalNumber *r = [r4 decimalNumberByDividingBy:w];
//        int a = [self.textFld4.text intValue];
//        float b = [self.textFld5.text floatValue];
//        int c = [self.textFld6.text intValue];
//        float v = ((a/b*1000)*(12/c));///10000;
//        double value= (([self.textFld4.text intValue]/[self.textFld5.text floatValue] * 1000)*(12/[self.textFld6.text intValue]))/10000;
        NSLog(@"%f",[r floatValue]);
        float value = [r floatValue];
        if (value < 0.01) {
            self.storerageValueLab.text= @"计算超出范围了，请输入合理的数值哦";
            self.storerageValueLab.textColor = [UIColor redColor];
        }else if (value >= 100000000000000){
            self.storerageValueLab.text= @"钱太多了，装不下了～～";
            self.storerageValueLab.textColor = [UIColor redColor];
        }else{
            NSString *result = [NSString stringWithFormat:@"%.2lf",value];
            if ([result rangeOfString:@"."].location != NSNotFound) {
                NSArray *arr = [result componentsSeparatedByString:@"."];
                
                NSMutableString *str1 = (NSMutableString *)[self countNumAndChangeformat:arr.firstObject];
                [str1 appendString:[NSString stringWithFormat:@".%@",arr.lastObject]];
                NSString *value = [NSString stringWithFormat:@"预计我要存 %@ 万元",str1];

                self.storerageValueLab.text= value;
                [self resetValueLab:self.storerageValueLab.text];
            }

//            NSString*valueStr =[NSString stringWithFormat:@"预计我要存%.2lf万元",value];
            
        }
    }

}
#pragma mark "点击后改变存款数的富文本"
-(void)resetValueLab:(NSString *)value
{
    self.storerageValueLab.text= value;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.storerageValueLab.text];
    self.storerageValueLab.textColor = RGB(44, 44, 44, 1);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,self.storerageValueLab.text.length-7)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(5, self.storerageValueLab.text.length-7)];
    self.storerageValueLab.attributedText=str;
}

-(void)setupUI{
    
    self.viewOn.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.scroll.layer.cornerRadius=5;
//    self.viewOn.backgroundColor=RGB(238,238,238,1.0f);
    self.earnClearBtn.backgroundColor=RGB(114, 212, 255, 1);
    self.earnCalcuBtn.backgroundColor=RGB(85, 170, 255, 1);
    self.storageClarnBtn.backgroundColor=RGB(114, 212, 255, 1);
    self.storageCalcuBtn.backgroundColor=RGB(85, 170, 255, 1);
    self.earnClearBtn.layer.cornerRadius=7;
    self.earnCalcuBtn.layer.cornerRadius=7;
    self.storageClarnBtn.layer.cornerRadius=7;
    self.storageCalcuBtn.layer.cornerRadius=7;
    self.scroll.delegate=self;
    NSLog(@"---self.scroll.contentSize===%@===viewOnScr===%@",NSStringFromCGRect(self.scroll.frame),NSStringFromCGRect(self.viewOn.frame) );
    self.textFld1.delegate=self;
    self.textFld2.delegate=self;
    self.textFld3.delegate=self;
    self.textFld4.delegate=self;
    self.textFld5.delegate=self;
    self.textFld6.delegate=self;
//    self.textFld1.keyboardType = UIKeyboardTypeNumberPad;
//    self.textFld2.keyboardType = UIKeyboardTypeNumberPad;
//    self.textFld3.keyboardType = UIKeyboardTypeNumberPad;
//
//    self.textFld4.keyboardType = UIKeyboardTypeNumberPad;
//    self.textFld5.keyboardType = UIKeyboardTypeNumberPad;
//    self.textFld6.keyboardType = UIKeyboardTypeNumberPad;

    

//    self.viewOn.backgroundColor=[UIColor whiteColor];

//    UILabel*planEarnlabel=[[UILabel alloc]init];
//    planEarnlabel.text=@"显示收益为0时，并不代表真实收益为0，有可能是收益还未导入系统";
//    planEarnlabel.numberOfLines=0;
//    planEarnlabel.font=[UIFont systemFontOfSize:16];
//    planEarnlabel.lineBreakMode=NSLineBreakByWordWrapping;
//    //        label.textAlignment=NSTextAlignmentCenter;
//    CGSize size=CGSizeMake(0.8*screenWidth, 4);
//    CGSize expectSize=[planEarnlabel sizeThatFits:size];
//    //        label.textColor=RGB(47, 150, 255, 1);
//    planEarnlabel.frame=CGRectMake(0.144*screenWidth, 0.179*frame.size.height, expectSize.width, expectSize.height);
//    
//    [self.viewOn addSubview:planEarnlabel];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.earnValueLab.text];
#pragma mark "展示富文本"
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,self.earnValueLab.text.length-6)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(5, self.earnValueLab.text.length-6)];
//      [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16] range:NSMakeRange(5, self.earnValueLab.text.length-6)];
    
    self.earnValueLab.attributedText=str;
    NSMutableAttributedString *str11 = [[NSMutableAttributedString alloc] initWithString:self.storerageValueLab.text];
    
    [str11 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,self.storerageValueLab.text.length-7)];
    [str11 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(5, self.storerageValueLab.text.length-7)];
    self.storerageValueLab.attributedText=str11;
    
    #pragma mark "说明"
        UILabel*explainlabel=[[UILabel alloc]init];
        explainlabel.text=@"     说明：以上计算为乡邻小站银行业绩预估，非站长个人银行存款，实际收益请以系统数据为准.";
        explainlabel.numberOfLines=0;
        explainlabel.textColor=RGB(153, 153, 153, 1);
        explainlabel.font=[UIFont systemFontOfSize:13];
        explainlabel.lineBreakMode=NSLineBreakByWordWrapping;
        //        label.textAlignment=NSTextAlignmentCenter;
//        CGSize size=CGSizeMake(0.74*screenWidth, 4);
//        CGSize expectSize=[explainlabel sizeThatFits:size];
        //        label.textColor=RGB(47, 150, 255, 1);
//        explainlabel.frame=CGRectMake(0.157*screenWidth, 0.844*screenHeight, expectSize.width, expectSize.height);
    
    [self.view addSubview:explainlabel];
    
    [explainlabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.explainImgView);
        make.right.equalTo(self.scroll);
        make.top.equalTo(self.explainImgView);
        
    }];
    
    
    #pragma mark "修改行间距"
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:explainlabel.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle1 setLineSpacing:5];
    
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [explainlabel.text length])];
    [explainlabel setAttributedText:attributedString1];
    
    [explainlabel sizeToFit];
    
    
    
    

    [self.viewOn addGestureRecognizer:self.tap];


    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)endEdit
{
    [self.view endEditing:YES];
}
-(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
