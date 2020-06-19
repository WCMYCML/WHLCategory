//
//  NSString+WHLAdditions.h
//
//  Created by Haolin Wang on 15/12/4.
//  Copyright © 2015年 Haolin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WHLAdditions)

- (NSString *)formatCurrency;

- (BOOL)isAlpha;

- (BOOL)isNumber;

- (BOOL)isWhitespace;

//是否包含某个字符串
- (BOOL)isContainOfString:(NSString *)aString;

//是否为空字符串
- (BOOL)isEmptyOrWhitespace;

//这个方法更好，解决了BUG
+ (BOOL)isEmptyOrWithStrWith:(NSString *)str;

//计算字符串长度
- (int)charNumberOfStr;

//去掉首尾空格
- (NSString *)stringByTrimmingWhitespaceCharacters;

//去掉所有空格
- (NSString *)stringByTrimmingOutAllWhithesspace;

//去掉特殊自定义字符
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

/**
  去掉两端空格
 */
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

- (NSString *)stringByRemovingHTMLTags;

//去掉所有的空格和特殊字符串
+ (NSString *)stringByTrimmingWhitespaceCharactersAndAngleBracket:(NSString *)string;

- (NSString *)trim;

+ (NSString *)notNull:(NSString *)str;

+ (NSString *)getFloatStrWithVaule:(float)value;

+ (NSString *)valueNotNull:(NSString *)str;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSArray *)arrWithJsonString:(NSString *)jsonString;

+ (NSString *)jsonFormDict:(NSDictionary *)dict;

///获取短时间的文字
- (NSString *)GetFormateShortTimeStr;

//获取列表时间字符串
- (NSString *)CQGetFormateListShortTimeStr;

/**
 Returns a new string with any HTML escaped.

 @see unescapeHTML
 */

- (NSString *)escapeHTML;

/**
 Returns a new string with any HTML unescaped.

 @see escapeHTML
 */

- (NSString *)unescapeHTML;

@end

@interface NSString (version)

- (NSComparisonResult)versionStringCompare:(NSString *)other;

@end

@interface NSString (NSURL)

- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)stringByAddingQuery:(NSDictionary *)query;

- (NSString *)urlEncodeValue;

- (NSString *)urlDecodeValue;

@end

//字符串正则
@interface NSString (Matching)

- (BOOL)isValidPhoneNumber;
- (BOOL)isEmailAddress;
- (BOOL)simpleVerifyIdentityCardNum;
- (BOOL)effectivePassword;
- (BOOL)isValidChinese;

@end

@interface NSString (UUID)

+ (NSString *)stringWithNewUUID;

@end

@interface NSString (HTML)

/*

 NSDictionary* options = @{
 NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding),
 NSFontAttributeName : [UIFont systemFontOfSize:13.0f]
 };

 */
//处理HTML显示
+ (NSAttributedString *)transformationStr:(NSString *)htmlStr WithOption:(NSDictionary *)optionDict;

//去掉HTML标签
+ (NSString *)filterHTML:(NSString *)htmlStr;

@end

@interface NSString (Hash)

@property (readonly) NSString *md5;
@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

@end

@interface NSString (data)

//精确度为6位
- (double)numberWithDrecision;

@end

//正则判断

@interface NSString (WHLCanonical)

- (BOOL)isChinese;//是否只是中文

/**
 *	@author Haolin Wang, 16-09-18
    是否是邮箱
 */
- (BOOL)isEmail;

- (BOOL)isUrl;

- (BOOL)validateAuthen;//验证码判断
- (BOOL)isPhoneNumber;//手机号码
- (BOOL)isProvinceCard;//验证身份证号（15位或18位数字）
- (BOOL)isPositiveInteger;//只能是正整数

- (BOOL)isTwoDicmal;//只能输入有两位小数的正实数
- (BOOL)isPostalcode;//邮政编码

- (BOOL)isQQNmuber;//匹配QQ号码 //评注：腾讯QQ号从10 000 开始

- (BOOL)isTwoBetyLenght;//匹配双字节字符(包括汉字在内)

- (BOOL)isBeginToEndblank;//匹配首尾空白字符的正则表达式：

- (BOOL)isOnlyNmuber;//只能输入数字

- (BOOL)isBlankLine;//匹配空白行的正则表达式

- (BOOL)isContainsEmojiStr; //是否包含表情

//是否含有三方的表情
- (BOOL)hasTripartiteEmoji;
//去除表情
- (NSString *)disableEmoji;

- (BOOL)isContaintSystemEmojiStr;

@end
