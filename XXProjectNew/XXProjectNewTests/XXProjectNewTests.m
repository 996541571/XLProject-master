//
//  XXProjectNewTests.m
//  XXProjectNewTests
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetRequest.h"
#import "XLEncryptionManager.h"
#import "UIColor+Hex.h"
#import <RongIMKit/RongIMKit.h>

@interface XXProjectNewTests : XCTestCase

@end

@implementation XXProjectNewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {


    
    
    //临时token
    
    //userId = xianglin name  = @"乡邻用户1"
    //@"portraitUri" = @"http://img4.imgtn.bdimg.com/it/u=984466995,1002924823&fm=21&gp=0.jpg"
    
    NSString* token = @"x1w56GgWoJj1VpOOOR7Wq2nIdko1+RfNS0ldbTGFfY1so/v+Tpc3f70ZccYXpr0c5msAvvQJncQMaQZNVtjkZIGM81ry+SPv";
    
    
    //链接服务器
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%td", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
    
    //waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);
    
#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil] ;

    
    
    [NetRequest requetWithParams:@[] requestName:@"RedPacketService.queryAcctBalance" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        NSLog(@"responseDicionary == %@",responseDicionary);
        NOTIFY //继续执行
    }];
    WAIT  //暂停

    
    

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
 
        
        
        
        
        
        
        
    }];
}

@end
