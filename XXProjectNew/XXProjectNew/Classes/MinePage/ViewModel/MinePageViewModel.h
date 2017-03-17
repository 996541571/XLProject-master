//
//  MinePageViewModel.h
//  XXProjectNew
//
//  Created by apple on 11/28/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MinePageModel;

typedef enum : NSUInteger {
    visitor,
    villager,
    administrator,
} identity;

@interface MinePageViewModel : NSObject

+(instancetype)model;

@property(nonatomic,strong)MinePageModel* model;

@property(nonatomic,assign)identity user;

-(void)prepareToPresentWithSuccess:(void(^)())success;


@end
