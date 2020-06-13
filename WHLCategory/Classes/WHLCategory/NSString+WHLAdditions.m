//
//  NSString+WHLAdditions.m
//
//  Created by 王浩霖 on 15/12/4.
//  Copyright © 2015年 王浩霖. All rights reserved.
//

#import "NSString+WHLAdditions.h"

#import "NSDate+WHLCategory.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#define WHLGetLanguageString [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"][0]

#define WHL_LANGUAGE         [WHLGetLanguageString hasPrefix:@"en"] ? @"1" : ([WHLGetLanguageString hasPrefix:@"ko"] ? @"2" : [WHLGetLanguageString hasPrefix:@"zh-Hans"] ? @"0" : @"0")

// Need to import for CC_MD5 access
//////////////////////////////////////////////////////////////////////////////////////////////////

@interface TKMarkupStripper : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *_strings;
}

- (NSString *)parse:(NSString *)string;

@end

@implementation TKMarkupStripper

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
    self = [super init];
    if (self) {
        _strings = nil;
    }
    return self;
}

- (void)dealloc {
    _strings = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [_strings addObject:string];
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID {
    static NSDictionary *entityTable = nil;
    if (!entityTable) {
        // XXXjoe Gotta get a more complete set of entities
        entityTable = [[NSDictionary alloc] initWithObjectsAndKeys:
                       [NSData dataWithBytes:" " length:1], @"nbsp",
                       [NSData dataWithBytes:"&" length:1], @"amp",
                       [NSData dataWithBytes:"\"" length:1], @"quot",
                       [NSData dataWithBytes:"<" length:1], @"lt",
                       [NSData dataWithBytes:">" length:1], @"gt",
                       nil];
    }
    return [entityTable objectForKey:entityName];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (NSString *)parse:(NSString *)text {
    _strings = [[NSMutableArray alloc] init];

    NSString *document = [NSString stringWithFormat:@"<x>%@</x>", text];
    NSData *data = [document dataUsingEncoding:text.fastestEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];

    return [_strings componentsJoinedByString:@""];
}

@end

//TK_FIX_CATEGORY_BUG(NSStringAdditions)

@implementation NSString (WHLAdditions)

- (NSString *)formatCurrency {
    NSString *nstr = [NSString stringWithFormat:@"%.2f", [self doubleValue]];
    nstr = [nstr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    return nstr;
    //    NSRange range = [nstr rangeOfString:@"."];
    //    if (range.location!= NSNotFound && range.length>0) {

    //        return [self formatCurrencyStyleWithString];
    //    }
    //    return [self formatJpAmountString];
}

- (NSString *)formatCurrencyStyleWithString
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *formattedNumberString;
    if ([self hasPrefix:@"+"] || [self hasPrefix:@"-"]) {
        [numberFormatter setPositivePrefix:@"+"];
        [numberFormatter setPositiveSuffix:@""];
        [numberFormatter setNegativePrefix:@"-"];
        [numberFormatter setNegativeSuffix:@""];
    } else {
        [numberFormatter setPositivePrefix:@""];
    }
    formattedNumberString = [numberFormatter stringFromNumber:[[NSDecimalNumber alloc] initWithString:self]];
    return formattedNumberString;
}

- (NSString *)formatJpAmountString
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:self];
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterCurrencyStyle);
    CFNumberFormatterSetFormat(numberFormatter, CFSTR("####"));
    NSString *formattedNumberString = (__bridge NSString *)(CFNumberFormatterCreateStringWithNumber(NULL, numberFormatter, (__bridge CFNumberRef)(multiplierNumber)));
    return formattedNumberString;
}

- (BOOL)isAlpha
{
    for (int i = 0; i < [self length]; i++) {
        char c = [self characterAtIndex:i];
        if (!isalpha(c)) {
            return NO;
        }
    }
    return [self length] != 0;
}

