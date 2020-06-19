//
//  UIBarButtonItem+WHLCreate.m
//
//  Created by Haolin Wang on 2017/9/8.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import "UIBarButtonItem+WHLCreate.h"

@implementation UIBarButtonItem (WHLCreate)

+ (UIBarButtonItem *)whl_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image {
    return [self whl_itemWithTarget:target action:action nomalImage:image higeLightedImage:nil imageEdgeInsets:UIEdgeInsetsZero];
}

+ (UIBarButtonItem *)whl_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    return [self whl_itemWithTarget:target action:action nomalImage:image higeLightedImage:nil imageEdgeInsets:imageEdgeInsets];
}

+ (UIBarButtonItem *)whl_itemWithTarget:(id)target
                                 action:(SEL)action
                             nomalImage:(UIImage *)nomalImage
                       higeLightedImage:(UIImage *)higeLightedImage
                        imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (higeLightedImage) {
        [button setImage:higeLightedImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    if (button.bounds.size.height > 40) {
        CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 40, height);
    }
    button.imageEdgeInsets = imageEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)whl_itemWithTarget:(id)target action:(SEL)action title:(NSString *)title {
    return [self whl_itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
}

+ (UIBarButtonItem *)whl_itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    return [self whl_itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:titleEdgeInsets];
}

+ (UIBarButtonItem *)whl_itemWithTarget:(id)target
                                 action:(SEL)action
                                  title:(NSString *)title
                                   font:(UIFont *)font
                             titleColor:(UIColor *)titleColor
                       highlightedColor:(UIColor *)highlightedColor
                        titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font ? font : nil;
    [button setTitleColor:titleColor ? titleColor : [UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor ? highlightedColor : nil forState:UIControlStateHighlighted];

    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    if (button.bounds.size.height > 40) {
        CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 40, height);
    }
    button.titleEdgeInsets = titleEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)whl_fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end
