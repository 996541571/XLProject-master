//
//  NLheadView.h
//  XXProjectNew
//
//  Created by apple on 11/24/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLheadView : UIView

@property(nonatomic,strong)NSArray* btnArr;
@property(nonatomic,copy)void (^block)(NSInteger);
//-(void)btnDidClick:(UIButton*)btn;
-(void)viewDidScroll:(UIButton*)btn;
@end
