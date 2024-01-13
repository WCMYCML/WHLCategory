//
//  NSObject+WHLExtension.h
//  whlCategory
//
//  Created by 王浩霖 on 2024/1/13.
//  Copyright © 2024 FYSL. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSObject (WHLExtension)

/// 获取当前对象所有的属性
+ (NSArray *)whl_allClassProperties;

/// 获取当前对象所有的属性（只包括当前类的，不包括父类的）
+ (NSArray *)whl_currentClassProperties;

/// 获取当前类所有的属性（root = 到哪里为止；例如 A>B>C，A是B和C的子类，B是C的子类，A调用此方法，root传B，将会返回A到B之间的属性，不会返回C的）
/// - Parameter root: class
+ (NSArray *)whl_fetchClassProperties:(Class)root;

/// 获取当前对象所有的属性和值
- (NSDictionary *)whl_allClassPropertiesAndValues;

/// 获取当前对象所有的属性和值（只包括当前类的，不包括父类的）
- (NSDictionary *)whl_currentClassPropertiesAndValues;

/// 获取当前类所有的属性和值（root = 到哪里为止；例如 A>B>C，A是B和C的子类，B是C的子类，A调用此方法，root传B，将会返回A到B之间的属性，不会返回C的）
/// - Parameter root: class
- (NSDictionary *)whl_fetchClassPropertiesAndValues:(Class)root;

/// 对象转 JSON 字符
- (NSString *)whl_objectToJsonString;

/// 对象转 JSON 字符（无空格和回车）
- (NSString *)whl_objectToJsonStringNoSpace;

/// 对象转 字典
- (NSDictionary *)whl_objectToDictionary;


@end


@interface NSObject (WHLRuntime)

/**
 swizzle 类方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)whl_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/**
 swizzle 实例方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)whl_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/**
 判断方法是否在子类里override了
 
 @param cls 传入要判断的Class
 @param sel 传入要判断的Selector
 @return 返回判断是否被重载的结果
 */
- (BOOL)whl_isMethodOverride:(Class)cls selector:(SEL)sel;

/**
 判断当前类是否在主bundle里
 
 @param cls 出入类
 @return 返回判断结果
 */
+ (BOOL)whl_isMainBundleClass:(Class)cls;

/**
 动态创建绑定selector的类
 tip：每当无法找到selectorcrash转发过来的所有selector都会追加到当前Class上
 
 @param aSelector 传入selector
 @return 返回创建的类
 */
+ (Class)whl_addMethodToStubClass:(SEL)aSelector;


@end


