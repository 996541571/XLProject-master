//
//  XXProjectNewUITests.m
//  XXProjectNewUITests
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MineController.h"
@interface XXProjectNewUITests : XCTestCase

@end

@implementation XXProjectNewUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    XCUIElement *button = app.buttons[@"\U767b\U5f55"];
//    [button tap];
//    
//    XCUIElement *button2 = app.alerts[@"\U8bf7\U68c0\U67e5"].buttons[@"\U786e\U5b9a"];
//    [button2 tap];
//    [button tap];
//    [button2 tap];
    
    



}

@end
