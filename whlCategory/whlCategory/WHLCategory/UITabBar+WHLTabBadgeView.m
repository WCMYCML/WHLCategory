//
//  UITabBar+CQTabBadgeView.m
//  CrudeOilThrough
//
//  Created by Haolin Wang on 2018/8/12.
//  Copyright © 2018年 wanglz. All rights reserved.
//

#import "UITabBar+WHLTabBadgeView.h"
#import "UIView+WHLCornerRadius.h"
#import <objc/runtime.h>

static const void *const WHLPlaceBageArrKey = &WHLPlaceBageArrKey;

@implementation UITabBar (WHLTabBadgeView)

#pragma mark -  ************************** 私有方法 ********************

- (NSMutableArray *)whl_getItemViewsArr {
    const void *key = (const void *)(WHLPlaceBageArrKey + 1);
    NSMutableArray *itemArr = objc_getAssociatedObject(self, key);
    if (itemArr == nil) {
        itemArr = [NSMutableArray arrayWithCapacity:0];
        objc_setAssociatedObject(self, key, itemArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return itemArr;
}

- (UILabel *)whl_getBageLabelView {
    UILabel *bageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    bageLabel.textColor = [UIColor whiteColor];
    bageLabel.font = [UIFont systemFontOfSize:11];
//    bageLabel.backgroundColor = CQ_FC4F4F_Color;
    bageLabel.whl_cornerRadius = 9;
    bageLabel.textAlignment = NSTextAlignmentCenter;
    bageLabel.whl_borderWidth = 1.0f;
    bageLabel.whl_borderColor = [UIColor whiteColor];
    return bageLabel;
}

- (void)whl_setAllIteNum:(NSInteger)itemNum {
    NSMutableArray *allItem = [self whl_getItemViewsArr];
    for (UIView *itemView in allItem) {
        [itemView removeFromSuperview];
    }
    if (itemNum == 0) {
        return;
    }

    CGRect tabFrame = self.frame;

    for (NSInteger index = 0; index < itemNum; index++) {
        UILabel *bageLabel = [self whl_getBageLabelView];
        bageLabel.tag = 888 + index;
        CGFloat percentX = (index + 0.55) / itemNum;
        CGFloat x = ceilf(percentX * tabFrame.size.width);
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        bageLabel.frame = CGRectMake(x, y, 18.0, 18.0);//圆形大小为10
        [self addSubview:bageLabel];
        bageLabel.hidden = YES;
        [allItem addObject:bageLabel];
    }
}

- (void)whl_showBadgeOnItemIndex:(NSInteger)index WithNum:(NSInteger)bageNum {
    NSMutableArray *allItem = [self whl_getItemViewsArr];
    if (allItem.count < index + 1) {
        return;
    }
    UILabel *currentLabel = (UILabel *)[allItem objectAtIndex:index];
    if (bageNum > 0) {
        if (bageNum < 99) {
            currentLabel.text = [NSString stringWithFormat:@"%ld", (long)bageNum];
        } else {
            currentLabel.text = @"...";
        }
        currentLabel.hidden = NO;
    } else {
        currentLabel.hidden = YES;
    }
}

- (void)whl_refreshBageView {
    NSMutableArray *allItem = [self whl_getItemViewsArr];

    for (UIView *itemView in allItem) {
        [self bringSubviewToFront:itemView];
    }
}

@end
