//
//  UICollectionView+WHLRegisterCell.h
//
//  Created by Haolin Wang on 2017/7/5.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (WHLRegisterCell)


- (void)whl_registerCellWithNibCells:(NSArray <NSString*> *)cells;

- (void)whl_registerCellWithClassCells:(NSArray <NSString *> *)cells;

//注册头部视图
- (void)whl_registerHeadNibReusableViewWithStrs:(NSArray <NSString *> *)cells;

- (void)whl_registerFootNibReusableViewWithStrs:(NSArray <NSString *> *)cells;


@end
