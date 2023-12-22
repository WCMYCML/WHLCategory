//
//  NSData+Category.h
//  QingDaoCA
//
//  Created by yongsheng.li on 14/05/2017.
//  Copyright © 2017 qingdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (Category)

- (NSDictionary *)toDictionary;



/// 浮点数精度处理
/// - Parameters:
///   - scale: 精确位数
///   - model: 模式 默认NSRoundPlain
///   - originalValue: 原始值
+ (float)getDecimalNumberScale:(NSInteger)scale RoundingMode:(NSRoundingMode)model OriginalValue:(float)originalValue;


/// 浮点字符串精度处理
/// - Parameters:
///   - scale: 精确位数
///   - model: 模式 默认NSRoundPlain
///   - originalStr: 原始值 Str
+ (float)getDecimalNumberScale:(NSInteger)scale RoundingMode:(NSRoundingMode)model OriginalValueStr:(NSString*)originalStr;




/// 浮点字符串精度处理
/// - Parameters:
///   - scale: 精确位数
///   - model: 模式 默认NSRoundPlain
///   - originalStr: 原始值 Str
///   @“0.01499999”  2  @0.02""
+ (NSString *)getDecimalNumberStrScale:(NSInteger)scale RoundingMode:(NSRoundingMode)model OriginalValueStr:(NSString*)originalStr;

#pragma mark -🔥********* 加减乘除 ***********


/// 两数据 相加
/// - Parameters:
///   - firstNumStr:
///   - SecondNumStr:
///   - scale: 精度
///   - model: 精度模式
+ (NSString *)getAdd_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model;


/// 相减
/// - Parameters:
///   - firstNumStr:
///   - SecondNumStr:
///   - scale:
///   - model:
+ (NSString *)getSubtracting_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model;


/// 相乘
/// - Parameters:
///   - firstNumStr:
///   - SecondNumStr:
///   - scale:
///   - model:
+ (NSString *)getMultiplying_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model;


/// 相除 除数不能为0
/// - Parameters:
///   - firstNumStr:
///   - SecondNumStr:
///   - scale:
///   - model:
+ (NSString *)getDividing_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model;

/// 大于
/// - Parameters:
///   - firstNumStr:
///   - SecondNumStr:
+ (BOOL)getMaxthan_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr;

/// 等于
/// - Parameters:
///   - firstNumStr:
///   - SecondNumStr:
+ (BOOL)getEqualthan_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr;


@end
