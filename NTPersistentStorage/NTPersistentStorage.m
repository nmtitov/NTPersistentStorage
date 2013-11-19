//
//  NTPersistentStorage.m
//  NTPersistentStorage
//
//  Created by Nikita Titov on 19.11.13.
//  Copyright (c) 2013 Nikita Titov. All rights reserved.
//


#import "NTPersistentStorage.h"


NSString * const set = @"set";
NSString * const persistent = @"persistent";


@implementation NTPersistentStorage

// Designated initializer.
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self) {
        self.userDefaults = userDefaults;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
}

- (void)persist
{
    [self.userDefaults synchronize];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSString *stringSelector = NSStringFromSelector(selector);
    NSInteger parameterCount = [[stringSelector componentsSeparatedByString:@":"] count] - 1;
    if (parameterCount == 0) {
        return [super methodSignatureForSelector:@selector(valueForKey:)];
    }
    else if (parameterCount == 1 && [stringSelector hasPrefix:@"set"]) {
        return [super methodSignatureForSelector:@selector(setValue:forKey:)];
    }
    [self doesNotRecognizeSelector:selector];
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *stringSelector = NSStringFromSelector(invocation.selector);
    NSString *key;
    if ([stringSelector hasPrefix:set]) {
        NSString *raw = [stringSelector substringWithRange:NSMakeRange(3, [stringSelector length] - 4)];
        NSString *head = [raw substringToIndex:1];
        NSString *tail = [raw substringFromIndex:1];
        key = [[head lowercaseString] stringByAppendingString:tail];
        id obj;
        [invocation getArgument:&obj atIndex:2];
        [self setValue:obj forKey:key];
    }
    else {
        key = stringSelector;
        id obj = [self valueForKey:key];
        [invocation setReturnValue:&obj];
    }
}


- (id)valueForKey:(NSString *)key
{
    if ([key hasPrefix:persistent]) {
        if ([self.userDefaults.dictionaryRepresentation.allKeys containsObject:key]) {
            return [self.userDefaults objectForKey:key];
        }
        else {
            if ([[self.defaultValues allKeys] containsObject:key]) {
                return self.defaultValues[key];
            }
            else {
                return nil;
            }
        }
    }
    else {
        return [super valueForKey:key];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key hasPrefix:persistent]) {
        [self.userDefaults setObject:value forKey:key];
        if (self.shouldPersistOnEachSet) {
            [self persist];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
