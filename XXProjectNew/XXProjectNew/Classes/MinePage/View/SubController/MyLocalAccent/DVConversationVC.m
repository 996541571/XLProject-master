//
//  DVConversationVC.m
//  XXProjectNew
//
//  Created by apple on 1/3/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DVConversationVC.h"
#import "SimpleMessageCell.h"
#import "SimpleMessage.h"

//发红包页面
#import "DVRedPacketSendVC.h"

//查看红包

#import "DVRedPacketCheckTVC.h"



@interface DVConversationVC ()<DVRedPacketSendVCDelegate>

@end

@implementation DVConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self setupUI];
    
    
    //单聊时不显示昵称
    
    self.displayUserNameInCell = NO;
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillAppear:animated];
    
}

-(void)setupUI{
    
    
    //leftButtonItem 设置
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView:)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
    // 删除扩展功能板中的指定扩展项(位置)
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    
    //改成红包
    
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"ic_hongbao"] title:@"红包" tag:2];
    

    //右边按钮
    
    
    
//    UILabel* rightLa = [UILabel labelWithText:@"设置" andColor:text_Color andFontSize:14 andSuperview:nil];
    
    UIButton *rightLa = [UIButton buttonWithText:@"设置" andColor:text_Color andFontSize:14 andSuperview:nil];
    
    [rightLa sizeToFit];
    
    UIBarButtonItem* rightBI = [[UIBarButtonItem alloc]initWithCustomView:rightLa];

//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightButtonDidClick)];
    
    
    [rightLa addTarget:self action:@selector(rightButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [rightLa addGestureRecognizer:tap];
    
    self.navigationItem.rightBarButtonItem = rightBI;
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonDidClick)];
    
    
    
    
    //注册红包cell
    
    [self registerClass:[RedPacketBaseCell class] forMessageClass:[SimpleMessage class]];

//    [self registerClass:[SimpleMessageCell class] forMessageClass:[SimpleMessage class]];
    
    
}


-(void)rightButtonDidClick{
    
    //聊天详情
    DCConversationSettingTableVC* settingView = [DCConversationSettingTableVC new];
    
    //传递列表
    settingView.listVC = self.listVC;
    
    
    settingView.conversationVC = self;
    //------
    
    settingView.targetId = self.targetId;
    
    [self.navigationController pushViewController:settingView animated:YES];

    
}


- (void)backToLastView:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

//RCConversationSettingTableViewController


/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    
    //跳转到聊天人的信息页面
    
    
    
    if ([userId isEqualToString:self.targetId]) {
        
        
        PersonalInformationVC * VC =  [PersonalInformationVC new];
        
        VC.partyID = (NSNumber*)userId;//@([userId integerValue]);
        
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
    

    
    
}



#pragma mark 监听发送界面

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    
    
    
//    NSLog(@"%@",[RCIM sharedRCIM].currentUserInfo);
//    
//    RCUserInfo* user_info =[RCIM sharedRCIM].currentUserInfo;
    
//    BOOL k =  [RCIM sharedRCIM].enableMessageAttachUserInfo;
    
    
    messageCotent.senderUserInfo =[RCIM sharedRCIM].currentUserInfo;
    
    if (!messageCotent.senderUserInfo.name.length) {
        
        messageCotent.senderUserInfo.name = [NSString stringWithFormat:@"xl%@",messageCotent.senderUserInfo.userId];
    }
    
    return [super willSendMessage:messageCotent];

    
}


//自定义模板

-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    
    
    
    //如果是红包
    if (tag == 2) {
        
        /*
         
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.targetId content:message pushContent:@"" pushData:@"" success:^(long messageId) {
         
            [self.conversationMessageCollectionView reloadData];
         
            NSLog(@"success");
         
         
        } error:^(RCErrorCode nErrorCode, long messageId) {
            NSLog(@"fail");
         
         
        }];
        
        */
        
        
       DVRedPacketSendVC* redVC =  [DVRedPacketSendVC new];
        
        redVC.targetId = self.targetId;
        
        redVC.delegate = self;
        
        [self.navigationController pushViewController:redVC animated:YES];
        
        
        
    }
    
    
}


    
#pragma mark 发红包

-(void)sendRedPacket:(SimpleMessage*)message{
    
    
    [self sendMessage:message pushContent:@""];
    
    
    
    
    
}




/*
 
 cell显示前的调整
 
-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if ([[cell class] isSubclassOfClass:[RedPacketBaseCell class]]) {
        
        
//        cell.backgroundColor = [UIColor redColor];
        
    }
    
    
}

*/




-(void)didTapMessageCell:(RCMessageModel *)model{
    
    NSLog(@"%@",model.objectName);
    
    
    [super didTapMessageCell:model];
    
    
    if (![CoreStatus isNetworkEnable]){
        [[NoticeTool notice]showTips:@"网络异常,请稍后再试" onView:self.view];
        return;
    }
    
    
    if ([model.objectName isEqualToString:DVRedPacket]) {
        
        #pragma mark 点击红包cell事件
        
        
        
        
        DVRedPacketCheckTVC* vc =  [[DVRedPacketCheckTVC alloc]init];
        
        SimpleMessage* message= (SimpleMessage*)model.content;
        
        
        vc.messageModel = model;
        
//        vc.senderUserId = model.senderUserId;
        
//        vc.targetId = model.targetId;
        
        vc.packetID = message.bribery_ID;
        
//        NSLog(@"%ld",model.messageId);
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}






@end
