//
//  SubSAViewController.m
//  XXProjectNew
//
//  Created by apple on 12/2/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "SubSAViewController.h"
#import "StationAgentViewModel.h"
#import "StationAgentModel.h"

@interface SubSAViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSArray* title_arr;
@property(nonatomic,weak)UITextField* field;
@property(nonatomic,weak)UILabel* marked_label;
@property(nonatomic,weak)UITableView* tableView;
@property(nonatomic,strong)NSArray<UIButton*>* gender_btn_arr;
@end

@implementation SubSAViewController

-(NSArray*)gender_btn_arr{
    
    
    if (!_gender_btn_arr) {
        
        
        _gender_btn_arr = @[];
        
    }
    
    
    return _gender_btn_arr;
}


-(NSArray*)title_arr{
    
    
    if (!_title_arr) {
        
    self.title_arr  = @[@"",@"昵称",@"一句话介绍",@"性别",@"手机号"];

    }
    
    
    return _title_arr;
}


//-(UILabel*)marked_label{
//    
//    
//    if (!_marked_label) {
//        
//    UILabel* label = [UILabel labelWithText:@"10个字以内" andColor:text_Color andFontSize:12 andSuperview:nil];
//        
//        _marked_label = label;
//        
//    }
//    
//    
//    return _marked_label;
//}


-(UITextField*)field{
    
    
    if (!_field) {
        
        UITextField* temp = [UITextField new];
        
        temp.textColor = title_Color;
        
        
        NSString* nickName =  [StationAgentViewModel model].dataModel.nikerName;
        NSString* introduce = [StationAgentViewModel model].dataModel.introduce;
        
        
        
        if (self.type == 2) {
            
            temp.placeholder = @"用一句话来介绍你自己";

            
            if ([introduce isEqualToString:@"用一句话来介绍你自己"]) {
                
                
//                temp.placeholder =  self.type == 1 ? nickName:introduce;
                
                //            temp.text = @"";
                
            }else{
                
                temp.text =  self.type == 1 ? nickName:introduce;
            }

            
            
            
            
        }else{
            
            temp.placeholder = @"请设置昵称";
            
            if ([nickName isEqualToString:@"请设置昵称"]) {
                
                
//                temp.placeholder =  self.type == 1 ? nickName:introduce; 
                
                
            }else{
                
                
                temp.text =  self.type == 1 ? nickName:introduce;
            }

            
            
        }
        
        
        
        
    
        
      
        
        
        
        
        temp.delegate = self;//因此没有因为没有强指针而释放掉
        
        temp.font = [UIFont systemFontOfSize:text_Size];
        
        _field = temp;
        
    }
    
    
    return _field;
}


+(instancetype)customForType:(Type)type{
    
   SubSAViewController* sub = [[SubSAViewController alloc]init];
    
    sub.type = type;
    
    return sub;
    
}


-(void)loadView{
    
    UITableView* tableView =  [[UITableView alloc]init];
    
    self.tableView = tableView;
    
//    tableView.backgroundColor = gray_backgound;
    
//    tableView.backgroundColor = [UIColor redColor];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSArray* arr = @[@0,@80,@80,@49,@0];
    
    tableView.rowHeight = [arr[self.type] intValue];
    
    self.view = tableView;
    
    
    
    //公共部分
    
    
    UIButton* btn = [UIButton buttonWithText:@"保存" andColor:RGB(103, 105, 105, 1) andFontSize:16 andSuperview:nil];
    
    [btn sizeToFit];
    
    [btn setTitleColor:RGB(103, 105, 105, 0.3) forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(saveBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];


}


//保存并且上传
#pragma mark 保存

-(void)saveBtnDidClick{
    
    
    __weak typeof(self) weakSelf = self;

    
    void(^block)(BOOL) = ^(BOOL sucess) {
        
        if (sucess) {
            
            //提示成功
            [[NoticeTool notice] showTips:@"保存成功!" onView:weakSelf.view];
    
            
        }else{
            
            //提示错误
            [[NoticeTool notice] showTips:@"保存失败!" onView:weakSelf.view];

            
        }
        
        
        //保存返回上个界面
        
        dispatch_after(
                       dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(),
                       ^{
                           
                           
                           [weakSelf.navigationController popViewControllerAnimated:YES];
                           
                       }
                       );
        
    };
    
    switch (self.type) {
        case TypeNickname:{
            
            if (self.field.text.length < 2) {
                
                [self.field resignFirstResponder];

                 [[NoticeTool notice] showTips:@"至少输入2个字符!" onView:self.view];
                
                return;
            }
         
            
             [[StationAgentViewModel model] saveAndUpdataWithType:self.type para:self.field.text andSuccess:block];
        }
            
            break;
            
        case TypeIntroduce:{
            
            if (self.field.text.length < 4) {

                [self.field resignFirstResponder];

                
                [[NoticeTool notice] showTips:@"至少输入4个字符!" onView:self.view];
                
                
                return;
            }

            
            
            [[StationAgentViewModel model] saveAndUpdataWithType:self.type para:self.field.text andSuccess:block];
            
            
        }
            
            break;

        case TypeGender:
            
        { NSString* str = (self.gender_btn_arr[0].selected == YES ? @"男":@"女");
            
            [[StationAgentViewModel model] saveAndUpdataWithType:self.type para:str andSuccess:block];
        }
            break;
        default:
            break;
    }
    
     [self.field resignFirstResponder];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.title_arr[self.type];
    
    //原本loadView 里设置有效,但是不知为何出问题了 ,于是在Didload 里设置
    
    self.tableView.backgroundColor = gray_backgound;
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.field becomeFirstResponder];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSArray* arr = @[@0,@1,@1,@2,@0];
    
    return [arr[self.type] intValue];
    
}


