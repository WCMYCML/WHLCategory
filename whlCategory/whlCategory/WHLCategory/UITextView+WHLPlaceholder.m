//
//  UITextView+WHLPlaceholder.m
//
//  Created by Haolin Wang on 16/4/14.
//
//

#import "UITextView+WHLPlaceholder.h"
#import <objc/runtime.h>

static const void *const WHLWZPlaceholderKey = &WHLWZPlaceholderKey;

@interface WHLPlaceholderSupportHelper : NSObject

@property (nonatomic, weak) UITextView *observedTextView;

- (void)textViewTextDidChange:(NSNotification *)notification;

@end

@implementation UITextView (WHLPlaceholder)

- (void)setWhl_placeholderText:(NSString *)whl_placeholderText
{
    if (whl_placeholderText != nil && whl_placeholderText.length > 0) {
        UILabel *placeholderLabel = [self WHLplaceholderLabel];
        placeholderLabel.text = whl_placeholderText;
//        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
    } else {
        [[self placeholderLabelIfLoaded] removeFromSuperview];
        [self setPlaceholderLabel:nil];
    }
}

- (NSString *)placeholderText
{
    return [self placeholderLabelIfLoaded].text;
}

- (UIColor *)whl_placeholderColor{
    return [self placeholderLabelIfLoaded].textColor;

}

- (void)setWhl_placeholderColor:(UIColor *)whl_placeholderColor
{
    UILabel *placeholderLabel = [self WHLplaceholderLabel];
    placeholderLabel.textColor = whl_placeholderColor;
}

#pragma mark - Label

- (UILabel *)placeholderLabelIfLoaded
{
    return objc_getAssociatedObject(self, WHLWZPlaceholderKey);
}

- (UILabel *)WHLplaceholderLabel
{
    UILabel *WHLplaceholderLabel = [self placeholderLabelIfLoaded];
    if (WHLplaceholderLabel == nil) {
        WHLplaceholderLabel = [[UILabel alloc] init];
        WHLplaceholderLabel.userInteractionEnabled = YES;
        WHLplaceholderLabel.multipleTouchEnabled = NO;
        WHLplaceholderLabel.numberOfLines = 0;
        WHLplaceholderLabel.font = (self.font ? : [UIFont systemFontOfSize:14.0f]);
        WHLplaceholderLabel.textColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        [self addSubview:WHLplaceholderLabel];

        WHLplaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *constraints1 = [NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:|-[WHLplaceholderLabel]-|"
                                                     options:(NSLayoutFormatAlignAllLeft)
                                                     metrics:nil
                                                       views:NSDictionaryOfVariableBindings(
                                     WHLplaceholderLabel)];
        [self addConstraints:constraints1];
        NSArray *constraints2 = [NSLayoutConstraint
                                 constraintsWithVisualFormat:@"V:|-[WHLplaceholderLabel]-0@500-|"
                                                     options:(NSLayoutFormatAlignAllLeft)
                                                     metrics:nil
                                                       views:NSDictionaryOfVariableBindings(
                                     WHLplaceholderLabel)];
        [self addConstraints:constraints2];
        [self setPlaceholderLabel:WHLplaceholderLabel];
        WHLPlaceholderSupportHelper *helper = [self WHLPlaceholderSupportHelper];
        WHLplaceholderLabel.hidden = self.text.length > 0;
        [helper setObservedTextView:self];

        static BOOL replaced = NO;
        if (!replaced) {
            Class aClass = [self class];
            SEL oldSelector = @selector(setFont:);
            Method oldMethod = class_getInstanceMethod(aClass, oldSelector);
            Method newMethod = class_getInstanceMethod(aClass, @selector(JWZSetFont:));
//            NSLog(@"❤️交换的旧方法%p", method_getImplementation(oldMethod));
//            NSLog(@"❤️交换的新方法%p", method_getImplementation(newMethod));
            if (!class_addMethod(aClass, oldSelector,
                                 method_getImplementation(newMethod),
                                 method_getTypeEncoding(newMethod))) {
                method_exchangeImplementations(oldMethod, newMethod);
                replaced = YES;
            }
        }
    }

    return WHLplaceholderLabel;
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel
{
    UILabel *oldLabel = [self placeholderLabelIfLoaded];
    if (oldLabel != placeholderLabel) {
        objc_setAssociatedObject(self, WHLWZPlaceholderKey, placeholderLabel,
                                 OBJC_ASSOCIATION_ASSIGN);
    }
}

#pragma mark - 观察者

- (WHLPlaceholderSupportHelper *)WHLPlaceholderSupportHelper
{
    const void *key = (const void *)(WHLWZPlaceholderKey + 1);
    WHLPlaceholderSupportHelper *helper = objc_getAssociatedObject(self, key);
    if (helper == nil) {
        helper = [[WHLPlaceholderSupportHelper alloc] init];
        objc_setAssociatedObject(self, key, helper,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}

#pragma mark - 字数限制

- (void)setWhl_textMaximumLength:(NSUInteger)whl_textMaximumLength
{
    const void *key = (const void *)(WHLWZPlaceholderKey + 2);
    objc_setAssociatedObject(self, key,
                             [NSNumber numberWithInteger:whl_textMaximumLength],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)textMaximumLength
{
    const void *key = (const void *)(WHLWZPlaceholderKey + 2);
    NSUInteger max = [objc_getAssociatedObject(self, key) integerValue];
    return (max ? : NSUIntegerMax);
}

- (void)JWZSetFont:(UIFont *)font
{
    [[self placeholderLabelIfLoaded] setFont:font];
    [self JWZSetFont:font];
//    [self se:font];
}

@end

#pragma mark - 辅助类

@implementation WHLPlaceholderSupportHelper

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [_observedTextView removeObserver:self forKeyPath:@"text"];
}

- (void)textViewTextDidChange:(NSNotification *)notification
{
    UITextView *textView = _observedTextView;
    NSUInteger length = textView.text.length;
    if (length > 0) {
        [textView placeholderLabelIfLoaded].hidden = YES;
        NSUInteger max = textView.textMaximumLength;
        if (length > max) {
            NSString *text = [textView.text
                              substringToIndex:NSMaxRange([textView.text
                                                           rangeOfComposedCharacterSequenceAtIndex:max])];
            textView.text = text;
        }
    } else {
        [textView placeholderLabelIfLoaded].hidden = NO;
    }
}

- (void)setObservedTextView:(UITextView *)observedTextView
{
    if (_observedTextView != observedTextView) {
        _observedTextView = observedTextView;
        if (_observedTextView != nil) {
            [[NSNotificationCenter defaultCenter]
             addObserver:self
                selector:@selector(textViewTextDidChange:)
                    name:UITextViewTextDidChangeNotification
                  object:nil];

//            [_observedTextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        }
    }
}

////为了
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if (_observedTextView != nil && _observedTextView == object) {
        [[_observedTextView placeholderLabelIfLoaded]
         setFont:_observedTextView.font];
        if ([keyPath isEqualToString:@"text"]) {
            NSUInteger length = _observedTextView.text.length;
            [_observedTextView placeholderLabelIfLoaded].hidden = length > 0;
        }
    }
}

@end

@implementation UITextView (WHLRange)

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

@end
