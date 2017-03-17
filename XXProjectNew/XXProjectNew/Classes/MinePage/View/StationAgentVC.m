//
//  StationAgentVC.m
//  XXProjectNew
//
//  Created by apple on 2016/11/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "StationAgentVC.h"
#import "StationAgentCell.h"
#import "StationAgentViewModel.h"
#import "StationAgentModel.h"
#import "SubSAViewController.h"
#import "ModifyPhoneNumVC.h"



@interface StationAgentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *titleArr_0;
@property(nonatomic,strong)NSArray *titleArr_1;


@property(nonatomic,strong)StationAgentViewModel* model;

@property(nonatomic,strong)NSMutableArray* logLabel_arr;


@property(nonatomic,assign)BOOL transiting;

@property(nonatomic,weak)UIImageView* icon_imgV;

@end
static NSString *ID = @"StationAgentCell";
@implementation StationAgentVC


-(StationAgentViewModel*)model{
    
    
    if (!_model) {
        
        StationAgentViewModel* temp = [StationAgentViewModel model];
        
        _model = temp;
        
    }
    
    
    return _model;
}


-(NSMutableArray*)logLabel_arr{
   
    if (!_logLabel_arr) {
        
        _logLabel_arr = [NSMutableArray new];
    }
    
    return _logLabel_arr;
    
}




-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //每次进来都刷新
    
    [self.model obtainWebDataWithSuccess:^{
        
        [self.tableView reloadData];

    } andFinished:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    if ([MinePageViewModel model].user == administrator) {
        
        self.title = @"站长个人信息";
        
    }else{
        
        self.title = @"个人信息";
        
    }
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    _titleArr = @[@"姓名",@"角色",@"性别",@"身份证号",@"手机号",@"微信号"];
    
        self.titleArr_0 = @[@"头像",@"昵称",@"一句话介绍",@"性别",@"手机号"];
        self.titleArr_1 = @[@"姓名",@"性别",@"手机号",@"身份证号"];
    
    
    [self setupTableView];
    

    
    
//    [self.model obtainWebDataWithSuccess:^{
//        
//        [self.tableView reloadData];
//        
//        
//    } andFinished:^{
//        
//        
////        [self.tableView headerEndRefreshing];
//    }];
    
    
    [self setBackBtn];
    
    //下拉刷新
    
    
    
}

-(void)setupTableView{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StationAgentCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.tableView.tableFooterView.backgroundColor =  RGB(240, 239, 244, 1);

    
    self.tableView.backgroundColor = RGB(237, 238, 239, 1);
    
    
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone ;
    
    //自动行高?
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    //不可点击
    
    
    
    //站长表头
    
    
    if ([MinePageViewModel model].user == administrator) {
        
        [self setupTableHeaderView];
        
    }
    
    
}

-(void)setupTableHeaderView{
    
    
    
    UIView* view = [UIView new];
    
    view.frame = CGRectMake(0, 0, 0, 49);
    
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel* title = [UILabel labelWithText:@"小站名称" andColor:title_Color andFontSize:text_Size andSuperview:view];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(view);
        
        make.left.equalTo(view).offset(15);
        
    }];
    
    
    //取登录信息
    
    NSDictionary*proactiveLoginDic =  [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    
    
    NSString* nodeName = [proactiveLoginDic valueForKey:@"nodeName"];
    
//    NSString* nodeManagerPartyId = [proactiveLoginDic valueForKey:@"nodeManagerPartyId"];
    
    
    UILabel* webBranch = [UILabel labelWithText:nodeName andColor:text_Color andFontSize:12 andSuperview:view];
    
    [webBranch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(view);
        
        make.left.equalTo(title.mas_right);
        
        make.right.equalTo(view).offset(-33);
        
    }];
    
    
    
    
    
    self.tableView.tableHeaderView = view;
    

    
    
}




-(NSAttributedString *)attributedBodyTextAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSString *text = self.model.logArr[indexPath.row];
    
    UIFont *font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
    
    NSDictionary *testDic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:testDic];
    
    return string;
    
}