- (BOOL)isNumber
{
    for (int i = 0; i < [self length]; i++) {
        char c = [self characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return [self length] != 0;
}

- (BOOL)isWhitespace {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isContainOfString:(NSString *)aString
{
    NSRange range = [self rangeOfString:aString];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyOrWithStrWith:(NSString *)str {
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([str isKindOfClass:[NSString class]] && [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)GetFormateShortTimeStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";

    NSString *dateString = [df stringFromDate:[NSDate date]];

    NSDate *startdate = [df dateFromString:dateString];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    if (!date) {
        return @"";
    }

    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date toDate:startdate options:0];
    int year = (int)[components year];
    int month = (int)[components month];
    int day = (int)[components day];
    int hour = (int)[components hour];
    int minute = (int)[components minute];
    int second = (int)[components second];

    int iOffset = (hour * 60 + minute) * 60 + second;

    if (year == 0 && month == 0 && day < 2) {
        NSString *title = nil;
        if (day <= 0) {
            if (iOffset <= 0) {
                int sTime = [date timeIntervalSince1970];
                int eTime = [[NSDate date] timeIntervalSince1970];
                int resultTime = eTime - sTime;
                if (resultTime > 0) {
                    if (resultTime < 3600) {
                        if (resultTime < 60) {
                            return [NSString stringWithFormat:@"%d秒前", resultTime];
                        } else {
                            if ((int)(resultTime / 60) == 1 && [WHL_LANGUAGE isEqualToString:@"1"]) {
                                return [NSString stringWithFormat:@"%d min ago", (int)(resultTime / 60)];
                            }
                            return [NSString stringWithFormat:@"%d分钟前", resultTime / 60];
                        }
                    } else if (resultTime <= 3 * 3600 && resultTime >= 3600) {
                        if ((int)(resultTime / 3600) == 1 && [WHL_LANGUAGE isEqualToString:@"1"]) {
                            return [NSString stringWithFormat:@"%d hour ago", (int)(resultTime / 3600)];
                        }
                        return [NSString stringWithFormat:@"%d小时前", (int)(resultTime / 3600)];
                    } else {
                        title = @"今天";
                    }
                } else {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = @"MM-dd";
                    return [df stringFromDate:date];
                }
            } else {
                title = @"昨天";
            }
        } else if (day == 1) {
            title = @"前天";
        }
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = [NSString stringWithFormat:@"%@ HH:mm", title];
        NSString *finalStr = [dateformatter stringFromDate:date];
        if ([title isEqualToString:@"今天"]) {
            return [finalStr stringByReplacingOccurrencesOfString:title withString:@"今天"];
        } else if ([title isEqualToString:@"昨天"]) {
            return [finalStr stringByReplacingOccurrencesOfString:title withString:@"昨天"];
        } else if ([title isEqualToString:@"前天"]) {
            return [finalStr stringByReplacingOccurrencesOfString:title withString:@"前天"];
        }
        return finalStr;
    }
    NSDateFormatter *ddff = [[NSDateFormatter alloc] init];
    ddff.dateFormat = @"MM-dd HH:mm";
    return [ddff stringFromDate:date];
}

- (NSString *)CQGetFormateListShortTimeStr {
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy-MM-dd";
//    NSString *dateString = [df stringFromDate:[NSDate date]];
//
//    NSDate *startdate = [df dateFromString:dateString];
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//    [calendar setTimeZone:timeZone];
//
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
//    if (!date) {
//        return @"";
//    }
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekdayOrdinal fromDate:date toDate:startdate options:0];
//    int year = (int)[components year];
//    int month = (int)[components month];
//    int day = (int)[components day];
//    int hour = (int)[components hour];
//    int minute = (int)[components minute];
//    int second = (int)[components second];
//    NSDateComponents *weekDaycomponents = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekdayOrdinal fromDate:date ];
//
//    int weekDay = (int)[weekDaycomponents weekday];
//
//
//    int  iOffset = (hour*60+minute)*60+second;
//
//    if (year == 0 && month == 0 && day <= 0) {
//
//
//        }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    if (!date) {
        return @"";
    }

    if (date.isToday) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"HH:mm";
        return [df stringFromDate:date];
    }

    if (date.isYesterday) {
        return @"昨天";
    }

    if ([date isThisWeek]) {
    }

    NSDateFormatter *ddff = [[NSDateFormatter alloc] init];
    ddff.dateFormat = @"yyyy/MM/dd";
    return [ddff stringFromDate:date];
}

- (BOOL)isEmptyOrWhitespace {
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark 字符串处理

//计算NSString中英文字符串的字符长度。ios 中一个汉字算2字符数
- (int)charNumberOfStr
{
    int strlength = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location + 1]; // non-inclusive
}

//去掉所有空格
- (NSString *)stringByTrimmingOutAllWhithesspace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)stringByTrimmingWhitespaceCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingTrailingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRemovingHTMLTags {
    TKMarkupStripper *stripper = [[TKMarkupStripper alloc] init];
    return [stripper parse:self];
}

