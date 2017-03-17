//
//  SimpleMessage.m
//  XXProjectNew
//
//  Created by apple on 1/9/17.
//  Copyright © 2017 xianglin. All rights reserved.
//

//`SimpleMessage.m` 文件代码如下：

#import "SimpleMessage.h"
#import <RongIMLib/RCUtilities.h>

@implementation SimpleMessage

+ (instancetype)messageWithContent:(NSString *)content {
    SimpleMessage * msg = [[SimpleMessage alloc] init];
    if (msg) {
        msg.content = content;
    }
    
    return msg;
}

+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark - NSCoding
#define KEY_MSG_CONTENT             @"content"
#define KEY_MSG_BRIBERY_ID          @"bribery_ID"
#define KEY_MSG_BRIBERY_NAME        @"briberyName"
#define KEY_MSG_BRIBERY_DESC        @"briberyDesc"

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:KEY_MSG_CONTENT];
        self.bribery_ID = [aDecoder decodeObjectForKey:KEY_MSG_BRIBERY_ID];
        self.briberyName = [aDecoder decodeObjectForKey:KEY_MSG_BRIBERY_NAME];
        self.briberyDesc = [aDecoder decodeObjectForKey:KEY_MSG_BRIBERY_DESC];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:KEY_MSG_CONTENT];
    [aCoder encodeObject:self.bribery_ID forKey:KEY_MSG_BRIBERY_ID];
    [aCoder encodeObject:self.briberyName forKey:KEY_MSG_BRIBERY_NAME];
    [aCoder encodeObject:self.briberyDesc forKey:KEY_MSG_BRIBERY_DESC];
}

#pragma mark - RCMessageCoding delegate methods
- (NSData *)encode {
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    if (self.bribery_ID) {
        [dataDict setObject:self.bribery_ID forKey:@"Bribery_ID"];
    }
    else {
        [dataDict setObject:@"红包ID" forKey:@"Bribery_ID"];
    }
    if (self.briberyName) {
        [dataDict setObject:self.briberyName forKey:@"Bribery_Name"];
    }
    else {
        [dataDict setObject:@"红包名称" forKey:@"Bribery_Name"];
    }
    
    if (self.briberyDesc) {
        [dataDict setObject:self.briberyDesc forKey:@"Bribery_Message"];
    }
    else {
        [dataDict setObject:@"红包描述……" forKey:@"Bribery_Message"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary * __dic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKey:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"bribery"];
    }
    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
    
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    
    if (json) {
        self.content = json[@"content"];
        self.bribery_ID = json[@"Bribery_ID"];
        self.briberyName = json[@"Bribery_Name"];
        self.briberyDesc = json[@"Bribery_Message"];
        NSObject *__object = [json objectForKey:@"user"];
        NSDictionary *userinfoDic = nil;
        if (__object &&[__object isMemberOfClass:[NSDictionary class]]) {
            userinfoDic = (NSDictionary *)__object;
        }
        if (userinfoDic) {
            RCUserInfo *userinfo =[RCUserInfo new];
            userinfo.userId = [userinfoDic objectForKey:@"id"];
            userinfo.name =[userinfoDic objectForKey:@"name"];
            userinfo.portraitUri =[userinfoDic objectForKey:@"icon"];
            self.senderUserInfo = userinfo;
        }
        
    }
}

+ (NSString *)getObjectName {
    return DVRedPacket;
}

#pragma mark - RCMessageContentView delegate methods
- (NSString *)conversationDigest {
    return self.content;
}

#if ! __has_feature(objc_arc)

-(void)dealloc {
    [super dealloc];
}
#endif//__has_feature(objc_arc)



@end
