//
//  UIView+WHL_shadowLayer.m
//  CrudeOilThrough
//
//  Created by 王浩霖 on 2019/7/5.
//  Copyright © 2019 wanglz. All rights reserved.
//

#import "UIView+WHLshadowLayer.h"

@implementation UIView (WHLshadowLayer)


- (void)whl_setLayerBackShadowWithRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor offset:(CGSize)offsetSize cornerRadius:(CGFloat)cornerRadius{
    
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = offsetSize;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.cornerRadius = cornerRadius;

}


- (void)whl_colorGradientChangeWithSize:(CGSize)size direction:(whl_GradientChangeDirection)direction startColor:(UIColor*)startcolor endColor:(UIColor*)endColor{
    
   
    if (startcolor == nil || endColor == nil) {
        return;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    
    CGPoint startPoint = CGPointZero;

    if (direction == whl_GradientChangeDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }

    gradientLayer.startPoint = startPoint;

    CGPoint endPoint = CGPointZero;

    switch (direction) {
        case whl_GradientChangeHorizontal:

            endPoint = CGPointMake(1.0, 0.0);

            break;

        case whl_GradientChangeVertical:

            endPoint = CGPointMake(0.0, 1.0);

            break;

        case whl_GradientChangeUpwardDiagonalLine:

            endPoint = CGPointMake(1.0, 1.0);

            break;

        case whl_GradientChangeDownDiagonalLine:

            endPoint = CGPointMake(1.0, 0.0);

            break;

        default:

            break;
    }

    gradientLayer.endPoint = endPoint;
    if (size.width == 0.0 || size.height == 0.0) {
       gradientLayer.frame = self.bounds; // CGRectMake(0, 0, s, 100);
    }else{
        gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    }
    [self.layer insertSublayer:gradientLayer atIndex:0];

    
}


@end
