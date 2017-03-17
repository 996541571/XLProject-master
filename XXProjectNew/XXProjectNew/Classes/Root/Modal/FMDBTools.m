//
//  FMDBTools.m
//  KXTTest222
//
//  Created by 108财经 on 15/6/23.
//  Copyright (c) 2015年 108财经. All rights reserved.
//

#import "FMDBTools.h"
@implementation FMDBTools
+(NSString*)filePath
{
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.sqlite"];
    return filePath;

}

+(FMDatabase * )getDB{
    
//    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.sqlite"];
      NSString* filePath=[self filePath];
    //搜索符合要求的文件夹 返回一个目录数组
    //1、搜索指定类型的文件夹 此处指定Documents
    //2、指定搜索区域
    //3、BOOL 是否展开
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"paths___%@", paths);
//    NSString *documentsPath = paths[0];
//    NSString *databasePath = [documentsPath stringByAppendingPathComponent:@"database.sqlite"];
    
    FMDatabase *  db = [[FMDatabase alloc]initWithPath:filePath];
    if ([db open]){
        //创建表的操作
        //如果表不存在，创建
        if ([db tableExists:@"newsTable"] == NO){
            [db executeUpdate:@"create table newsTable (id integer primary key ,title text,url text,thumb text,addtime text,isComment text,firstTag text,secondTag text,categoryId text,theID text,weburl text,dataDescription text )"];
        }
    }
    [db close];
    return db ;
}

+ (void)insertTableWithTitle:(NSString *)title URL:(NSString *)url Thumb:(NSString *)thumb Addtime:(NSString *)addtime IsComment:(NSString *)isComment FirstTag:(NSString *)firstTag SecondTag:(NSString *)secondTag CategoryId:(NSString *)categoryId theID:(NSString *)theID Weburl:(NSString *)weburl dataDescription:(NSString *)dataDescription{
    
    FMDatabase *db = [FMDBTools getDB];
    if ([db open]){
//        NSString * name = _nameTF.text ;
//        NSString * phone = _phoneTF.text ;
        
        //注意：？的替换内容不能为基本类型 ；基本类型转化为对应的对象类型 ；
        //        int  ID = 5 ;
        //        NSNumber * num = [NSNumber numberWithInt:ID];
        
        [db executeUpdate:@"insert into newsTable (title,url,thumb,addtime,isComment,firstTag,secondTag,categoryId,theID,weburl,dataDescription)values(?,?,?,?,?,?,?,?,?,?,?)",title,url,thumb,addtime,isComment,firstTag,secondTag,categoryId,theID,weburl,dataDescription];
    }
    [db close];
}

+ (BOOL)selectTableWithCategoryId:(NSString *)categoryId theID:(NSString *)theID{
    
    FMDatabase *db = [FMDBTools getDB];
    BOOL iscollect = NO;
    if ([db open]){
        //执行查询语句，得到结果集
        FMResultSet * set = [db executeQuery:@"select * from newsTable where categoryId = ? and theID = ?",categoryId,theID];
        
        //使用while 循环，依次从结果集中获得数据
        while ([set next]){
            iscollect = YES;
//            Student * stu = [[[Student alloc]init]autorelease];
//            stu.ID = [set intForColumn:@"id"];
//            stu.name = [set stringForColumn:@"name"];
//            stu.phone = [set stringForColumn:@"phone"];
//            [array addObject:stu];
        }
        //销毁结果集 ；类似  sqlite3_fina~~~~
        [set close];
    }
    [db close];
    return iscollect;
}

+ (void)deleteWithCategoryId:(NSString *)categoryId theID:(NSString *)theID{
    
    //获取数据库
    FMDatabase *db = [self getDB];
    if ([db open]) {
        [db executeUpdate:@"DELETE FROM newsTable WHERE categoryId = ? and theID = ?", categoryId,theID];
    }
    
    [db close];
    
}

+ (NSMutableArray *)getAllOrders{
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    FMDatabase *db  = [self getDB];
    if ([db open]){
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM newsTable"];
        
        while ([resultSet next]){
            
//            CollectNews *newsModel = [CollectNews new];
////            int orderId = [resultSet intForColumn:@"id"];
//            newsModel.title = [resultSet stringForColumn:@"title"];
//
//            newsModel.url = [resultSet stringForColumn:@"url"];
//            newsModel.thumb = [resultSet stringForColumn:@"thumb"];
//            newsModel.addtime = [resultSet stringForColumn:@"addtime"];
//            newsModel.isComment = [[resultSet stringForColumn:@"isComment"] intValue];
//            newsModel.firstTag = [resultSet stringForColumn:@"firstTag"];
//            newsModel.secondTag = [resultSet stringForColumn:@"secondTag"];
//            newsModel.categoryId = [resultSet stringForColumn:@"categoryId"];
//            newsModel.theID = [resultSet stringForColumn:@"theID"];
//            newsModel.weburl = [resultSet stringForColumn:@"weburl"];
//            newsModel.dataDescription = [resultSet stringForColumn:@"dataDescription"];
//            [mutableArray addObject:newsModel];
        }
        [resultSet close];
    }
    [db close];
    return mutableArray;
}
+(BOOL) deleteAll
{
    NSString*fileStr=[self filePath];
    FMDatabase *db = [FMDatabase databaseWithPath:[self filePath]];
    [db open];
    BOOL success = [db executeUpdate:@"DELETE FROM  newsTable"];
    [db close];
    return success;
    return YES;
}

@end