+ (NSString *)stringByTrimmingWhitespaceCharactersAndAngleBracket:(NSString *)string
{
    NSString *returnStr = string;
    returnStr = [returnStr stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    return returnStr;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)notNull:(NSString *)str
{
    if (str == nil) {
        return @"";
    }
    if (str.length == 0) {
        return @"";
    }
    if (!str || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@"(null)"]) {
        return @"";
    }
    return str;
}

+ (NSString *)valueNotNull:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        return [self notNull:str];
    }
    if ([str isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)str;
        return [number stringValue];
    }
    return @"";
}

+ (NSString *)getFloatStrWithVaule:(float)value {
    float i = roundf(value);//对num取整

    if (i == value) {
        return [NSString stringWithFormat:@"%.0f", i];//%.0f表示小数点后面显示0位
    } else {
        return [NSString stringWithFormat:@"%.1f", value];//注意这里是打印num对应的值
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

+ (NSArray *)arrWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json解析失败%@", err);
        return nil;
    }
    return arr;
}

//字典转化为JSON字符串
+ (NSString *)jsonFormDict:(NSDictionary *)dict
{
    if (!dict) {//解析失败
        return nil;
    }

    NSError *errror = nil;
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&errror];
    NSString *jsonStr = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];

    //去除所有制表符和空格
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉字符串中的空格
    jsonStr = [jsonStr stringByTrimmingWhitespaceCharacters];//去掉字符串两端的空格。
    return jsonStr;
}

#pragma mark - HTML Methods

- (NSString *)escapeHTML {
    NSMutableString *s = [NSMutableString string];

    NSUInteger start = 0;
    NSUInteger len = [self length];
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];

    while (start < len) {
        NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len - start)];
        if (r.location == NSNotFound) {
            [s appendString:[self substringFromIndex:start]];
            break;
        }

        if (start < r.location) {
            [s appendString:[self substringWithRange:NSMakeRange(start, r.location - start)]];
        }

        switch ([self characterAtIndex:r.location]) {
            case '<':
                [s appendString:@"&lt;"];
                break;
            case '>':
                [s appendString:@"&gt;"];
                break;
            case '"':
                [s appendString:@"&quot;"];
                break;
            //			case '…':
            //				[s appendString:@"&hellip;"];
            //				break;
            case '&':
                [s appendString:@"&amp;"];
                break;
        }

        start = r.location + 1;
    }

    return s;
}

- (NSString *)unescapeHTML {
    NSMutableString *s = [NSMutableString string];
    NSMutableString *target = [self mutableCopy];
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];

    while ([target length] > 0) {
        NSRange r = [target rangeOfCharacterFromSet:chs];
        if (r.location == NSNotFound) {
            [s appendString:target];
            break;
        }

        if (r.location > 0) {
            [s appendString:[target substringToIndex:r.location]];
            [target deleteCharactersInRange:NSMakeRange(0, r.location)];
        }

        if ([target hasPrefix:@"&lt;"]) {
            [s appendString:@"<"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&gt;"]) {
            [s appendString:@">"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&quot;"]) {
            [s appendString:@"\""];
            [target deleteCharactersInRange:NSMakeRange(0, 6)];
        } else if ([target hasPrefix:@"&#39;"]) {
            [s appendString:@"'"];
            [target deleteCharactersInRange:NSMakeRange(0, 5)];
        } else if ([target hasPrefix:@"&amp;"]) {
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 5)];
        } else if ([target hasPrefix:@"&hellip;"]) {
            [s appendString:@"…"];
            [target deleteCharactersInRange:NSMakeRange(0, 8)];
        } else {
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }

    return s;
}

