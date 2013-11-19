//
//  NTPersistentStorageTests.m
//  NTPersistentStorage
//
//  Created by Nikita Titov on 19.11.13.
//  Copyright (c) 2013 Nikita Titov. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "NTPersistentStorage.h"


// We need a subclass NTPersistentStorage with custom properties
@interface MyPersistentStorage : NTPersistentStorage

@property (strong, nonatomic) NSString *regularValue;
@property (strong, nonatomic) NSNumber *persistentValue;

@end


@implementation MyPersistentStorage

@dynamic persistentValue;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;
{
    self = [super initWithUserDefaults:userDefaults];
    if (self) {
        self.defaultValues = @{
                               @"persistentValue":    @42,
                               };
    }
    return self;
}

@end


@interface NTPersistentStorageTests : XCTestCase

@end


@implementation NTPersistentStorageTests

- (void)testDefaultValueOfPersistentProperty
{
    MyPersistentStorage *storage = [[MyPersistentStorage alloc] initWithUserDefaults:nil];
    XCTAssert([storage.persistentValue isEqual:@42]);
}

- (void)testPersistentPropertyStorage
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];

    @autoreleasepool {
        MyPersistentStorage *storage = [[MyPersistentStorage alloc] initWithUserDefaults:userDefaults];
        storage.persistentValue = @64;
        [storage persist];
    }
    
    @autoreleasepool {
        MyPersistentStorage *storage = [[MyPersistentStorage alloc] initWithUserDefaults:userDefaults];
        XCTAssert([storage.persistentValue isEqual:@64]);
    }
}

- (void)testRegularValue
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    MyPersistentStorage *storage = [[MyPersistentStorage alloc] initWithUserDefaults:userDefaults];
    storage.regularValue = @"test me!";
    XCTAssert([storage.regularValue isEqualToString:@"test me!"]);
}

@end
