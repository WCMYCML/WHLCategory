//
//  UITextView+WHLPlaceholder.h
//
//  Created by Haolin Wang on 16/4/14.
//
//

#import <UIKit/UIKit.h>

@interface UITextView (WHLPlaceholder)

@property (nonatomic, copy) NSString *whl_placeholderText;
@property (nonatomic, strong) UIColor *whl_placeholderColor;
@property (nonatomic, assign) NSUInteger whl_textMaximumLength;//最大输入字数

@end

@interface UITextView (WHLRange)

/// 获取光标位置
- (NSRange)whl_selectedRange;

/// 设置光标位置
/// @param range 光标位置
- (void)whl_setSelectedRange:(NSRange)range;

@end