@end

@implementation NSString (version)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)versionStringCompare:(NSString *)other {
    NSArray *oneComponents = [self componentsSeparatedByString:@"a"];
    NSArray *twoComponents = [other componentsSeparatedByString:@"a"];

    // The parts before the "a"
    NSString *oneMain = [oneComponents objectAtIndex:0];
    NSString *twoMain = [twoComponents objectAtIndex:0];

    // If main parts are different, return that result, regardless of alpha part
    NSComparisonResult mainDiff;
    if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame) {
        return mainDiff;
    }

    // At this point the main parts are the same; just deal with alpha stuff
    // If one has an alpha part and the other doesn't, the one without is newer
    if ([oneComponents count] < [twoComponents count]) {
        return NSOrderedDescending;
    } else if ([oneComponents count] > [twoComponents count]) {
        return NSOrderedAscending;
    } else if ([oneComponents count] == 1) {
        // Neither has an alpha part, and we know the main parts are the same
        return NSOrderedSame;
    }

    // At this point the main parts are the same and both have alpha parts. Compare the alpha parts
    // numerically. If it's not a valid number (including empty string) it's treated as zero.
    NSNumber *oneAlpha = [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
    NSNumber *twoAlpha = [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
    return [oneAlpha compare:twoAlpha];
}

@end

@implementation NSString (NSURL)

- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString *pairString;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString *key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString *value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];

            [pairs setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSString *)stringByAddingQuery:(NSDictionary *)query {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [query keyEnumerator]) {
        id aValue = [query objectForKey:key];
        NSString *value = nil;
        if (![aValue isKindOfClass:[NSString class]]) {
            value = [aValue description];
        } else {
            value = aValue;
        }
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }

    NSString *params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

- (NSString *)urlEncodeValue {
    NSString *encodedString =
        (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                          kCFAllocatorDefault, (CFStringRef)self, NULL,
                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));

    return encodedString;
}

- (NSString *)urlDecodeValue {
    NSString *decodedString = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
        NULL, (__bridge CFStringRef)self, CFSTR(""),
        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end;

@implementation NSString (Matching)

- (BOOL)isValidPhoneNumber {
    if (self.length != 11) {
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *adStr = @"^(1[3|4|5|7|8])\\d{9}$";

//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((13)|(15)|(17)|(18[0,1,9]))\\d{9}$";
        if ([self isValidateByRegex:adStr]) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)isEmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

//身份证有效性
- (BOOL)simpleVerifyIdentityCardNum {
    NSString *regex2 = @"^(\\\\d{14}|\\\\d{17})(\\\\d|[xX])$";
    return [self isValidateByRegex:regex2];
}

//判断是否有特殊符号
- (BOOL)effectivePassword {
    NSString *regex2 = @"[a-zA-Z0-9]{6,20}";
    return [self isValidateByRegex:regex2];
}

//是否纯汉字
- (BOOL)isValidChinese {
    NSString *chineseRegex = @"^[\\u4e00-\\u9fa5]+$";
    return [self isValidateByRegex:chineseRegex];
}

- (BOOL)isValidateByRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pre evaluateWithObject:self];
}

@end

@implementation NSString (UUID)

+ (NSString *)stringWithNewUUID
{
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);

    // Get the string representation of the UUID
    NSString *newUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return newUUID;
}

@end

@implementation   NSString (HTML)

+ (NSAttributedString *)transformationStr:(NSString *)htmlStr WithOption:(NSDictionary *)optionDict {
    NSString *manageStr = [self htmlEntityDecode:htmlStr];
    return [self attributedStringWithHTMLString:manageStr WithOption:optionDict];
}

+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "]; //临时处理掉的，还是有点问题
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    return string;
}

