//
//  UIView+WHLNibLoad.m
//  DramaBaseProject
//
//  Created by 王浩霖 on 2017/9/11.
//  Copyright © 2017年 王浩霖. All rights reserved.
//

#import "UIView+WHLNibLoad.h"

@implementation UIView (WHLNibLoad)

+ (instancetype)whl_viewFromNibWithFrame:(CGRect)frame {

    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    view.frame = frame;
    return view;
}

+ (instancetype)whl_CreatFromNibWithClassName:(NSString *)classStr WithFrame:(CGRect)frame{

   UIView  * view = [[[NSBundle mainBundle] loadNibNamed:classStr owner:nil options:nil] firstObject];
    view.frame = frame;
    return view;

}

@end
