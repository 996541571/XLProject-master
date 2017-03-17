//
//  ConveniecePageViewModel.h
//  XXProjectNew
//
//  Created by apple on 12/5/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define CellRowHeight 0
//#define CellRowHeight 150
#define title_height 30
#define btnWidth 70
//#define btnHeight 95
#define btnHeight 73

@class ConveniencePageModel;
@interface ConveniecePageViewModel : NSObject

+(instancetype)model;

@property(nonatomic,strong)NSArray<ConveniencePageModel*> *cellModel_arr;
@property(nonatomic,copy)NSString* PageTitle;

-(void)obtainWebDataWithSuccess:(void (^)(NSArray*))success;

@end
