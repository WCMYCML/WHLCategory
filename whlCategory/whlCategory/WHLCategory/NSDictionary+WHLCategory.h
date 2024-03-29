//
//  NSDictionary+WHLCategory.h
//
//  Created by Haolin Wang.li on 8/15/16.
//  Copyright © 2016 QYLive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WHLCategory)

/**
 *  通过key获取值，如果key不存在或者值为空则放回默认设置值
 *
 *  @param key   主键
 *  @param def 默认值
 */

- (id)whl_GetObjectWithKey:(NSString *)key defaultValue:(id)def;

/**
 *  通过key获取字符串
 *
 *  @param key 主键
 *
 *  @return 字符串值
 */
- (NSString *)whl_stringForKey:(NSString *)key;

- (int)whl_intForKey:(NSString *)key;
- (long)whl_longForKey:(NSString *)key;
- (long)whl_booleanForKey:(NSString *)key;



/// 字典转Json字符串
- (NSString *)whl_dictionaryToJsonString;

/// 字典转Json字符串（无空格和回车）
- (NSString *)whl_dictionaryToJsonStringNoSpace;


@end
