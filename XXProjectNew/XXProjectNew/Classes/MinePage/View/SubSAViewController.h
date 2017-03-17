//
//  SubSAViewController.h
//  XXProjectNew
//
//  Created by apple on 12/2/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "DVViewController.h"

typedef enum : NSUInteger {
    TypeIcon,
    TypeNickname,
    TypeIntroduce,
    TypeGender,
    TypeChangeMobie
}Type;

@interface SubSAViewController : DVViewController
+(instancetype)customForType:(Type)type;

@property(nonatomic,assign)Type type;

@end
