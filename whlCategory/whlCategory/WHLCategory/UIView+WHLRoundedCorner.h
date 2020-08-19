//
//  UIView+WHL_RoundedCorner.h
//  CrudeOilThrough
//
//  Created by Haolin Wang on 2020/7/18.
//  Copyright © 2020 wanglz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WHLRoundedCorner)

/**
 设置某个圆角
 @param size 圆角大小
 @param left 上左
 @param right 上右
 @param bottomLeft 下左
 @param bottomRight 下右
 */
- (void)whl_setRadiusWithRoundedRect:(CGRect)RoundedRect RadiiSize:(CGSize)size left:(BOOL)left right:(BOOL)right bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight;

/**
设置某个圆角和边框
@param size 圆角大小
@param left 上左
@param right 上右
@param bottomLeft 下左
@param bottomRight 下右
@param borderWidth 边框宽度
@param borderColor 边框颜色
*/
- (void)whl_setRadiusWithRoundedRect:(CGRect)RoundedRect RadiiSizeSize:(CGSize)size left:(BOOL)left right:(BOOL)right bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 设置某个边的边框
 @param top 上
 @param left 左
 @param bottom 下
 @param right 右
 @param color 颜色
  @param width 宽度
 */
- (void)whl_setBorderWithRoundedRect:(CGRect)RoundedRect RadiiSizeSize:(CGSize)size Top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

@end


