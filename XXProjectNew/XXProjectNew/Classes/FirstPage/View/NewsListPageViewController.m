//
//  NewsListPageViewController.m
//  XXProjectNew
//
//  Created by apple on 11/24/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "NewsListPageViewController.h"
#import "NLheadView.h"
#import "NLCollectionView.h"
#import "NLTableView.h"
#import "NLTableViewCell.h"
#import "NewsListPageViewModel.h"
#import "NLCollectionViewCell.h"
#import "NewsListPageModel.h"
//NewsListPageModel



@interface NewsListPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)NLheadView* headView;
@property(nonatomic,weak)NLCollectionView* collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout* flowlayout;
@property(nonatomic,strong)NewsListPageViewModel* tool;
@property(nonatomic,weak)UIButton* backToTop_btn;
@property(nonatomic,strong)NSIndexPath* index;
@property(nonatomic,weak)UIView * rollBar;

//防止cell复用出现的布局问题

@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end



@implementation NewsListPageViewController

#pragma mark -
#pragma mark 懒加载区


-(NSMutableDictionary*)cellDic{
    
    
    if (!_cellDic) {
        
        
        NSMutableDictionary* temp = [NSMutableDictionary dictionary];
        
        
        _cellDic = temp;
        
    }
    
    
    return _cellDic;
}


-(NLCollectionView*)collectionView{
    
    
    if(!_collectionView){
        
        
        NLCollectionView* collectionView = [[NLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowlayout];
        
        [self.view addSubview:collectionView];
        
        _collectionView = collectionView;
        
    }
    
    
    return _collectionView;
}


-(UICollectionViewFlowLayout*)flowlayout{
    
    if(!_flowlayout){
        
        
        _flowlayout = [[UICollectionViewFlowLayout alloc]init];
        
    }
    
    
    return _flowlayout;

    
}


-(NLheadView*)headView{
    
    
    if(!_headView){
        
        
        NLheadView* headview = [NLheadView new];
        
        _headView = headview;
        
        [self.view addSubview:headview];

    }
    
    return _headView;
    
}


-(NewsListPageViewModel*)tool{
    
    
    if (!_tool) {
        
        _tool = [NewsListPageViewModel model];
        
    }
    
    return _tool;
}



-(UIView*)rollBar{
    
    
    if (!_rollBar) {
        
    
        //滚动显示条
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, barHight + headViewHight-1.5, screenWidth/4, 3)];
        
        view.backgroundColor = title_redColor;
        
        [self.view addSubview:view];
    
        _rollBar = view;
        
    }
    
    
    return _rollBar;
}


-(UIButton*)backToTop_btn{
    
    
    if (!_backToTop_btn) {
        
        UIButton* btn = [UIButton new];
        
        _backToTop_btn = btn;
        
//        btn.backgroundColor = [UIColor redColor];
        
//        [btn setTitle:@"点我返回" forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"back_to_top"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        
        btn.hidden = YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.bottom.equalTo(self.view).offset(-30);
            
            make.size.mas_equalTo(CGSizeMake(50, 50));
            
        }];
        
        
        
    }
    
    return _backToTop_btn;
    
}


    

#pragma mark -
#pragma mark 自定义方法


-(void)backToTop:(UIButton*)btn{
    
    //获取当前tableview
    NSIndexPath* index = [self.collectionView indexPathForItemAtPoint:self.collectionView.contentOffset];
    
    NLCollectionViewCell* cell =  (NLCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:index];

//    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
//    
//    [cell.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    [cell.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    btn.hidden = YES;
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
}



-(void)loadView{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
    
    [self setNavigationBar];
    
    [self setupUI];
    
    
    
}

-(void)setupUI{
    
    
    //设置上面的按钮
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(self.view).offset(64);
        
        make.height.mas_equalTo(headViewHight);
        
    }];
    
    
    // 点击btn
    
    self.headView.block = ^(NSInteger num){
        
        NSIndexPath* index = [NSIndexPath indexPathForItem:num inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
    };
    
    
    //滚动条
    
    [self rollBar];
    
    
    
    
    //下面的view
    
    [self setupCollcetionView];
    
    

    
}


