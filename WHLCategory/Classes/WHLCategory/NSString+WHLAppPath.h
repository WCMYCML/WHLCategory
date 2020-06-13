//
//  NSString+WHLAppPath.h
//
//  Created by 王浩霖 on 16/7/19.
//  Copyright © 2016年 王浩霖. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  app中常用沙盒路径
 */
@interface NSString (WHLAppPath)
/**
 *  获取沙盒路径
 *
 *  @return 路径
 */
+ (NSString *)whl_getSandboxDirectory;

/**
 *  获取沙盒下App路径
 *
 *  @return 路径
 */
+ (NSString *)whl_getAppDirectory;

/**
 *  获取沙盒下Document
 *
 *  @return 路径
 */
+ (NSString *)whl_getDocumentDirectory;

/**
 *  获取沙盒下Libary目录
 *
 *  @return 路径
 */
+ (NSString *)whl_getLibaryDirectory;

/**
 *  获取沙盒下Libary目录下Caches目录
 *
 *  @return 路径
 */
+ (NSString *)whl_getCachesDirectory;

/**
 *  获取沙盒下temp目录
 *
 *  @return 路径
 */
+ (NSString *)whl_getTempDirectory;

@end
