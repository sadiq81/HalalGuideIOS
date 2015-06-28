//
//  HalalGuideTests.m
//  HalalGuideTests
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HGAddressService.h"

/*

Lav ny lokation uden billeder -> intet review
Lav ny lokation uden billeder -> lav review uden billeder
Lav ny lokation med billeder -> intet review
Lav ny lokation med billeder -> lav review med billeder

Tilføj billeder til eksisterende lokation
Tilføj review til eksisterende lokation uden billeder
Tilføj review til eksisterende lokation med billeder

 */


@interface HalalGuideTests : XCTestCase

@end

@implementation HalalGuideTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.

}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