#pragma mark 显示cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    tableView.separatorStyle = 0;
    
    
    
    
    if (self.type == 1 || self.type == 2) {
    
    UILabel* label = [UILabel labelWithText:[NSString stringWithFormat:@"%td个字以内",self.type*10] andColor:text_Color andFontSize:12 andSuperview:cell];
    
    self.marked_label = label;
    
    [cell addSubview:self.field];
    

        
    [self.marked_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(cell.contentView).offset(-10);
        
        make.bottom.equalTo(cell.contentView).offset(-10);
    }];
    
        
    [self.field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.contentView).offset(10);
        
        make.right.equalTo(cell.contentView).offset(-10);
        
        make.top.equalTo(cell).offset(10);
        
        make.height.equalTo(@30);
        
    }];
    
        
    
    }else if (self.type == 2){
        
        
        
        
        
        
        
        
        
        
    
    }else if (self.type == 3){
        
        
        cell.selectionStyle = 1;//没用?
        
        NSString* gender  =  indexPath.row == 0? @"男":@"女";
        UILabel* label=  [UILabel labelWithText:gender andColor:title_Color andFontSize:14 andSuperview:cell];
        
        UIButton* btn = [UIButton buttonWithText:nil andColor:nil andFontSize:0 andSuperview:cell];
        
        
       NSString* gender_From_data = [StationAgentViewModel model].dataModel.sex;
        
        
        if ([gender_From_data isEqualToString:@"男"] && indexPath.row == 0 ) {
            
            btn.selected = YES;
            
        }else if ([gender_From_data isEqualToString:@"女"] && indexPath.row == 1 ){
            
            btn.selected = YES;
            
        }else{
            
            btn.selected = NO;
        }
        
        
        NSMutableArray* arr = self.gender_btn_arr.mutableCopy;
        
        [arr addObject:btn];
        
        self.gender_btn_arr = arr.copy;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn.mas_right).offset(10);
        }];
        
        [btn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        
        btn.userInteractionEnabled = NO;
        
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.offset(15);
            make.centerY.equalTo(cell.contentView);
            
            make.size.mas_equalTo(CGSizeMake(20, 20));
            
        }];
        
        
        
    }
    
    return cell;
    
}


//选择

#pragma mark 点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    
    
    if (self.type == TypeGender) {
        
        
        if (indexPath.row) {
            
            self.gender_btn_arr[0].selected = NO;
            
            self.gender_btn_arr[1].selected = YES;
            
            
        }else{
            
            self.gender_btn_arr[1].selected = NO;
            
            self.gender_btn_arr[0].selected = YES;
            
            
        }
        
        
    }
    
    
    
    
}







//限制字数
- (void)textFieldDidChange:(UITextField *)textField
{
    
    NSArray* arr = @[@0,@10,@20,@0,@0];

    int i = [arr[self.type] intValue];
    
    
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

@end
