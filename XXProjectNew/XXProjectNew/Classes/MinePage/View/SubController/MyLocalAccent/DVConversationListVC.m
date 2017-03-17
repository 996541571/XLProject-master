//
//  DVConversationListVC.m
//  XXProjectNew
//
//  Created by apple on 1/3/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DVConversationListVC.h"

#import "ContactsController.h"

#import "FindFriendsController.h"
@interface DVConversationListVC ()<UISearchBarDelegate,RCIMReceiveMessageDelegate>

@property(nonatomic,strong)UISearchController* searchDisplay;
@property(nonatomic,weak)UISearchBar* searchBar;

@end

@implementation DVConversationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setup];
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;

    
    //自定义导航左右按钮
    
    
    
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView:)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
    
    //
    
    UIButton* msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];;
    [msgBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [msgBtn setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:msgBtn];
    
    
    
    
    //显示的消息类型
    
    self.displayConversationTypeArray = @[@(ConversationType_PRIVATE)];

    //去掉多余分割线
    
    self.conversationListTableView.tableFooterView = [UIView new];

    
    
    //清空缓存 -- 刷新用户信息
    
    [[RCIM sharedRCIM] clearUserInfoCache];
    
}




-(void)setupUI{
    
    //搜索框
    
    NSLog(@"%@",self.view.subviews);
    
    
    for (UIView* view  in self.view.subviews) {
        
        if ([view isKindOfClass:[UITableView class]]) {
            
            
            UITableView* tabelView = (UITableView*)view;
            
            
            
            UISearchBar* searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
            
            searchBar.placeholder = @"搜索";
            
            
            
//            NSLog(@"%@",[searchBar valueForKey:@"searchField.placeholderLabel.content"]);
            
            
            
//            searchBar.text  = @"";
            
//            self.searchDisplay
            
            self.searchBar = searchBar;
//            searchBar.barTintColor = [UIColor whiteColor];
//            searchBar.tintColor = [UIColor redColor];
            
            
            searchBar.delegate = self;
            
            searchBar.searchBarStyle = UISearchBarStyleMinimal;
            
//            searchBar.showsCancelButton = YES;
            
//            UISearchBar* searchBar = [[UISearchBar alloc]init];
            
            tabelView.tableHeaderView = searchBar;
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
    }
    

    
    
}

-(void)setup{
    
//    [[RCIMClient sharedRCIMClient] getUnreadCount:1 targetId:@""];
    
    
}





-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self.searchBar endEditing:YES];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar

{
//    [searchBar setShowsCancelButton:YES animated:YES];
    
//    [searchBar endEditing:YES];
    

    
    ContactsController* cc = [ ContactsController new];
    
    

    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       
                       
                       
//                       [find.ex_textField becomeFirstResponder];
                   }
                   );
    
    
    
    [self.navigationController pushViewController:cc animated:YES];


    
    
    return NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
}



- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    
//     [searchBar setShowsCancelButton:NO animated:YES];
    
    return NO;
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    
}



/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    DVConversationVC *conversationVC = [[DVConversationVC alloc]init];
    
    //传递列表页面
    conversationVC.listVC = self;
    
    conversationVC.unReadMessage = 10;
    
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
//    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    
}

/**
 *  退出登录
 *
 *  @param sender <#sender description#>
 */
- (void)backToLastView:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)rightBarButtonItemPressed:(id)sender
{
    
    /*
    
    DVConversationVC *conversationVC = [[DVConversationVC alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
    
    conversationVC.targetId =@"1000000000001910";
    

    
    
    //    conversationVC.userName = @"测试1";
    conversationVC.title = @"自问自答";
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    */
    
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToView:sender withActions:[self QQActions]];

    
    
    
}

- (NSArray<PopoverAction *> *)QQActions {
    // 发起多人聊天 action
    PopoverAction *singlechatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"pop_chat"] title:@"发起聊天" handler:^(PopoverAction *action) {
#pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
        
        
        
        
        
//        DVConversationVC *conversationVC = [[DVConversationVC alloc]init];
//        conversationVC.conversationType =ConversationType_PRIVATE;
//        //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
//    
//        conversationVC.targetId =@"1000000000001910";
//        
//        conversationVC.title = @"单聊";
//        
//        [self.navigationController pushViewController:conversationVC animated:YES];
        
        
        [MobClick event:@"um_my_MyXY_Initiateschats_click_event"];

        
        ContactsController* cc = [ ContactsController new];
        
        [self.navigationController pushViewController:cc animated:YES];


        

        
    }];
    
    
    PopoverAction *multipleAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"pop_add"] title:@"找朋友" handler:^(PopoverAction *action) {
#pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
        
        
        [MobClick event:@"um_my_MyXY_Initiateschats_findfriends_click_event"];

        
        FindFriendsController *find = [[FindFriendsController alloc]init];
        [self.navigationController pushViewController:find animated:YES];
        
        
//        DVConversationVC *conversationVC = [[DVConversationVC alloc]init];
//        conversationVC.conversationType =ConversationType_PRIVATE;
//        //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
//        
//        conversationVC.targetId =@"1000000000001963";
//        
//        conversationVC.title = @"单聊";
//        
//        [self.navigationController pushViewController:conversationVC animated:YES];
        

        
    }];

    return @[singlechatAction,multipleAction];
    
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    
//    isShowNotificationNumber
    
    
    
    
    if ([cell isMemberOfClass: [RCConversationCell class]]) {
        
        
        RCConversationCell* cv_cell = (RCConversationCell*)cell;
        
        //屏蔽的对话不显示
        
        [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:1 targetId:cell.model.targetId success:^(RCConversationNotificationStatus nStatus) {
            
            if (!nStatus) {
                
                cv_cell.isShowNotificationNumber = NO;
            }
            
            
        } error:^(RCErrorCode status) {
            
            NSLog(@"读取屏蔽消息开关失败");
        }];

        
        
        
        
        
        
        
        
        
        RCConversationCell *conversationCell = (RCConversationCell *)cell;
        NSInteger unreadCount = conversationCell.model.unreadMessageCount;
        conversationCell.bubbleTipView.bubbleTipTextFont = [UIFont systemFontOfSize:8.f];
        if (unreadCount>0){
            conversationCell.bubbleTipView.bubbleTipText = (unreadCount > 99) ? @"99+" : [NSString stringWithFormat:@"%ld",(long)unreadCount];
        }else{
            conversationCell.bubbleTipView.bubbleTipText = nil;
        }
                
    }

}


//前台收到消息
-(BOOL)onRCIMCustomAlertSound:(RCMessage *)message{
    
    return NO;
    
}
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    
}



@end
