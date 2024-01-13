//
//  UITextField+WHLPlaceholder.h
//
//  Created by Haolin Wang on 2017/7/3.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextField (WHLPlaceholder)

@property (nonatomic, strong) UIColor *whl_placeholderColor;


/// 设置输入框输入长度
@property (assign, nonatomic) IBInspectable NSUInteger whl_maxLength;

/// 获取光标位置
- (NSRange)whl_selectedRange;

/// 设置光标位置
/// @param range 光标位置
- (void)whl_setSelectedRange:(NSRange)range;



@end
