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



@end
