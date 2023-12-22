//
//  NSData+Category.m
//  QingDaoCA
//
//  Created by yongsheng.li on 14/05/2017.
//  Copyright © 2017 qingdao. All rights reserved.
//

#import "NSData+WHLCategory.h"
#import "NSString+WHLAdditions.h"

@implementation NSData (Category)

- (NSDictionary *)toDictionary
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableLeaves error:nil];
}



+ (float)getDecimalNumberScale:(NSInteger)scale RoundingMode:(NSRoundingMode)model OriginalValue:(float)originalValue {
    /*
     // Original
     //    value 1.2  1.21  1.25  1.35  1.27 原始值
     // Plain    1.2  1.2   1.3   1.4   1.3  四舍五入
     // Down     1.2  1.2   1.2   1.3   1.2  向下取整
     // Up       1.2  1.3   1.3   1.4   1.3  向上取整
     // Bankers  1.2  1.2   1.2   1.4   1.3  四舍六入五留双（(也是四舍五入,这是和NSRoundPlain不一样,如果精确的哪位是5,
     它要看精确度的前一位是偶数还是奇数,如果是奇数,则入,偶数则舍）
     raiseOnExactness/raiseOnOverflow/raiseOnUnderflow raiseOnDivideByZero
     分别表示数据精确/上溢/下益/除以0时是否以异常处理,一般情况下都设置为NO

     */

    NSString *temp = [NSString stringWithFormat:@"%.7f", originalValue];
    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:model
                                                                      scale:scale
                                                           raiseOnExactness:NO
                                                            raiseOnOverflow:NO
                                                           raiseOnUnderflow:NO
                                                        raiseOnDivideByZero:YES];
    return [[numResult decimalNumberByRoundingAccordingToBehavior:roundUp] floatValue];
}

+ (float)getDecimalNumberScale:(NSInteger)scale RoundingMode:(NSRoundingMode)model OriginalValueStr:(NSString *)originalStr {
    /*
     // Original
     //    value 1.2  1.21  1.25  1.35  1.27 原始值
     // Plain    1.2  1.2   1.3   1.4   1.3  四舍五入
     // Down     1.2  1.2   1.2   1.3   1.2  向下取整
     // Up       1.2  1.3   1.3   1.4   1.3  向上取整
     // Bankers  1.2  1.2   1.2   1.4   1.3  四舍六入五留双（(也是四舍五入,这是和NSRoundPlain不一样,如果精确的哪位是5,
     它要看精确度的前一位是偶数还是奇数,如果是奇数,则入,偶数则舍）
     raiseOnExactness/raiseOnOverflow/raiseOnUnderflow raiseOnDivideByZero
     分别表示数据精确/上溢/下益/除以0时是否以异常处理,一般情况下都设置为NO

     */

    if ([NSString whl_isEmptyOrWithStrWith:originalStr]) {
        return 0.00;
    }

    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:originalStr];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:model
                                                                      scale:scale
                                                           raiseOnExactness:NO
                                                            raiseOnOverflow:NO
                                                           raiseOnUnderflow:NO
                                                        raiseOnDivideByZero:YES];
    return [[numResult decimalNumberByRoundingAccordingToBehavior:roundUp] floatValue];
}

+ (NSString *)getDecimalNumberStrScale:(NSInteger)scale RoundingMode:(NSRoundingMode)model OriginalValueStr:(NSString*)originalStr{
    
    if ([NSString whl_isEmptyOrWithStrWith:originalStr]) {
        return @"0";
        
    }

    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:originalStr];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:model
                                                                      scale:scale
                                                           raiseOnExactness:NO
                                                            raiseOnOverflow:NO
                                                           raiseOnUnderflow:NO
                                                        raiseOnDivideByZero:YES];
    return [[numResult decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
    
    
}




+ (NSString *)getAdd_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model {
    if ([NSString whl_isEmptyOrWithStrWith:firstNumStr] || [NSString whl_isEmptyOrWithStrWith:SecondNumStr]) {
        NSLog(@"数据类型错误");
        return @"0.00";
    }

    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:firstNumStr];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:SecondNumStr];
    NSDecimalNumber *resultNum = [num1 decimalNumberByAdding:num2];

    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:model
                                                                      scale:scale
                                                           raiseOnExactness:NO
                                                            raiseOnOverflow:NO
                                                           raiseOnUnderflow:NO
                                                        raiseOnDivideByZero:YES];

    return [[resultNum decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
}

+ (NSString *)getSubtracting_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model {
    if ([NSString whl_isEmptyOrWithStrWith:firstNumStr] || [NSString whl_isEmptyOrWithStrWith:SecondNumStr]) {
        NSLog(@"数据类型错误");
        return @"0.00";
    }

    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:firstNumStr];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:SecondNumStr];
    NSDecimalNumber *resultNum = [num1 decimalNumberBySubtracting:num2];

    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:model
                                                                      scale:scale
                                                           raiseOnExactness:NO
                                                            raiseOnOverflow:NO
                                                           raiseOnUnderflow:NO
                                                        raiseOnDivideByZero:YES];

    return [[resultNum decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
}

+ (NSString *)getMultiplying_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model {
    if ([NSString whl_isEmptyOrWithStrWith:firstNumStr] || [NSString whl_isEmptyOrWithStrWith:SecondNumStr]) {
        NSLog(@"数据类型错误");
        return @"0.00";
    }

    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:firstNumStr];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:SecondNumStr];
    NSDecimalNumber *resultNum = [num1 decimalNumberByMultiplyingBy:num2];

    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:model
                                                                      scale:scale
                                                           raiseOnExactness:NO
                                                            raiseOnOverflow:NO
                                                           raiseOnUnderflow:NO
                                                        raiseOnDivideByZero:YES];

    return [[resultNum decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
}

+ (NSString *)getDividing_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr decimalNumberScale:(NSInteger)scale roundingMode:(NSRoundingMode)model {
    if ([NSString whl_isEmptyOrWithStrWith:firstNumStr] || [NSString whl_isEmptyOrWithStrWith:SecondNumStr]) {
        NSLog(@"数据类型错误");
        return @"0.00";
    }
    if ([SecondNumStr floatValue] == 0.00f){
        NSLog(@"除数为0类型错误");
        return @"0.00";
    }

    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:firstNumStr];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:SecondNumStr];
    NSDecimalNumber *resultNum = [num1 decimalNumberByDividingBy:num2];

    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:model
                                                                      scale:scale
                                                           raiseOnExactness:NO
                                                            raiseOnOverflow:NO
                                                           raiseOnUnderflow:NO
                                                        raiseOnDivideByZero:YES];

    return [[resultNum decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
}

+ (BOOL)getMaxthan_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr {
    if ([NSString whl_isEmptyOrWithStrWith:firstNumStr] || [NSString whl_isEmptyOrWithStrWith:SecondNumStr]) {
        NSLog(@"数据类型错误");
        return NO;
    }

    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:firstNumStr];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:SecondNumStr];
    NSComparisonResult result = [num1 compare:num2];

    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

+ (BOOL)getEqualthan_firstNumStr:(NSString *)firstNumStr toSecondNumStr:(NSString *)SecondNumStr {
    if ([NSString whl_isEmptyOrWithStrWith:firstNumStr] || [NSString whl_isEmptyOrWithStrWith:SecondNumStr]) {
        NSLog(@"数据类型错误");
        return NO;
    }

    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:firstNumStr];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:SecondNumStr];
    NSComparisonResult result = [num1 compare:num2];

    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return YES;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;
}

@end
