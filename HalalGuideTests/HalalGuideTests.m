//
//  HalalGuideTests.m
//  HalalGuideTests
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AddressService.h"

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
//    [[AddressService instance] doesAddressExist:@"Humlebækgade" :@"16" :@"2200" :^(Adgangsadresse *address) {
//
//    }];
//    [[AddressService instance] cityNameFor:@"2200" :^(NSString *cityName) {
//
//    }];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:55.690392 longitude:12.542331];
    [AddressService addressNearPosition:loc onCompletion:^(NSArray *address) {

    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
