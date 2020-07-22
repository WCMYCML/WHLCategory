//
//  UIView+WHL_RoundedCorner.m
//  CrudeOilThrough
//
//  Created by 王浩霖 on 2020/7/18.
//  Copyright © 2020 wanglz. All rights reserved.
//

#import "UIView+WHLRoundedCorner.h"

@implementation UIView (WHLRoundedCorner)

- (void)whl_setRadiusWithRoundedRect:(CGRect)RoundedRect RadiiSize:(CGSize)size left:(BOOL)left right:(BOOL)right bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight{
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    UIRectCorner topLeft = 0;
    UIRectCorner topRight = 0;
    UIRectCorner BottomLeft = 0;
    UIRectCorner BottomRight = 0;
    CGRect Rect = RoundedRect;
    if (left) {
        topLeft = UIRectCornerTopLeft;
    }
    if (right) {
        topRight = UIRectCornerTopRight;
    }
    if (bottomLeft) {
        BottomLeft = UIRectCornerBottomLeft;
    }
    if (bottomRight) {
        BottomRight = UIRectCornerBottomRight;
    }
    if (CGRectIsNull(RoundedRect) ) {
        Rect = self.bounds;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:Rect byRoundingCorners:topLeft | topRight | BottomLeft | BottomRight cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = Rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)whl_setRadiusWithRoundedRect:(CGRect)RoundedRect RadiiSizeSize:(CGSize)size left:(BOOL)left right:(BOOL)right bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    UIRectCorner topLeft = 0;
    UIRectCorner topRight = 0;
    UIRectCorner BottomLeft = 0;
    UIRectCorner BottomRight = 0;
    CGRect Rect = RoundedRect;

    if (left) {
        topLeft = UIRectCornerTopLeft;
    }
    if (right) {
        topRight = UIRectCornerTopRight;
    }
    if (bottomLeft) {
        BottomLeft = UIRectCornerBottomLeft;
    }
    if (bottomRight) {
        BottomRight = UIRectCornerBottomRight;
    }
    
    if (CGRectIsNull(RoundedRect)) {
           Rect = self.bounds;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:Rect byRoundingCorners:topLeft | topRight | BottomLeft | BottomRight cornerRadii:size];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = Rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = maskPath.CGPath;
    borderLayer.frame = Rect;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.lineWidth = borderWidth;
    borderLayer.strokeColor = borderColor.CGColor;
    [self.layer addSublayer:borderLayer];
}


- (void)whl_setBorderWithRoundedRect:(CGRect)RoundedRect RadiiSizeSize:(CGSize)size Top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width{
    
    CGRect Rect = RoundedRect;
    
    if (CGRectIsNull(RoundedRect)) {
           Rect = self.frame;
    }

    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, Rect.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, Rect.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, Rect.size.height - width, Rect.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(Rect.size.width - width, 0, width, Rect.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}


@end
