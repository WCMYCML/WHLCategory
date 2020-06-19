//
//  UIScrollView+WHLMJRefresh.m
//  DramaProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 xll. All rights reserved.
//

#import "UIScrollView+WHLMJRefresh.h"
#import "MJRefresh.h"

@implementation UIScrollView (WHLMJRefresh)

- (void)whl_addScrollViewRefreshHeaderWithBlock:(dispatch_block_t)refreshBlock {
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];

    for (int i = 0; i <= 68; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pulldown%d", i]];
        [idleImages addObject:image];
    }

//     设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i <= 68; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pulldown%d", i]];
        [refreshingImages addObject:image];
    }

    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:refreshBlock];
    [header setImages:idleImages duration:2.5f forState:MJRefreshStateIdle];
    [header setImages:refreshingImages duration:2.8f forState:MJRefreshStatePulling];
    [header setImages:refreshingImages duration:2.5f forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;

//    MJRefreshNormalHeader *headFresh = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshBlock];
//    headFresh.stateLabel.textColor = CQ_999999_Color;
//    self.mj_header =  headFresh;
}

- (void)whl_addScrollViewReafresFootWithBlock:(dispatch_block_t)refreshBlock {
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshBlock];
    // 禁止自动加载
    //    footer.automaticallyRefresh = YES;
    //    footer.triggerAutomaticallyRefreshPercent = 2.0;

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshBlock];
    footer.stateLabel.numberOfLines = 0;
    footer.stateLabel.textColor = CQ_999999_Color;
    [footer setTitle:@"上拉可以加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"\n—————  别滑了，已经到底了  —————\n" forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
}

- (void)whl_ResetFootRefreshView {
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *currentSelf = (UITableView *)self;
        currentSelf.isShowNoDateView =  0;
    }
}

- (void)whl_ShowNoDataStatus:(BOOL)noMoreData {
    [self.mj_footer endRefreshing];

    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *currentSelf = (UITableView *)self;
        currentSelf.isShowNoDateView = noMoreData ? 1 : 0;
    }

    if (self.mj_footer) {
        self.mj_footer.hidden = noMoreData;
    }

//        [self.mj_footer endRefreshingWithNoMoreData];
//    }else{
//        [self.mj_footer endRefreshing];
//    }
}

- (void)whl_addTableMJRefreshHeaderOn:delegate withAction:(SEL)action
{
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];

    for (int i = 1; i <= 28; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pulldown%d", i]];
        [idleImages addObject:image];
        [idleImages addObject:image];
    }

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pullcircle%d", i]];
        [refreshingImages addObject:image];
    }
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:delegate refreshingAction:action];
    // Set the ordinary state of animated images
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    // Set the refreshing state of animated images
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;
}

- (void)whl_addTableMJRefreshFooterOn:delegate withAction:(SEL)action
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:delegate refreshingAction:action];
    // 禁止自动加载
//    footer.automaticallyRefresh = YES;
//    footer.triggerAutomaticallyRefreshPercent = 2.0;
    [footer setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即刷新" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"正在刷新数据中..." forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
}

- (void)whl_startMJHeaderRefresh
{
    [self.mj_header beginRefreshing];
}

- (void)whl_endHeaderRefresh
{
    [self.mj_header endRefreshing];
}

- (void)whl_endFooterRefresh
{
    [self.mj_footer endRefreshing];
}

- (void)whl_endHeaderFooterRefresh
{
    [self whl_endHeaderRefresh];
    [self whl_endFooterRefresh];
}

- (void)whl_autoRefresh:(BOOL)isAutoRefresh
{
    MJRefreshAutoNormalFooter *footer =  (MJRefreshAutoNormalFooter *)self.mj_footer;
    footer.automaticallyRefresh = isAutoRefresh;
}

@end
