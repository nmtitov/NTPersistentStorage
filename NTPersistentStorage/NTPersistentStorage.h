//
//  NTPersistentStorage.h
//  NTPersistentStorage
//
//  Created by Nikita Titov on 19.11.13.
//  Copyright (c) 2013 Nikita Titov. All rights reserved.
//


#import <Foundation/Foundation.h>


// NTPersistentStorage stores data in persistent storage (`NSUserDefaults`).
// All properties that start with `persistent-` keyword will be saved on `-persist` call
// which usually should be made before application lifecycle ends.
// Primitive values should be wrapped using `NSNumber` boxing technique which is described on pawzzle.net:
// https://pawzzle.net/posts/24


@interface NTPersistentStorage : NSObject

// Designated initializer.
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

@property (assign, nonatomic) BOOL shouldPersistOnEachSet;

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSDictionary *defaultValues;

- (void)persist;

@end
