//
//  NSObject+whlDictPhysical.m
//  CrudeOilThrough
//
//  Created by 浩霖 on 2019/3/15.
//  Copyright © 2019 wanglz. All rights reserved.
//

#import "NSObject+WHLDictPhysical.h"

@implementation NSObject (WHLDictPhysical)

- (id)whl_getObjectFromDictWithKey:(NSString *)key defaultValue:(id)def
{
    if (!key) return def;
    if (![self isKindOfClass:[NSDictionary class]]) {
        return def;
    }
    NSDictionary *dict = (NSDictionary *)self;

    id value = dict[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return value;
    return def;
}

- (id)whl_getObjectFromArrWithKey:(NSInteger)index defaultValue:(id)def {
    if (![self isKindOfClass:[NSArray class]]) {
        return def;
    }

    NSArray *currentArr = (NSArray *)self;
    if (currentArr.count <= index) {
        return def;
    }

    id value = currentArr[index];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return value;
    return def;
}

@end
