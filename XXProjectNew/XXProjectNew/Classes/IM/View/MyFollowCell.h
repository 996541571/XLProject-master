//
//  MyFollowCell.h
//  XXProjectNew
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FollowBlock) (NSInteger index);
@interface MyFollowCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,assign)BOOL isFan;
@property(nonatomic,copy)FollowBlock block;
@property(nonatomic,assign)NSInteger row;
@end