+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString WithOption:(NSDictionary *)option {
//    if (!option) {
//            NSDictionary* options = @{
//                                      NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
//                                      NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding),
//                                      NSFontAttributeName : [UIFont systemFontOfSize:13.0f]
//                                      };
//
//    }
//
//    NSData* data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
//    return [[NSAttributedString alloc] initWithData:data
//                                            options:option
//                                 documentAttributes:nil
//                                              error:nil];
    return nil;
}

+ (NSString *)filterHTML:(NSString *)htmlStr {
    NSString *htmlStrOne = [self htmlEntityDecode:htmlStr];
    NSScanner *scanner = [NSScanner scannerWithString:htmlStrOne];
    NSString *text = nil;

    while ([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        htmlStrOne = [htmlStrOne stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }

    return htmlStrOne;
}

@end

@implementation NSString (Hash)

- (NSString *)md5 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];

    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

- (NSString *)md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
}

#pragma mark - Helpers

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(NSInteger)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++) {
        [mutableString appendFormat:@"%02x", bytes[i]];
    }
    return [NSString stringWithString:mutableString];
}

@end

@implementation NSString (data)
/**
  精确到小数点后6位
 */
- (double)numberWithDrecision
{
    double oldDoudle = [self doubleValue];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
    [nf setMaximumFractionDigits:6];
    NSNumber *newNumber = [nf numberFromString:[NSString stringWithFormat:@"%.6lf", oldDoudle]];
    return [newNumber doubleValue];
}

@end

@implementation NSString (WHLCanonical)

- (BOOL)isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl {
//    NSString *pattern = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    //这里是这个项目所特别用到的

    NSString *pattern = @"((https|http|ftp|rtsp|mms)?://)[\\S]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

- (BOOL)validateAuthen {
    NSString *pattern = @"^\\d{5,6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isProvinceCard {
    NSString *regex = @"\\d{14}[[0-9],0-9xX]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isPositiveInteger {
    NSString *regex = @"^([0-9][0-9]*)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isTwoDicmal {
    NSString *regex = @"^[0-9]+(.[0-9]{2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isPostalcode {
    NSString *regex = @"[1-9]\\d{5}(?!\d)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isQQNmuber {
    NSString *regex = @"[1-9][0-9]\{4,\}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isTwoBetyLenght {//评注：可以用来计算字符串的长度
    NSString *regex = @"[^\x00-\xff]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isBeginToEndblank {//评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
    NSString *regex = @"^\s*|\s*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isOnlyNmuber {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isBlankLine {//评注：可以用来删除空白行
    NSString *regex = @"\n\s*\r";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isContainsEmojiStr;
{
    __block BOOL returnValue = NO;

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];

    return returnValue;
}

//判断第三方键盘中的表情
- (BOOL)hasTripartiteEmoji {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

//去除表情
- (NSString *)disableEmoji {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
    return modifiedString;
}

- (BOOL)isContaintSystemEmojiStr {
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len < 3) { // 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
        return NO;
    }

    // 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    Byte *bts = (Byte *)[data bytes];
    Byte bt;
    short v;
    for (NSUInteger i = 0; i < len; i++) {
        bt = bts[i];

        if ((bt | 0x7F) == 0x7F) { // 0xxxxxxx ASIIC编码
            continue;
        }
        if ((bt | 0x1F) == 0xDF) { // 110xxxxx 两个字节的字符
            i += 1;
            continue;
        }
        if ((bt | 0x0F) == 0xEF) { // 1110xxxx 三个字节的字符(重点过滤项目)
            // 计算Unicode下标
            v = bt & 0x0F;
            v = v << 6;
            v |= bts[i + 1] & 0x3F;
            v = v << 6;
            v |= bts[i + 2] & 0x3F;

            // NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));

            if ([NSString emojiInSoftBankUnicode:v] || [NSString emojiInUnicode:v]) {
                return YES;
            }

            i += 2;
            continue;
        }
        if ((bt | 0x3F) == 0xBF) { // 10xxxxxx 10开头,为数据字节,直接过滤
            continue;
        }

        return YES; // 不是以上情况的字符全部超过三个字节,做Emoji处理
    }
    return NO;
}

+ (BOOL)emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

+ (BOOL)emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666
        || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}

@end
