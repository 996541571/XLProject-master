//
//  FPBusinessModulView.h
//  XXProjectNew
//
//  Created by apple on 12/8/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define btnWidth 70
#define btnHeight 90


@class BusinessModel;
@interface FPBusinessModulView : UITableViewCell
@property(nonatomic,strong)NSArray <BusinessModel*>*model_arr;
@property(nonatomic,strong)NSArray<DVButton*>* btn_arr;

@property(nonatomic,assign,getter=isNewYear)BOOL newYear;

@end
