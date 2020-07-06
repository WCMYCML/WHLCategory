//
//  NSString+WHLAdditions.h
//
//  Created by Haolin Wang on 15/12/4.
//  Copyright © 2015年 Haolin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WHLAdditions)

- (NSString *)whlformatCurrency;

- (BOOL)whl_isAlpha;

- (BOOL)whl_isNumber;

- (BOOL)whl_isWhitespace;

//是否包含某个字符串
- (BOOL)whl_isContainOfString:(NSString *)aString;

//是否为空字符串
- (BOOL)whl_isEmptyOrWhitespace;

//这个方法更好，解决了BUG
+ (BOOL)whl_isEmptyOrWithStrWith:(NSString *)str;

//计算字符串长度
- (int)whl_charNumberOfStr;

//去掉首尾空格
- (NSString *)whl_stringByTrimmingWhitespaceCharacters;

//去掉所有空格
- (NSString *)whl_stringByTrimmingOutAllWhithesspace;

//去掉特殊自定义字符
- (NSString *)whl_stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

/**
  去掉两端空格
 */
- (NSString *)whl_stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

- (NSString *)whl_stringByRemovingHTMLTags;

//去掉所有的空格和特殊字符串
+ (NSString *)whl_stringByTrimmingWhitespaceCharactersAndAngleBracket:(NSString *)string;

- (NSString *)whl_trim;

+ (NSString *)whl_notNull:(NSString *)str;

+ (NSString *)whl_getFloatStrWithVaule:(float)value;

+ (NSString *)whl_valueNotNull:(NSString *)str;

+ (NSDictionary *)whl_dictionaryWithJsonString:(NSString *)jsonString;

+ (NSArray *)whl_arrWithJsonString:(NSString *)jsonString;

+ (NSString *)whl_jsonFormDict:(NSDictionary *)dict;

///获取短时间的文字
- (NSString *)whl_GetFormateShortTimeStr;

//获取列表时间字符串
- (NSString *)whl_CQGetFormateListShortTimeStr;

/**
 Returns a new string with any HTML escaped.

 @see unescapeHTML
 */

- (NSString *)whl_escapeHTML;

/**
 Returns a new string with any HTML unescaped.

 @see escapeHTML
 */

- (NSString *)whl_unescapeHTML;

@end

@interface NSString (version)

- (NSComparisonResult)whl_versionStringCompare:(NSString *)other;

@end

@interface NSString (NSURL)

- (NSDictionary *)whl_queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)whl_stringByAddingQuery:(NSDictionary *)query;

- (NSString *)whl_urlEncodeValue;

- (NSString *)whl_urlDecodeValue;

@end

//字符串正则
@interface NSString (Matching)

- (BOOL)whl_isValidPhoneNumber;
- (BOOL)whl_isEmailAddress;
- (BOOL)whl_simpleVerifyIdentityCardNum;
- (BOOL)whl_effectivePassword;
- (BOOL)whl_isValidChinese;

@end

@interface NSString (UUID)

+ (NSString *)whl_stringWithNewUUID;

@end

@interface NSString (HTML)

/*

 NSDictionary* options = @{
 NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)whl_,
 NSFontAttributeName : [UIFont systemFontOfSize:13.0f]
 };

 */
//处理HTML显示
+ (NSAttributedString *)whl_transformationStr:(NSString *)htmlStr WithOption:(NSDictionary *)optionDict;

//去掉HTML标签
+ (NSString *)whl_filterHTML:(NSString *)htmlStr;

@end

@interface NSString (Hash)

@property (readonly) NSString *md5;
@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;

- (NSString *)whl_hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)whl_hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)whl_hmacSHA512StringWithKey:(NSString *)key;

@end

@interface NSString (data)

//精确度为6位
- (double)whl_numberWithDrecision;

@end

//正则判断

@interface NSString (WHLCanonical)

- (BOOL)whl_isChinese;//是否只是中文

/**
 *	@author Haolin Wang, 16-09-18
    是否是邮箱
 */
- (BOOL)whl_isEmail;

- (BOOL)whl_isUrl;

- (BOOL)whl_validateAuthen;//验证码判断
- (BOOL)whl_isPhoneNumber;//手机号码
- (BOOL)whl_isProvinceCard;//验证身份证号（15位或18位数字）
- (BOOL)whl_isPositiveInteger;//只能是正整数

- (BOOL)whl_isTwoDicmal;//只能输入有两位小数的正实数
- (BOOL)whl_isPostalcode;//邮政编码

- (BOOL)whl_isQQNmuber;//匹配QQ号码 //评注：腾讯QQ号从10 000 开始

- (BOOL)whl_isTwoBetyLenght;//匹配双字节字符(包括汉字在内)whl_

- (BOOL)whl_isBeginToEndblank;//匹配首尾空白字符的正则表达式：

- (BOOL)whl_isOnlyNmuber;//只能输入数字

- (BOOL)whl_isBlankLine;//匹配空白行的正则表达式

- (BOOL)whl_isContainsEmojiStr; //是否包含表情

//是否含有三方的表情
- (BOOL)whl_hasTripartiteEmoji;
//去除表情
- (NSString *)whl_disableEmoji;

- (BOOL)whl_isContaintSystemEmojiStr;

@end
