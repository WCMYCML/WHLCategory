//
//  UITableView+WHLFootNoDateView.h
//  CrudeOilThrough
//
//  Created by 浩霖 on 2018/8/16.
//  Copyright © 2018年 wanglz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WHLFootNoDateView)

@property (nonatomic, strong) UIView *whl_footNoDataView;

@property (nonatomic ) NSInteger whl_isShowNoDateView;  //0 是不需要显示没有更多数据View  没人为0

@property (nonatomic) CGFloat whl_noDateViewHight;





@end
