//
//  FMDBTools.h
//  KXTTest222
//
//  Created by 108财经 on 15/6/23.
//  Copyright (c) 2015年 108财经. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@interface FMDBTools : NSObject
//创建表
+(FMDatabase * )getDB;
//插入数据
+ (void)insertTableWithTitle:(NSString *)title URL:(NSString *)url Thumb:(NSString *)thumb Addtime:(NSString *)addtime IsComment:(NSString *)isComment FirstTag:(NSString *)firstTag SecondTag:(NSString *)secondTag CategoryId:(NSString *)categoryId theID:(NSString *)theID Weburl:(NSString *)weburl dataDescription:(NSString *)dataDescription;
//查找
+ (BOOL)selectTableWithCategoryId:(NSString *)categoryId theID:(NSString *)theID;
//删除
+ (void)deleteWithCategoryId:(NSString *)categoryId theID:(NSString *)theID;
+ (NSMutableArray *)getAllOrders;
//删除所有
+(BOOL) deleteAll;



@end
