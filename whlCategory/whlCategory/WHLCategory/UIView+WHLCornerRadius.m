//
//  UIView+WHLCornerRadius.m
//
//  Created by Haolin Wang on 2017/8/1.
//  Copyright © 2017年 wanglz. All rights reserved.
//
//

#import "UIView+WHLCornerRadius.h"

@implementation UIView (WHLCornerRadius)

- (void)setWhl_cornerRadius:(CGFloat)whl_cornerRadius
{
    self.layer.cornerRadius = whl_cornerRadius;
    self.layer.masksToBounds = whl_cornerRadius > 0;
    self.clipsToBounds = YES;
}

- (CGFloat)whl_cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setWhl_borderColor:(UIColor *)whl_borderColor
{
    self.layer.borderColor = whl_borderColor.CGColor;
}

- (UIColor *)whl_borderColor
{
    return self.layer.borderColor;
}

- (void)setWhl_borderWidth:(CGFloat)whl_borderWidth
{
    self.layer.borderWidth = whl_borderWidth;
}

- (CGFloat)whl_borderWidth
{
    return self.layer.borderWidth;
}

@end
