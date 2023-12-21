//
//  NSObject+whlDictPhysical.h
//  CrudeOilThrough
//
//  Created by 浩霖 on 2019/3/15.
//  Copyright © 2019 wanglz. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSObject (WHLDictPhysical)

- (id)whl_getObjectFromDictWithKey:(NSString *)key defaultValue:(id)def;


- (id)whl_getObjectFromArrWithKey:(NSInteger )index defaultValue:(id)def;


@end


