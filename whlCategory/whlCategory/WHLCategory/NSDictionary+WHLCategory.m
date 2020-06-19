//
//  NSDictionary+WHLCategory.m
//  QYLive
//
//  Created by Haolin Wang.li on 8/15/16.
//  Copyright © 2016 QYLive. All rights reserved.
//

#import "NSDictionary+WHLCategory.h"

@implementation NSDictionary (WHLCategory)

- (id)whl_GetObjectWithKey:(NSString *)key defaultValue:(id)def
{
    if (!key) return def;
    if (![self isKindOfClass:[NSDictionary class]]) {
        return def;
    }
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return value;
    return def;
}

- (NSString *)whl_stringForKey:(NSString *)key {
    return [self whl_GetObjectWithKey:key defaultValue:@""];
}

- (int)whl_intForKey:(NSString *)key {
    return [[self whl_GetObjectWithKey:key defaultValue:@(0)] intValue];
}

- (long)whl_longForKey:(NSString *)key {
    NSString *value = (NSString *)[self whl_GetObjectWithKey:key defaultValue:@(0)];
    return [value longLongValue];
}

- (long)whl_booleanForKey:(NSString *)key {
    NSString *value = (NSString *)[self whl_GetObjectWithKey:key defaultValue:@(0)];
    return [value boolValue];
}

@end
