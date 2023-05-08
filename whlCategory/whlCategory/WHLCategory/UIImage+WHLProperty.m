//
//  UIImage+WHLProperty.m
//  CrudeOilThrough
//
//  Created by Apple on 2017/9/11.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import "UIImage+WHLProperty.h"

#import <objc/runtime.h>

@implementation UIImage (WHLProperty)

static const char* KImageSourceType = "ImageSourceType";
static const char* KWatermarkForTime = "WatermarkForTime";


- (UIImageSourceType)imageSourceType
{
    return [objc_getAssociatedObject(self, KImageSourceType) intValue];
}

- (void)setImageSourceType:(UIImageSourceType)imageSourceType
{
    objc_setAssociatedObject(self, KImageSourceType, [NSNumber numberWithInt:imageSourceType], OBJC_ASSOCIATION_ASSIGN);
}


- (BOOL)isWatermarkForTime
{
    return [objc_getAssociatedObject(self, KWatermarkForTime) boolValue];
}

- (void)setIsWatermarkForTime:(BOOL)isWatermarkForTime
{
    objc_setAssociatedObject(self, KWatermarkForTime, [NSNumber numberWithBool:isWatermarkForTime], OBJC_ASSOCIATION_ASSIGN);
}

@end
