//
//  NewsListPageModel.h
//  XXProjectNew
//
//  Created by apple on 11/25/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListPageModel : NSObject
@property(nonatomic,copy)NSString* msgTitle;
@property(nonatomic,copy)NSString* titleImg;
@property(nonatomic,copy)NSString* msgSource;
@property(nonatomic,copy)NSString* updateTime;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,copy)NSString* url;
+(instancetype)modelWithDictionary:(NSDictionary*)dic;
- (instancetype)initWithDictionary:(NSDictionary*)dic;
@end
