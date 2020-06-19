//
//  UITableView+CQFootNoDateView.m
//  CrudeOilThrough
//
//  Created by 浩霖 on 2018/8/16.
//  Copyright © 2018年 wanglz. All rights reserved.
//

#import "UITableView+WHLFootNoDateView.h"
#import <objc/runtime.h>

static const void *const WHLFootNoDateViewKey = &WHLFootNoDateViewKey;

@implementation UITableView (WHLFootNoDateView)

- (void)setWhl_noDateViewHight:(CGFloat)whl_noDateViewHight {
    const void *key = (const void *)(WHLFootNoDateViewKey + 1);
    objc_setAssociatedObject(self, key,
                             [NSNumber numberWithFloat:whl_noDateViewHight],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)whl_noDateViewHight {
    const void *key = (const void *)(WHLFootNoDateViewKey + 1);
    CGFloat max = [objc_getAssociatedObject(self, key) floatValue];
    if (max <= 0) {
        return 70;
    }
    return max;
}

- (void)setWhl_footNoDataView:(UIView *)whl_footNoDataView {
    if (whl_footNoDataView == nil) {
        whl_footNoDataView = [self whl_getDefaultNoDataView];
    }
    const void *key = (const void *)(WHLFootNoDateViewKey + 2);
    objc_setAssociatedObject(self, key, whl_footNoDataView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)whl_footNoDataView {
    const void *key = (const void *)(WHLFootNoDateViewKey + 2);
    UIView *notFootView = objc_getAssociatedObject(self, key);
    if (notFootView == nil) {
        return [self whl_getDefaultNoDataView];
    }
    return notFootView;
}

- (void)setWhl_isShowNoDateView:(NSInteger)whl_isShowNoDateView {
    const void *key = (const void *)(WHLFootNoDateViewKey + 3);

    objc_setAssociatedObject(self, key,
                             [NSNumber numberWithFloat:whl_isShowNoDateView],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)whl_isShowNoDateView {
    const void *key = (const void *)(WHLFootNoDateViewKey + 3);
    return [objc_getAssociatedObject(self, key) integerValue];
}

//默认图片
- (UIView *)whl_getDefaultNoDataView {
    UIView *defaultView = [UIView  new];
    defaultView.backgroundColor = [UIColor clearColor];

    UILabel *titlLable = [[UILabel alloc] init];
    titlLable.textAlignment = NSTextAlignmentCenter;
    titlLable.font = [UIFont systemFontOfSize:14];
    titlLable.textColor = [UIColor blackColor];
    titlLable.text = @"别滑了， 已经到底了";

    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor grayColor];
    UIView *rightView = [UIView new];
    rightView.backgroundColor = [UIColor grayColor];

    [defaultView addSubview:titlLable];
    [defaultView addSubview:leftView];
    [defaultView addSubview:rightView];

//    [titlLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@20);
//        make.height.equalTo(@20);
//        make.centerX.equalTo(defaultView);
//    }];
//    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(titlLable.mas_left).offset(-20);
//        make.height.equalTo(@1);
//        make.centerY.equalTo(titlLable.mas_centerY);
//        make.width.equalTo(@70);
//    }];
//
//    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(titlLable.mas_right).offset(20);
//        make.height.equalTo(@1);
//        make.centerY.equalTo(titlLable.mas_centerY);
//        make.width.equalTo(@70);
//    }];

    return defaultView;
}

@end