#pragma mark -
#pragma mark tableView delegate

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    if ([MinePageViewModel model].user == administrator) {
        
        return 2;
        
    }
    #pragma mark 如果是认证 则多返回一组数据
    
//    NSDictionary*proactiveLoginDic = [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
//    

    if (self.model.dataModel.name.length && self.model.dataModel.idNumber.length){
        
        
        return 2;
    }


    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([MinePageViewModel model].user == administrator) {
        
        if (section == 0) {
            
            return ad_section_0_rowCount;
            
        }else if (section == 1){
            
            return ad_section_1_rowCount;
            
        }
        
        
    }

#pragma mark 如果村民 并且认证
    
    
//    NSDictionary*proactiveLoginDic = [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
//    
    if (self.model.dataModel.name.length && self.model.dataModel.idNumber.length){
//
        if (section == 0) {
            
            return ad_section_0_rowCount;
            
        }else if (section == 1){
            
            return ad_section_1_rowCount;
            
        }
//
//
    }
    
    
    
    
    return vi_section_0_rowCount ;
    
    
    //log
//    if (section == 2) {
//        return self.logArr.count;
//    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //自适应label行高 ,注意还要自定义一个方法
    
    if (indexPath.section == 2) {
        
        
        CGFloat labelWidth = self.tableView.bounds.size.width - 20;
        
        NSAttributedString *test = [self attributedBodyTextAtIndexPath:indexPath];
        
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
        
        CGRect rect = [test boundingRectWithSize:CGSizeMake(labelWidth, 0) options:options context:nil];
        
        return (CGFloat)(ceil(rect.size.height) + 20);
        
        
        
    }
    
    
    return 40.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(section == 2){
        
        return 30;
    }
    
    return 10;
}
#pragma mark Present cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationAgentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separate_line.hidden = NO;
    
    
    cell.spot.hidden = YES;
    
    cell.rect.hidden = YES;
    
    cell.icon_imgV.hidden = YES;
  
    cell.title.textColor = title_Color;
    
    cell.detail.textColor = text_Color;
    
    cell.title.font = [UIFont systemFontOfSize:text_Size];
    
    cell.detail.font = [UIFont systemFontOfSize:text_Size];
    
    
    
    
    
    //设置最后一个cell的分割线
    
    if ([MinePageViewModel model].user == administrator) {
        
        if ((indexPath.section == 0 && indexPath.row == ad_section_0_rowCount-1) || (indexPath.section == 1 && indexPath.row == ad_section_1_rowCount-1) ) {
            
            [cell.separate_line mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView);
            }];

            
        }
        
        
    }else{
        
        if (indexPath.row == vi_section_0_rowCount-1) {
            
            [cell.separate_line mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView);
            }];
            
        }
        
    }
    
    
    
    //数据

    if (indexPath.section == 0) {
        
        cell.title.text = self.titleArr_0[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.constraints_trailing.constant = 0;
        
        //头像
        if (indexPath.row == 0) {
            
            cell.icon_imgV.hidden = NO;
            
            self.icon_imgV = cell.icon_imgV;
            
            if (self.model.dataModel.headImg.length) {
                
        [cell.icon_imgV sd_setImageWithURL:[NSURL URLWithString:self.model.dataModel.headImg]];
                
            }
            
            
            cell.detail.hidden = YES;
            
        }
        

//        cell.detail.text = self.model.dataArr[indexPath.row];
        
        
        
        switch (indexPath.row) {
                
                
            case 1://昵称
            {
                cell.detail.text = self.model.dataModel.nikerName;
                
//                if (!self.model.dataModel.nikerName.length) {
//                    
//                    cell.detail.text = @"请设置昵称";
//                }
                
            }
                break;
                
            case 2://一句话介绍
            {
                cell.detail.text = self.model.dataModel.introduce;
                
                
//                if (!self.model.dataModel.introduce.length) {
//                    
//                    cell.detail.text = @"用一句话介绍你自己";
//                }

                
                
            }
                break;
                
            case 3://性别
            {
                cell.detail.text = self.model.dataModel.sex;
                
                
//                if (!self.model.dataModel.sex.length) {
//                    
//                    cell.detail.text = @"请设置性别";
//                }

            }
                break;
                
            case 4://手机号
            {
                cell.detail.text = self.model.dataModel.loginName;
            }
                
                break;

                
            default:
                break;
        }
        
        
        
        
    }else if(indexPath.section == 1){
        
//        cell.detail.text = self.dataArr[indexPath.row + 3];
        
//        cell.title.text = self.titleArr_1[3+indexPath.row];
        
        cell.title.text = self.titleArr_1[indexPath.row];
        
        #pragma mark 认证显示
//        
//
//        NSDictionary*proactiveLoginDic = [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
//        
        if (self.model.dataModel.name.length && self.model.dataModel.idNumber.length && indexPath.row == 2 && [MinePageViewModel model].user == villager){
            
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.constraints_trailing.constant = 0;

            
        }
        
        

                cell.detail.text = self.model.dataModel_arr[indexPath.row];
        
        
    }else if(indexPath.section == 2){
        
        
        //日志处理
        
//        cell.separate_line.hidden = YES;
//        
//        cell.backgroundColor = RGB(240, 239, 244, 1);
//        
//        
//        cell.title.hidden = YES;
//        cell.detail.hidden = YES;
//
//        cell.logStr = self.logArr[indexPath.row];
//        
//        
//        if (indexPath.row == self.logArr.count - 1) {
//            
//        }else{
//            
//            cell.rect.hidden = NO;
//            
//        }
//        
//        
//        cell.spot.hidden = NO;
        
    }
    
    
    return cell;
}