-(void)setNavigationBar{
    
    //标题
//    self.title = @"头条新闻";
    
    
    
//    self.navigationController.navigationBar.translucent = YES;
    
    UILabel* label = [UILabel labelWithText:@"头条新闻" andColor:title_redColor andFontSize:17 andSuperview:nil];
    
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    
    
    
    
    //返回按钮
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];



}

-(void)backToLastView{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)setupTableView:(NLTableView*)tableview{
    
    tableview.dataSource = self;
    
    tableview.delegate = self;
    
    
#pragma mark getWebData
    
[self.tool obtainWebDataWithFinished:^{
    
    [tableview reloadData];
}];
    
//    [self.tool obtainWebDataWithType:1 andFinished:nil];
    
}

-(void)setupCollcetionView{
    
    
    
    self.collectionView.backgroundColor = gray_backgound;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(self.headView.mas_bottom);
        
//        make.height.mas_equalTo(screenHeight-headViewHight);
        
        make.bottom.equalTo(self.view);
        
    }];

    
    
    //设置collectionView
    
    
    
    _collectionView.pagingEnabled = YES;
    
    //注册cell
    [_collectionView registerClass:[NLCollectionViewCell class] forCellWithReuseIdentifier:NLCollectionViewReusedID];

    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    
    self.flowlayout.itemSize =  CGSizeMake(screenWidth, screenHeight - headViewHight-barHight);
    
    self.flowlayout.minimumLineSpacing = 0;
    
    self.flowlayout.minimumInteritemSpacing = 0;
    
    self.flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;


    
    
}


#pragma mark -
#pragma mark collection source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
    
    
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"cell", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        
        // 注册Cell
        [self.collectionView registerClass:[NLCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    NLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    cell.tableView.tag = indexPath.row;
    
    
    
    
    [self setupTableView:cell.tableView];
    
    
    
    return cell;
    
}

#pragma mark -
#pragma mark tableview source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    
     return self.tool.rowCount_arr[tableView.tag].integerValue;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NLTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NLTableViewReusedID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.tool.cellModel_arr[tableView.tag][indexPath.row];
    
    
    return cell;
    
    
}

//点击事件



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WKWebVC* webVC = [WKWebVC new];
    
    NewsListPageModel* model_ = self.tool.cellModel_arr[tableView.tag][indexPath.row];
    
    webVC.urlstr = model_.url;
    webVC.msgImage = model_.titleImg;
    webVC.msgTitle = model_.msgTitle;
    webVC.message = model_.message;
    [self.navigationController pushViewController:webVC animated:YES];
    
    
    

}





- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (!tableView.dragging) {
        
        return;
        
    }
        
    
    if (indexPath.row > self.index.row) {
        
        if(indexPath.row > 19){
            
            self.backToTop_btn.hidden = NO;
            
        }
        
        
        
    }else{
        
        
        if(indexPath.row < 15){
    
            self.backToTop_btn.hidden = YES;
        }

        
        
    }

    
    self.index = indexPath;

    
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"%td",indexPath.row);


}





#pragma mark -
#pragma mark scrollView 


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
        
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        
        CGPoint midPoint = CGPointMake(self.collectionView.contentOffset.x+screenWidth/2, self.collectionView.contentOffset.y);
        
        NSIndexPath* index =   [self.collectionView indexPathForItemAtPoint:midPoint];
        
        
        self.backToTop_btn.hidden = YES;

        
        [self.headView viewDidScroll:self.headView.btnArr[index.row]];
        
        
        CGRect origin = self.rollBar.frame;
        
        
        origin.origin.x = self.collectionView.contentOffset.x/4;
        
        
        self.rollBar.frame = origin;
        
        
    }
    
    
    
    
    
    
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

//手动滚动结束后调用

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[NLCollectionView class]]) {
        
        [self btnWhetherAppear];
        
    }
    

    
    
    
    
    
}

// 代码滚动动画结束时调用

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[NLCollectionView class]]) {
        
        [self btnWhetherAppear];
        
    }
    

    
    
}


-(void)btnWhetherAppear{
    
    
    NSIndexPath* index = [self.collectionView indexPathForItemAtPoint:self.collectionView.contentOffset];
    
    
    NLCollectionViewCell* cell =  (NLCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:index];
    
    
    for (NSIndexPath* index in cell.tableView.indexPathsForVisibleRows) {
        
        if (index.row > 19) {
            
            self.backToTop_btn.hidden = NO;
            
        }
    }
    

    
    
}


@end
