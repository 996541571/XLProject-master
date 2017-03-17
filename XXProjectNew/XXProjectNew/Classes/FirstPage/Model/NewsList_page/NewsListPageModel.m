//
//  NewsListPageModel.m
//  XXProjectNew
//
//  Created by apple on 11/25/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "NewsListPageModel.h"

@implementation NewsListPageModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


- (instancetype)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

+(instancetype)modelWithDictionary:(NSDictionary*)dic{
    
    NewsListPageModel* model = [[NewsListPageModel alloc]initWithDictionary:dic];
    
    return model;
}


-(NSString*)updateTime{
    
    //处理时间戳
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_updateTime doubleValue] / 1000];
    NSTimeInterval _interval= _updateTime.doubleValue / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy.MM.dd HH:mm"];

    return [objDateformat stringFromDate: date];

}


-(NSString*)msgSource{
    
    
    if (!_msgSource || !_msgSource.length) {
        
        return @"未知来源";
    }
    
    //    &nbsp;&nbsp;&nbsp;&nbsp;
    //</span>
    
//    NSString* beginStr = @"&nbsp;&nbsp;&nbsp;&nbsp;";
//    NSString* endStr = @"</span>";
//    
//    
//    
//    NSRange beginRange = [_msgSource rangeOfString:beginStr];
//    
//    NSRange endRange = [_msgSource rangeOfString:endStr];
//    
//    if (!beginRange.length || !endRange.length) {
//        
//        return @"未知来源";
//    }
//    
//    
//    NSString* result = [_msgSource substringWithRange:NSMakeRange(beginRange.location + beginRange.length, endRange.location-beginRange.location-beginRange.length)];
//    
    
    
    return _msgSource;
}
@end
