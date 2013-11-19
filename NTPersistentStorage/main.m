//
//  main.m
//  NTPersistentStorage
//
//  Created by Nikita Titov on 19.11.13.
//  Copyright (c) 2013 Nikita Titov. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NTPersistentStorage.h"


@interface GeometryStorage : NTPersistentStorage

@property (strong, nonatomic) NSNumber *persistentWidth;
@property (strong, nonatomic) NSNumber *persistentHeight;

@end


@implementation GeometryStorage

@dynamic persistentWidth;
@dynamic persistentHeight;

@end


int main(int argc, const char * argv[])
{
    @autoreleasepool {
        GeometryStorage *storage = [[GeometryStorage alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
        NSLog(@"Stored values are (%d, %d). Now restart me.", storage.persistentWidth.intValue, storage.persistentHeight.intValue);

        storage.persistentWidth = @640;
        storage.persistentHeight = @480;
        [storage persist];
    }
    
    return 0;
}

