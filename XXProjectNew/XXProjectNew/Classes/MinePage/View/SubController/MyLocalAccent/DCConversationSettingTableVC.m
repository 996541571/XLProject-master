//
//  DCConversationSettingTableVC.m
//  XXProjectNew
//
//  Created by apple on 1/3/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import "DCConversationSettingTableVC.h"

#import "DCConversationSettingTableVCCell.h"

#import "DVConversationVC.h"

//个人信息
#import "PersonalInformationVC.h"

static NSString* DCConversationSettingTableVCCellReusedID = @"DCConversationSettingTableVCCell";

@interface DCConversationSettingTableVC ()
@property(nonatomic,assign,getter=isBlock)BOOL block;
@property(nonatomic,copy)NSString* userName;
@property(nonatomic,copy)NSString* introduce;
@property(nonatomic,copy)NSString* imgUrl;

@end

@implementation DCConversationSettingTableVC



-(NSString*)introduce{
    
    
    if (!_introduce.length) {
        
        _introduce = @"暂无介绍";
        
    }
    
    return _introduce;
}


-(NSString*)imgUrl{
    
    
    if (!_imgUrl.length) {
        
        _imgUrl = @"";
        
    }
    
    return _imgUrl;
}

-(NSString*)userName{
    
    
    if (!_userName.length) {
        
        _userName = @"";
        
    }
    
    return _userName;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    
    [self inquireForblockList];
    
    [self inquiryForOtherInfo];
    

}


-(void)inquiryForOtherInfo{
    
    
    NSString* requestName = @"UserService.getUserByPartyId";
    
    NSDictionary* dic = @{@"partyId":self.targetId};

    
    [NetRequest requetWithParams:@[dic] requestName:requestName finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        //如果报错
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSLog(@"%@",responseDicionary);
        
        
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {
        
            NSDictionary* dic = [responseDicionary valueForKey:@"result"];
            
            self.userName = [dic[@"nikerName"] length] > 0 ? dic[@"nikerName"]:[NSString stringWithFormat:@"%@",dic[@"loginName"]];
            
            self.imgUrl = dic[@"headImg"];
            
            self.introduce = dic[@"introduce"];
        
        
            [self.tableView reloadData];
            
        
        
        }
        
    }];

    
    
}


- (void)backToLastView:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}





-(void)setupUI{
    
    
    //标题
    
    self.title = @"聊天详情";
    
    
    
    //返回按钮
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    
    imgView.userInteractionEnabled = true;
    
    imgView.image = [UIImage imageNamed:@"back"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView:)];
    
    [imgView addGestureRecognizer:singleTapGestureRecognizer];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];

    
    
    /*
     tableview
     */
    
    //注册cell
    
    [self.tableView registerClass:[DCConversationSettingTableVCCell class] forCellReuseIdentifier:DCConversationSettingTableVCCellReusedID];
    
    //headView
    
    
//    UITableViewCell* headView = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 0, 100)];
//    
//    headView.backgroundColor = [UIColor whiteColor];
//    
//    
//    
//    
//    
//    self.tableView.tableHeaderView = headView;
    
    
    
    
    //去掉多余空cell
    
    self.tableView.tableFooterView = [UIView new];
    
    //设置背景颜色
    
    self.tableView.backgroundColor = RGB(243, 243, 243, 1);
}



-(void)inquireForblockList{
    
    /*!
     查询某个用户是否已经在黑名单中
     
     @param userId          需要查询的用户ID
     @param successBlock    查询成功的回调
     [bizStatus:该用户是否在黑名单中。0表示已经在黑名单中，101表示不在黑名单中]
     @param errorBlock      查询失败的回调 [status:失败的错误码]
     */
    
    
    
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:self.targetId success:^(int bizStatus) {
        
        //查询成功
        
        if (bizStatus) {
            
            self.block = NO;
            
        }else{
            
            self.block = YES;
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.tableView reloadData];
            
        });
        
    } error:^(RCErrorCode status) {
        
        //查询失败
        
    }];

    
    
}



//置顶

/**
 *  设置某一会话为置顶或者取消置顶。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param isTop            是否置顶。
 *
 *  @return 是否设置成功。
 
- (BOOL)setConversationToTop:(RCConversationType)conversationType
                    targetId:(NSString *)targetId
                       isTop:(BOOL)isTop;


*/