//响应点击事件
#pragma mark 点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    
    if (indexPath.section == 0) {
        
        
        switch (indexPath.row) {
            case 0:
                
                //修改头像
                [self changePortait];
                
                break;
            case 1:
                //修改昵称
 
                
//                break;

            case 2:
                
                //一句话介绍
                
//                break;

            case 3:
                
                //性别
                /*
                 
                 TMD,我说怎么一直push不了有问题呢
                 日了狗了,原来一直继承的viewtroller!!!!而不是UIViewControler!!!
                 WOcao!!!日了🐶了
                 
                 viewtroller 已经在栈区了 , 所以不能推(我猜的)
                 
                 */
                
                [self.navigationController pushViewController:[SubSAViewController customForType:indexPath.row] animated:YES];
                break;

            case 4:
                
                //手机号
            {
                ModifyPhoneNumVC *modify = [[ModifyPhoneNumVC alloc]initWithNibName:@"ModifyPhoneNumVC" bundle:nil];
                [self.navigationController pushViewController:modify animated:YES];
            }

                
                break;

                
            default:
                break;
        }
        
        
        
        
        
        
    }else if (indexPath.section == 1){
        
        
        #pragma mark 点击事件
        

        
        if (self.model.dataModel.name.length && self.model.dataModel.idNumber.length && indexPath.row == 2 && [MinePageViewModel model].user == villager){
            
            {
                ModifyPhoneNumVC *modify = [[ModifyPhoneNumVC alloc]initWithNibName:@"ModifyPhoneNumVC" bundle:nil];
                [self.navigationController pushViewController:modify animated:YES];
            }
            
        }

        
        
    }
        
        
        
        
    

    
}

//自己实现代理方法去处理取到的图片

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    //获取图片后的操作
    
    
    [self.model  uploadForHeadIcon:image Success:^(NSString *imgUrl) {
       
            self.icon_imgV.image = image;
        
        //提示成功
        [[NoticeTool notice] showTips:@"保存成功!" onView:self.view];

        
        
        
}];
    
}




-(void)setBackBtn{
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];

    
    
    
}

-(void)backToLastView{
    
    [self.navigationController popViewControllerAnimated:true];
    
    
}

@end
