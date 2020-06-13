//
//  UITabBar+WHLTabBadgeView.h
//
//  Created by 浩霖 on 2018/8/12.
//  Copyright © 2018年 wanglz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (WHLTabBadgeView)

///设置标签个数
- (void)whl_setAllIteNum:(NSInteger)itemNum;

- (void)whl_showBadgeOnItemIndex:(NSInteger)index WithNum:(NSInteger)bageNum;   ///如果bageNum为零则是隐藏


///刷新自定义Bage
- (void)whl_refreshBageView;


@end
