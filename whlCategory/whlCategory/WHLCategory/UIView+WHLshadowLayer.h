//
//  UIView+WHL_shadowLayer.h
//  CrudeOilThrough
//
//  Created by 王浩霖 on 2019/7/5.
//  Copyright © 2019 wanglz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WHLshadowLayer)


/// 设置背景图阴影
/// @param radius 阴影半径
/// @param shadowColor 阴影颜色
/// @param offsetSize 偏移量
/// @param cornerRadius 圆角
- (void)whl_setLayerBackShadowWithRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor offset:(CGSize)offsetSize cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
