//
//  OthersFollowCell.h
//  XXProjectNew
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OthersFollowBlock) (NSInteger index,NSString *result);

@interface OthersFollowCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,assign)BOOL isFan;
@property(nonatomic,copy)OthersFollowBlock block;
@property(nonatomic,assign)NSInteger row;
@end
