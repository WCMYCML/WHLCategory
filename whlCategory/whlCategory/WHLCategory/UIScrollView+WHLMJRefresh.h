//
//  UIScrollView+whl_MJRefresh.h
//  DramaProject
//
//  Created by awhl_in on 16/8/10.
//  Copyright © 2016年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (WHLMJRefresh)

- (void)whl_addScrollViewRefreshHeaderWithBlock:(dispatch_block_t)refreshBlock;

- (void)whl_addScrollViewReafresFootWithBlock:(dispatch_block_t)refreshBlock;

//设置加载更多结束
- (void)whl_ResetFootRefreshView;

///显示没有数据提示
- (void)whl_ShowNoDataStatus:(BOOL)noMoreData;

//给当前页面添加刷新处理
- (void)whl_addTableMJRefreshHeaderOn:delegate withAction:(SEL)action;
- (void)whl_addTableMJRefreshFooterOn:delegate withAction:(SEL)action;

- (void)whl_startMJHeaderRefresh;
- (void)whl_endHeaderRefresh;
- (void)whl_endFooterRefresh;
- (void)whl_endHeaderFooterRefresh;

- (void)whl_autoRefresh:(BOOL)isAutoRefresh;
@end
