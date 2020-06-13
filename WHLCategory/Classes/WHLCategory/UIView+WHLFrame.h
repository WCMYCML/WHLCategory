//
//  UIView+WHLFrame.h
//
//  Created by 王浩霖 on 15/10/9.
//  Copyright © 2015年 Zrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  快速获取view的位置,大小属性
 */
@interface UIView (WHLFrame)

@property (nonatomic) CGFloat whl_x;
@property (nonatomic) CGFloat whl_y;
@property (nonatomic) CGFloat whl_width;
@property (nonatomic) CGFloat whl_height;
@property (nonatomic) CGFloat whl_centerX;
@property (nonatomic) CGFloat whl_centerY;
@property (nonatomic) CGSize whl_size;
@property (nonatomic) CGPoint whl_origin;
@property (nonatomic, readonly) CGFloat whl_bottom;

@end
