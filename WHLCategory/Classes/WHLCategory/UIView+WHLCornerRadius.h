//
//  UIView+WHLCornerRadius.h
//  wanglzThirdLib
//
//  Created by 王浩霖 on 2017/8/1.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (WHLCornerRadius)

@property (nonatomic, assign) IBInspectable CGFloat whl_cornerRadius;
@property (nonatomic, assign) IBInspectable UIColor *whl_borderColor;
@property (nonatomic, assign) IBInspectable CGFloat whl_borderWidth;

@end
