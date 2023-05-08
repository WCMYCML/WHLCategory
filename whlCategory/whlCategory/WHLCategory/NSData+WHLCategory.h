//
//  NSData+WHLCategory.h
//  QingDaoCA
//
//  Created by yongsheng.li on 14/05/2017.
//  Copyright © 2017 qingdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (WHLCategory)

- (NSDictionary *)toDictionary;



/// 浮点数精度处理
/// - Parameters:
///   - scale: 精确位数
///   - model: 模式 默认NSRoundPlain
///   - originalValue: 原始值
+ (float)getDecimalNumberScale:(NSInteger)scale RoundingMode:(NSRoundingMode)model OriginalValue:(float)originalValue;

@end