#pragma mark -
#pragma mark tableview source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;

        default:
            break;
    }
    
    return 0;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DCConversationSettingTableVCCell* cell = [tableView dequeueReusableCellWithIdentifier:DCConversationSettingTableVCCellReusedID forIndexPath:indexPath];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = self.tool.cellModel_arr[tableView.tag][indexPath.row];
    
    
    
    
    
    
    
    NSString* blockListText ;
    
    if (self.isBlock) {
        
        blockListText = @"解除黑名单";
        
    }else{
        
        blockListText = @"加入黑名单";
        
    }
    
    
    NSArray* arr = @[@[self.userName,self.introduce],@[@"置顶聊天",@"屏蔽消息"],@[@"清空聊天记录"],@[blockListText]];
    
    cell.cell_label.text = arr[indexPath.section][indexPath.row];
    
    if(indexPath.section == 0){
        
        cell.cellType = 2;
        
        cell.detail_label.text = arr[indexPath.section][indexPath.row+1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像
        
        
        if (self.imgUrl.length) {
            
            
            [cell.head_imgV sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
            
        }
        
        
    }else if (indexPath.section == 1) {
        cell.cellType = 0;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.cell_switch.tag = indexPath.row;
        
        if (indexPath.row == 0) {

            //置顶聊天
            //查询恶心
            
            cell.cell_switch.on = [[[RCIMClient sharedRCIMClient] getConversation:1 targetId:self.targetId] isTop];
            
        }else{
            
            
            [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:1 targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
                
                cell.cell_switch.on = !nStatus;
                
            } error:^(RCErrorCode status) {
                
                NSLog(@"读取屏蔽消息开关失败");
            }];
            
            
        }
        
        [cell.cell_switch addTarget:self action:@selector(switchDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
        
        
    }else {
        
        cell.cellType = 1;
        
        
        if (indexPath.section == 3) {
            
            cell.cell_label.textColor = [UIColor redColor];
            
            
        }
        
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (section == 0) {
        
        return 10;
        
    }else{
        
        
        return 0;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            
            return 80;
            break;
            
        default:
            break;
    }
    
    return 49;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3) {
        
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:self.isBlock ? @"是否解除黑名单?":@"是否将此人加入黑名单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alertView.tag = indexPath.section;
        
        [alertView show];

        
        
    }else if (indexPath.section == 2){
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否清空聊天记录"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alertView.tag = indexPath.section;
        
        [alertView show];
        
        
        
        
        
    }else if(indexPath.section == 0){
        
        
        NSLog(@"个人信息");
        
        #pragma mark 点击个人信息
        
        
        PersonalInformationVC * VC =  [PersonalInformationVC new];
        
        VC.partyID = @([self.targetId integerValue]);
        
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
    
    
}
#pragma mark alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 3) {
        
        if (buttonIndex == 1) {
            
            [self opretionWithBlockList];
            
        }
        
        
        
    }else if(alertView.tag == 2){
        
        //清空聊天记录
        
        if (buttonIndex == 1) {
            
            [[RCIMClient sharedRCIMClient]clearMessages:1 targetId:self.targetId];
            
            [self.conversationVC.conversationDataRepository removeAllObjects];
            
            [self.conversationVC.conversationMessageCollectionView reloadData];
            
            
//            [self.navigationController popViewControllerAnimated:YES];
            
            [MobClick event:@"um_My_Chatsdetails_clearrecord_cliek_event"];

            
            [[NoticeTool notice] showTips:[NSString stringWithFormat:@"已清空"] onView:self.view];
        }

        
        
        
        
    }
}

#pragma mark customMethod

-(void)opretionWithBlockList{
    
    if (self.isBlock) {
        
        //移除黑名单
        
        [[RCIMClient sharedRCIMClient] removeFromBlacklist:self.targetId success:^{
            
            NSLog(@"移除黑名单成功");
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NoticeTool notice] showTips:[NSString stringWithFormat:@"移除黑名单成功"] onView:self.view];
                
                [self inquireForblockList];
                
                
            });
 
            
            
            
            
        } error:^(RCErrorCode status) {
            
               NSLog(@"移除黑名单失败!,%ld",(long)status);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NoticeTool notice] showTips:[NSString stringWithFormat:@"移除黑名单失败!"] onView:self.view];
                
            });

            
            
        }];
        
        
        
        
        
    }else{
        
        //加入黑名单
        [[RCIMClient sharedRCIMClient] addToBlacklist:self.targetId success:^{
            
            NSLog(@"加入黑名单成功");
            
            [MobClick event:@"um_My_Chatsdetails_Blacklist_cliek_event"];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NoticeTool notice] showTips:[NSString stringWithFormat:@"加入黑名单成功"] onView:self.view];
                
                [self inquireForblockList];
                
                
                
            });
            
            
        } error:^(RCErrorCode status) {
            
            
            NSLog(@"加入黑名单失败!,%ld",(long)status);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NoticeTool notice] showTips:[NSString stringWithFormat:@"加入黑名单失败!"] onView:self.view];
                
            });

            
        }];

        
        
        
    }
    
    
}

-(void)switchDidClick:(UISwitch*)tip{
    
    
    NSLog(@"%td",tip.on);
    
    
    //点击后的状态和点击前的状态!!!分清楚!!!
    
    
    
    
    
    //置顶
    
    /**
     *  设置某一会话为置顶或者取消置顶。
     *
     *  @param conversationType 会话类型。
     *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
     *  @param isTop            是否置顶。
     *
     *  @return 是否设置成功。
     
     - (BOOL)setConversationToTop:(RCConversationType)conversationType
     targetId:(NSString *)targetId
     isTop:(BOOL)isTop;
     
     
     */

    
    
    if (tip.tag == 0) {
        
        //置顶聊天
        
        NSLog(@"置顶聊天");
        

            if ([[RCIMClient sharedRCIMClient] setConversationToTop:1 targetId:self.targetId isTop:tip.on]) {
                [[NoticeTool notice]showTips:(tip.on == 1? @"已置顶":@"已取消置顶") onView:self.view];

                NSLog(@"设置成功");
            }else{
                 [[NoticeTool notice]showTips:@"置顶聊天设置失败!" onView:self.view];
                
                NSLog(@"设置失败!");
            }
        
        
    }else{
        

        //屏蔽消息
        
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:1 targetId:self.targetId isBlocked:tip.on success:^(RCConversationNotificationStatus nStatus) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [[NoticeTool notice]showTips:(tip.on == 1?@"已屏蔽":@"已取消屏蔽") onView:self.view];
                
            });
            
            NSLog(@"屏蔽成功!");
            
        } error:^(RCErrorCode status) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                [[NoticeTool notice]showTips:@"屏蔽聊天设置失败!" onView:self.view];
            });
            
            NSLog(@"屏蔽失败!");
        }];
        
        
        
    }
    
    
    
    
    
    
    //getConversationList
    
    NSLog(@"--------model.isTop = %td",    [[[RCIMClient sharedRCIMClient] getConversation:1 targetId:self.targetId] isTop]);


}


@end
