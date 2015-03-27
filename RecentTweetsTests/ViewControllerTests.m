//
//  ViewControllerTests.m
//  RecentTweets
//
//  Created by Supreeth on 27/03/15.
//  Copyright (c) 2015 Supreeth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ViewControllerTests : XCTestCase
@property (nonatomic) ViewController *vcTest;

@end

@implementation ViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.vcTest = [[ViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testRemoveDuplicates {
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"Mercedes-Benz", @"BMW", @"Porsche",
                                                             @"Opel", @"Volkswagen", @"Audi"]];
  
    [self.vcTest removeObjectsFrom:array IfObjectsMoreThan:5];
    
    NSArray *newArray =@[@"Mercedes-Benz", @"BMW", @"Porsche",
                         @"Opel", @"Volkswagen"];
    
    XCTAssertEqualObjects(newArray, array,"Not Equal");
}

@end
