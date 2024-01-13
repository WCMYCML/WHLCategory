//
//  UITextField+WHLPlaceholder.m
//
//  Created by Haolin Wang on 2017/7/3.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import "UITextField+WHLPlaceholder.h"
#import <objc/message.h>
#import <objc/runtime.h>

static char kMaxLength;

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

/// 获取光标位置
- (NSRange)whl_selectedRange {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

/// 设置光标位置
/// @param range 光标位置
- (void)whl_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

#pragma mark - setters | getters

- (void)setYp_maxLength:(NSUInteger)whl_maxLength {
    objc_setAssociatedObject(self, &kMaxLength, @(whl_maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (whl_maxLength) {
        [self addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (NSUInteger)whl_maxLength {
    NSNumber *number = objc_getAssociatedObject(self, &kMaxLength);
    return [number unsignedIntegerValue];
}

- (void)textChange:(UITextField *)textField {
    NSString *destText = textField.text;
    NSUInteger maxLength = textField.whl_maxLength;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (destText.length > maxLength) {
            NSRange range;
            NSUInteger inputLength = 0;
            for (int i = 0; i < destText.length && inputLength <= maxLength; i += range.length) {
                range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
                inputLength += [destText substringWithRange:range].length;
                if (inputLength > maxLength) {
                    NSString *newText = [destText substringWithRange:NSMakeRange(0, range.location)];
                    textField.text = newText;
                }
            }
        }
    }
}

@end
