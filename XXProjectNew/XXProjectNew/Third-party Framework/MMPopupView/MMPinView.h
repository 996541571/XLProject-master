//
//  MMPinView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"
@class MMPopupView;
@interface MMPinView : MMPopupView
@property(nonatomic,copy)NSString* moneyText;
@property(nonatomic,copy)NSString* restAmount;
@property(nonatomic,copy)void(^hadInputPWBlock)(NSString*,MMPinView*);
@property (nonatomic, strong) UITextField *tfPin;
@property(nonatomic,weak)UIViewController* vc;


-(void)clear;
@end
