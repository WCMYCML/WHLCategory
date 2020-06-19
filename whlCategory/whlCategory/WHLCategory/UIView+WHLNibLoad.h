//
//  UIView+WHLNibLoad.h
//
//  Created by Haolin Wang on 2017/9/11.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WHLNibLoad)

+ (instancetype)whl_viewFromNibWithFrame:(CGRect)frame;

+ (instancetype)whl_CreatFromNibWithClassName:(NSString *)classStr WithFrame:(CGRect)frame;

@end
