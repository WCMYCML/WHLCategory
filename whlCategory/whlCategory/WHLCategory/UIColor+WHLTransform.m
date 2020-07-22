//
//  UIColor+WHLTransform.m
//  SingleMentoring
//
//  Created by 罗义德 on 15/12/11.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import "UIColor+WHLTransform.h"

@implementation UIColor (WHLTransform)
/** 十六进制颜色转换 */
+ (UIColor *)whl_colorWithHexString:(NSString *)color {
    return [self whl_colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)whl_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)whl_colorWithHexValue:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0 alpha:alphaValue];
}

+ (UIColor *)whl_colorWithHexValue:(NSInteger)hexValue {
    return [self whl_colorWithHexValue:hexValue alpha:1.0];
}

+ (NSString *)whl_getHexValueStrFromColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }

    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0] * 255.0),
            (int)((CGColorGetComponents(color.CGColor))[1] * 255.0),
            (int)((CGColorGetComponents(color.CGColor))[2] * 255.0)];
}

+ (UIColor *)whl_randomColor {
    CGFloat red = random() % 255 / 255.0;
    CGFloat green = random() % 255 / 255.0;
    CGFloat blue = random() % 255 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)whl_colorGradientChangeWithSize:(CGSize)size direction:(WHLGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);

    CGPoint startPoint = CGPointZero;

    if (direction == WHLGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }

    gradientLayer.startPoint = startPoint;

    CGPoint endPoint = CGPointZero;

    switch (direction) {
        case WHLGradientChangeDirectionHorizontal:

            endPoint = CGPointMake(1.0, 0.0);

            break;

        case WHLGradientChangeDirectionVertical:

            endPoint = CGPointMake(0.0, 1.0);

            break;

        case WHLGradientChangeDirectionUpwardDiagonalLine:

            endPoint = CGPointMake(1.0, 1.0);

            break;

        case WHLGradientChangeDirectionDownDiagonalLine:

            endPoint = CGPointMake(1.0, 0.0);

            break;

        default:

            break;
    }

    gradientLayer.endPoint = endPoint;

    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];

    UIGraphicsBeginImageContext(size);

    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return [UIColor colorWithPatternImage:image];
}



#pragma mark - ******************** end **************************

//********************🔥🔥************************

/*
- (void)startConfig{
    self.begingTopColor = HEXCOLOR(0x0f48eb);
    self.begingBottomColor = HEXCOLOR(0x4f89f5);
    self.endTopColor = HEXCOLOR(0xfe4300);
    self.endBottomColor = HEXCOLOR(0xff9400);
    self.topBeginColorNumArr = [self getRGBDictionaryByColor:self.begingTopColor];
    self.endBeginColorNumArr = [self getRGBDictionaryByColor:self.begingBottomColor];
    self.topTransColorArr = [self transColorBeginColor:self.begingTopColor andEndColor:self.endTopColor];
    self.bottomTransColorArr = [self transColorBeginColor:self.begingBottomColor andEndColor:self.endBottomColor];
 }
 
 - (void)function{
    self.colorCol = 0.0f;
    self.changBackDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeBackColorWithDisplayLink)];
    self.changBackDisplayLink.frameInterval = 3; //20/60.秒调用
    [self.changBackDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
  }

- (void)changeBackColorWithDisplayLink {
 
     if (self.colorCol >= 1.0f) {
         self.colorCol = 1.0f;
         UIColor *topColor = [self getColorWithBeginColorWithCoe:self.colorCol andMarginArray:self.topTransColorArr];
         UIColor *bottomColor = [self getColorWithEndColorWithCoe:self.colorCol andMarginArray:self.bottomTransColorArr];
         [self setBackViewStartColor:topColor endColor:bottomColor];
         //
         self.changBackDisplayLink.paused = YES;
         [self.changBackDisplayLink invalidate];
         self.changBackDisplayLink = nil;
         //
     }

     UIColor *topColor = [self getColorWithBeginColorWithCoe:self.colorCol andMarginArray:self.topTransColorArr];
     UIColor *bottomColor = [self getColorWithEndColorWithCoe:self.colorCol andMarginArray:self.bottomTransColorArr];
     [self setBackViewStartColor:topColor endColor:bottomColor];
     self.colorCol = self.colorCol + 0.012; // 1*6/5*60 = 0.02;
 }
 
 
 - (UIColor *)getColorWithBeginColorWithCoe:(double)coe andMarginArray:(NSArray<NSNumber *> *)marginArray {
     NSArray *beginColorArr = self.topBeginColorNumArr;
     double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
     double green = [beginColorArr[1] doubleValue] + coe * [marginArray[1] doubleValue];
     double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
     return [UIColor colorWithRed:red green:green blue:blue alpha:1];
 }

 - (UIColor *)getColorWithEndColorWithCoe:(double)coe andMarginArray:(NSArray<NSNumber *> *)marginArray {
     NSArray *beginColorArr = self.endBeginColorNumArr;
     double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
     double green = [beginColorArr[1] doubleValue] + coe * [marginArray[1] doubleValue];
     double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
     return [UIColor colorWithRed:red green:green blue:blue alpha:1];
 }


 - (void)setBackViewStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {//颜色渐变
     if (startColor == nil || endColor == nil) {
         return;
     }
     if (self.gradientLayer) {
         [self.gradientLayer removeFromSuperlayer];
         self.gradientLayer = nil;
     }
     self.gradientLayer = [CAGradientLayer layer];
     self.gradientLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_WIDTH);//先写死的
     self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
     self.gradientLayer.startPoint = CGPointMake(0, 0);
     self.gradientLayer.endPoint = CGPointMake(0, 1);
     self.gradientLayer.locations = @[@0, @1];
     [self.backContentView.layer addSublayer:self.gradientLayer];
 }
 
 */

/*
 如何获取颜色的RGB值
 */
- (NSArray *)whl_getRGBDictionaryByColor:(UIColor *)originColor
{
    CGFloat r = 0, g = 0, b = 0, a = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    } else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }

    return @[@(r), @(g), @(b)];
}

/*
 计算出连个颜色之间的色差
 */
- (NSArray *)whl_transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor {
    NSArray<NSNumber *> *beginColorArr = [self whl_getRGBDictionaryByColor:beginColor];
    NSArray<NSNumber *> *endColorArr = [self whl_getRGBDictionaryByColor:endColor];
//    NSArray<NSNumber *> *endColorArr = @[@(1.0),@(1.0),@(1.0)];
    return @[@([endColorArr[0] doubleValue] - [beginColorArr[0] doubleValue]), @([endColorArr[1] doubleValue] - [beginColorArr[1] doubleValue]), @([endColorArr[2] doubleValue] - [beginColorArr[2] doubleValue])];
}

/*最后通过过渡系数来返回当前的颜色
andCoe 过渡系数 0-1 过渡
*/
- (UIColor *)whl_getColorWithColor:(UIColor *)beginColor andCoe:(double)coe andMarginArray:(NSArray<NSNumber *> *)marginArray {
    NSArray *beginColorArr = [self whl_getRGBDictionaryByColor:beginColor];
    double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
    double green = [beginColorArr[1] doubleValue] + coe * [marginArray[1] doubleValue];
    double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}



@end
