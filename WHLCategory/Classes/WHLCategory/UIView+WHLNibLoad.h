//
//  UIView+WHLNibLoad.h
//
//  Created by 王浩霖 on 2017/9/11.
//  Copyright © 2017年 王浩霖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WHLNibLoad)

+ (instancetype)whl_viewFromNibWithFrame:(CGRect)frame;

+ (instancetype)whl_CreatFromNibWithClassName:(NSString *)classStr WithFrame:(CGRect)frame;

@end
