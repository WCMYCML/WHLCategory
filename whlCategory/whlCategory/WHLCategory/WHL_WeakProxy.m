//
//  WHL_WeakProxy.m
//  CrudeOilThrough
//
//  Created by 王浩霖 on 2020/11/11.
//  Copyright © 2020 wanglz. All rights reserved.
//

#import "WHL_WeakProxy.h"


@interface WHL_WeakProxy ()

@property (nonatomic ,weak) id target;

@end

@implementation WHL_WeakProxy

+ (instancetype)whl_proxyWithTarget:(id)target{
    
    //NSProxy实例方法为alloc
       WHL_WeakProxy *proxy = [WHL_WeakProxy alloc];
       proxy.target = target;
       return proxy;
}


/**
 这个函数让重载方有机会抛出一个函数的签名，再由后面的forwardInvocation:去执行
    为给定消息提供参数类型信息
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

/**
 *  NSInvocation封装了NSMethodSignature，通过invokeWithTarget方法将消息转发给其他对象。这里转发给控制器执行。
 */
- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
