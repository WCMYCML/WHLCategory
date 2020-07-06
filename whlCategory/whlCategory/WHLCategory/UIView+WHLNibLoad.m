//
//  UIView+WHLNibLoad.m
//  DramaBaseProject
//
//  Created by Haolin Wang on 2017/9/11.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import "UIView+WHLNibLoad.h"

@implementation UIView (WHLNibLoad)

+ (instancetype)whl_viewFromNibWithFrame:(CGRect)frame {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    view.frame = frame;
    return view;
}

+ (instancetype)whl_creatFromNibWithClassName:(NSString *)classStr WithFrame:(CGRect)frame {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:classStr owner:nil options:nil] firstObject];
    view.frame = frame;
    return view;
}

@end
