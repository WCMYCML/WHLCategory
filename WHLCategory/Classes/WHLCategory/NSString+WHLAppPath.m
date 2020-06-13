//
//  NSString+WHLAppPath.m
//
//  Created by 王浩霖 on 16/7/19.
//  Copyright © 2016年 王浩霖. All rights reserved.
//

#import "NSString+WHLAppPath.h"

@implementation NSString (WHLAppPath)
/**
 *  获取沙盒路径
 *  @return 路径
 */
+ (NSString *)whl_getSandboxDirectory {
    return NSHomeDirectory();
}

/**
 *  获取沙盒下App路径
 *  @return 路径
 */
+ (NSString *)whl_getAppDirectory {
    return [[NSBundle mainBundle] resourcePath];
}

/**
 *  获取沙盒下Document
 *
 *  @return 路径
 */
+ (NSString *)whl_getDocumentDirectory {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [array lastObject];
}

/**
 *  获取沙盒下Libary目录
 *
 *  @return 路径
 */
+ (NSString *)whl_getLibaryDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取沙盒下Libary目录下Caches目录
 *
 *  @return 路径
 */
+ (NSString *)whl_getCachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取沙盒下temp目录
 *
 *  @return 路径
 */
+ (NSString *)whl_getTempDirectory {
    return NSTemporaryDirectory();
}

@end
