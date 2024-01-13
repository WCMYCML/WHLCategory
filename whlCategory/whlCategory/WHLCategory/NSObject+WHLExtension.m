//
//  NSObject+WHLExtension.m
//  whlCategory
//
//  Created by 王浩霖 on 2024/1/13.
//  Copyright © 2024 FYSL. All rights reserved.
//

#import "NSObject+WHLExtension.h"
#import <objc/runtime.h>
#import "NSDictionary+WHLCategory.h"


char * const kProtectCrashProtectorName = "kProtectCrashProtector";

void ProtectCrashProtected(id self, SEL sel) {
}



@implementation NSObject (WHLExtension)

+ (NSArray *)whl_allClassProperties {
    Class class;
    NSArray *names = [self whl_fetchClassProperties:class];
    return names;
}

+ (NSArray *)whl_currentClassProperties {
    NSArray *names = [self whl_fetchClassProperties:self];
    return names;
}

+ (NSArray *)whl_fetchClassProperties:(Class)root {
    Class cls = [self class];
    unsigned int count;
    if (root) {
        root = class_getSuperclass(root);
    }
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    while (cls != root) {
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            if (![propertyNames containsObject:propertyName]) {
                [propertyNames addObject:propertyName];
            }
        }
        if (properties){
            free(properties);
        }
        cls = class_getSuperclass(cls);
    }
    return propertyNames;
}

- (NSDictionary *)whl_allClassPropertiesAndValues {
    Class class;
    NSDictionary *para = [self whl_fetchClassPropertiesAndValues:class];
    return para;
}


- (NSDictionary *)whl_currentClassPropertiesAndValues {
    NSDictionary *para = [self whl_fetchClassPropertiesAndValues:self.class];
    return para;
}

- (NSDictionary *)whl_fetchClassPropertiesAndValues:(Class)root {
    NSArray *propertyNames = [self.class whl_fetchClassProperties:root];
    NSMutableDictionary *para = [[NSMutableDictionary alloc] initWithCapacity:propertyNames.count];
    for (NSString *propertyName in propertyNames) {
        id object = [self valueForKey:propertyName];
        if (object) {
            [para setObject:object forKey:propertyName];
        }
    }
    return para;
}

- (NSString *)whl_objectToJsonString {
    NSDictionary *dic = [self whl_currentClassPropertiesAndValues];
    return dic.whl_dictionaryToJsonString;
}

- (NSString *)whl_objectToJsonStringNoSpace {
    NSDictionary *dic = [self whl_currentClassPropertiesAndValues];
    return dic.whl_dictionaryToJsonStringNoSpace;
}

- (NSDictionary *)whl_objectToDictionary {
    NSDictionary *dic = [self whl_currentClassPropertiesAndValues];
    return dic;
}

@end


@implementation NSObject (SXRuntime)

// MARK: Util
+ (void)whl_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self whl_swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:cls];
}

+ (void)whl_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self whl_swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)whl_swizzleMethodWithOriginSel:(SEL)oriSel
                             oriMethod:(Method)oriMethod
                           swizzledSel:(SEL)swizzledSel
                        swizzledMethod:(Method)swizzledMethod
                                 class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

+ (Class)whl_addMethodToStubClass:(SEL)aSelector {
    Class ProtectCrashProtector = objc_getClass(kProtectCrashProtectorName);
    
    if (!ProtectCrashProtector) {
        ProtectCrashProtector = objc_allocateClassPair([NSObject class], kProtectCrashProtectorName, sizeof([NSObject class]));
        objc_registerClassPair(ProtectCrashProtector);
    }
    
    class_addMethod(ProtectCrashProtector, aSelector, (IMP)ProtectCrashProtected, "v@:");
    return ProtectCrashProtector;
}

- (BOOL)whl_isMethodOverride:(Class)cls selector:(SEL)sel {
    IMP clsIMP = class_getMethodImplementation(cls, sel);
    IMP superClsIMP = class_getMethodImplementation([cls superclass], sel);
    
    return clsIMP != superClsIMP;
}

+ (BOOL)whl_isMainBundleClass:(Class)cls {
    return cls && [[NSBundle bundleForClass:cls] isEqual:[NSBundle mainBundle]];
}

@end
