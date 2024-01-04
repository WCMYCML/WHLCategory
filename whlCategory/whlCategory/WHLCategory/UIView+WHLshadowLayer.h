//
//  UIView+WHL_shadowLayer.h
//  CrudeOilThrough
//
//  Created by 王浩霖 on 2019/7/5.
//  Copyright © 2019 wanglz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,whl_GradientChangeDirection) {
    whl_GradientChangeHorizontal, //水平方向渐变
    whl_GradientChangeVertical,//垂直方向渐变
    whl_GradientChangeUpwardDiagonalLine,  //主对角线方向渐变
    whl_GradientChangeDownDiagonalLine,//副对角线方向渐变
};



@interface UIView (WHLshadowLayer)


/// 设置背景图阴影
/// @param radius 阴影半径
/// @param shadowColor 阴影颜色
/// @param offsetSize 偏移量
/// @param cornerRadius 圆角
- (void)whl_setLayerBackShadowWithRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor offset:(CGSize)offsetSize cornerRadius:(CGFloat)cornerRadius;


/// 设置渐变色
/// @param size 渐变区域大小
/// @param direction 颜色方向
/// @param startcolor 开始颜色
/// @param endColor 结束颜色
- (void)whl_colorGradientChangeWithSize:(CGSize)size direction:(whl_GradientChangeDirection)direction startColor:(UIColor*)startcolor endColor:(UIColor*)endColor;


@end

