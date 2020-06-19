//
//  UITextField+WHLPlaceholder.m
//
//  Created by Haolin Wang on 2017/7/3.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import "UITextField+WHLPlaceholder.h"
#import <objc/message.h>

NSString *const whlPlaceholderColorName = @"whlplaceholderColor";

@implementation UITextField (WHLPlaceholder)

//+ (void)load
//{
//
//    // 获取setPlaceholder
//    Method setPlaceholder = class_getInstanceMethod(self, @selector(setPlaceholder:));
//    // 获取bs_setPlaceholder
//    Method bs_setPlaceholder = class_getInstanceMethod(self, @selector(bs_setPlaceholder:));
//    // 交换方法
//    method_exchangeImplementations(setPlaceholder, bs_setPlaceholder);
//
//}
// 需要给系统UITextField添加属性,只能使用runtime

- (void)setWhl_placeholderColor:(UIColor *)whl_placeholderColor
{
    // 设置关联
    objc_setAssociatedObject(self, (__bridge const void *)(whlPlaceholderColorName), whl_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 设置占位文字颜色
    UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];

    placeholderLabel.textColor = whl_placeholderColor;
}

- (UIColor *)placeholderColor
{
    // 返回关联

    return objc_getAssociatedObject(self, (__bridge const void *)(whlPlaceholderColorName));
}

//// 设置占位文字,并且设置占位文字颜色
//- (void)bs_setPlaceholder:(NSString *)placeholder
//{
//
//    // 1.设置占位文字
//    [self bs_setPlaceholder:placeholder];
//    // 2.设置占位文字颜色
//    self.placeholderColor = self.placeholderColor;
//
//}

@end
