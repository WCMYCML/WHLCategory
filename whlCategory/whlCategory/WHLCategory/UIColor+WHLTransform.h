//
//  UIColor+WHLTransform.h
//  SingleMentoring
//
//  Created by Haolin Wang on 15/12/11.
//  Copyright © 2015年 lyd. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WHLGradientChangeDirection) {
    WHLGradientChangeDirectionHorizontal, //水平方向渐变
    WHLGradientChangeDirectionVertical,//垂直方向渐变
    WHLGradientChangeDirectionUpwardDiagonalLine,  //主对角线方向渐变
    WHLGradientChangeDirectionDownDiagonalLine,//副对角线方向渐变
};


/** 其他颜色转换为UIColor */

@interface UIColor (WHLTransform)
/** 十六进制颜色转换 */
+ (UIColor *)whl_colorWithHexString:(NSString *)color;

+ (UIColor *)whl_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


/// hex值设置颜色
/// @param hexValue  0xffffff
/// @param alphaValue 透明度 0~1
+ (UIColor *)whl_colorWithHexValue:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)whl_colorWithHexValue:(NSInteger)hexValue;


/// 具体颜色值转换成哈希字符串
/// @param color 颜色值
+ (NSString *)whl_getHexValueStrFromColor:(UIColor *)color;


//随机颜色
+ (UIColor *)whl_randomColor;


/// 适配暗黑模式颜色   传入的UIColor对象
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)whl_colorWithLightColor:(UIColor *)lightColor DarkColor:(UIColor *)darkColor;

/// 适配暗黑模式颜色   颜色传入的是16进制字符串
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)whl_colorWithLightColorStr:(NSString *)lightColor DarkColor:(NSString *)darkColor;

/// 适配暗黑模式颜色   颜色传入的是16进制字符串 还有颜色的透明度
/// @param lightColor 普通模式颜色
/// @param lightAlpha 普通模式颜色透明度
/// @param darkColor 暗黑模式颜色透明度
/// @param darkAlpha 暗黑模式颜色
+ (UIColor *)whl_colorWithLightColorStr:(NSString *)lightColor WithLightColorAlpha:(CGFloat)lightAlpha DarkColor:(NSString *)darkColor WithDarkColorAlpha:(CGFloat)darkAlpha;

/// 创建渐变颜色
/// @param size 渐变size
/// @param direction 渐变方向
/// @param startcolor 开始渐变颜色
/// @param endColor 结束颜色

+ (UIColor *)whl_colorGradientChangeWithSize:(CGSize)size direction:(WHLGradientChangeDirection)direction startColor:(UIColor*)startcolor endColor:(UIColor*)endColor;


#pragma mark - ******************** 颜色RGB变化 **************************

/// 获取颜色的 R G  B值数组
/// @param originColor 原始颜色
- (NSArray *)whl_getRGBDictionaryByColor:(UIColor *)originColor;

/// 计算出连个颜色之间的色差
/// @param beginColor 开始颜色
/// @param endColor 结束颜色
- (NSArray *)whl_transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor;

/// 最后通过过渡系数来返回当前的颜色
/// @param beginColor 颜色
/// @param coe 过渡系数 0-1 过渡
/// @param marginArray  连续颜色变化参数 通过 whl_transColorBeginColor: andEndColor: 获得
- (UIColor *)whl_getColorWithColor:(UIColor *)beginColor andCoe:(double)coe andMarginArray:(NSArray<NSNumber *> *)marginArray;


@end
