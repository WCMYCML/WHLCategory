//
//  WHL_WeakProxy.h
//  CrudeOilThrough
//
//  Created by 王浩霖 on 2020/11/11.
//  Copyright © 2020 wanglz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//解决定时器循环引用问题
@interface WHL_WeakProxy : NSProxy

+ (instancetype)whl_proxyWithTarget:(id)target;


@end

NS_ASSUME_NONNULL_END
