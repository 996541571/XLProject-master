//
//  DVRedPacketSendVC.h
//  XXProjectNew
//
//  Created by apple on 1/10/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleMessage;
@protocol DVRedPacketSendVCDelegate <NSObject>
@required

-(void)sendRedPacket:(SimpleMessage*)message;

@end

@interface DVRedPacketSendVC : UIViewController


/*!
 目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;

@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UITextField *des_field;
@property (weak, nonatomic) IBOutlet UITextField *money_field;
@property (weak, nonatomic) IBOutlet UIButton *send_btn;
@property(weak,nonatomic)id<DVRedPacketSendVCDelegate> delegate;



//@property(weak,nonatomic)

@end
