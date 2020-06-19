//
//  UIView+WHLFrame.m
//
//  Created by Haolin Wang on 15/10/9.
//  Copyright © 2015年 Zrocky. All rights reserved.
//

#import "UIView+WHLFrame.h"

@implementation UIView (WHLFrame)

- (void)setWhl_x:(CGFloat)whl_x
{
    CGRect frame = self.frame;
    frame.origin.x = whl_x;
    self.frame = frame;
}

- (CGFloat)whl_x
{
    return self.frame.origin.x;
}

- (void)setWhl_y:(CGFloat)whl_y
{
    CGRect frame = self.frame;
    frame.origin.y = whl_y;
    self.frame = frame;
}

- (CGFloat)whl_y
{
    return self.frame.origin.y;
}

- (void)setWhl_width:(CGFloat)whl_width
{
    CGRect frame = self.frame;
    frame.size.width = whl_width;
    self.frame = frame;
}

- (CGFloat)whl_width
{
    return self.frame.size.width;
}

- (void)setWhl_height:(CGFloat)whl_height
{
    CGRect frame = self.frame;
    frame.size.height = whl_height;
    self.frame = frame;
}

- (CGFloat)whl_height
{
    return self.frame.size.height;
}

- (CGFloat)whl_bottom {
    return self.whl_y + self.whl_height;
}

- (void)setWhl_centerX:(CGFloat)whl_centerX {
    CGPoint center = self.center;
    center.x = whl_centerX;
    self.center = center;
}

- (CGFloat)whl_centerX {
    return self.center.x;
}

- (void)setWhl_centerY:(CGFloat)whl_centerY {
    CGPoint center = self.center;
    center.y = whl_centerY;
    self.center = center;
}

- (CGFloat)whl_centerY {
    return self.center.y;
}

- (void)setWhl_size:(CGSize)whl_size
{
    CGRect frame = self.frame;
    frame.size = whl_size;
    self.frame = frame;
}

- (CGSize)whl_size
{
    return self.frame.size;
}

- (void)setWhl_origin:(CGPoint)whl_origin
{
    CGRect frame = self.frame;
    frame.origin = whl_origin;
    self.frame = frame;
}

- (CGPoint)whl_origin
{
    return self.frame.origin;
}

@end
