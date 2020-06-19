//
//  UIColor+WHLTransform.h
//  SingleMentoring
//
//  Created by Haolin Wang on 15/12/11.
//  Copyright © 2015年 lyd. All rights reserved.
//


#import <UIKit/UIKit.h>

/** 其他颜色转换为UIColor */

@interface UIColor (WHLTransform)
/** 十六进制颜色转换 */
+ (UIColor *)whl_colorWithHexString:(NSString *)color;

+ (UIColor *)whl_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//随机颜色
+ (UIColor *)whl_randomColor;

@end
