//
//  UITableView+WHLRegisterCell.h
//
//  Created by Haolin Wang on 2017/7/1.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WHLRegisterCell)


/**
 注册cell
 @param cells cell数组
 */
- (void)whl_registerCellWithNibCells:(NSArray <NSString*> *)cells;

- (void)whl_registerCellWithClassCells:(NSArray <NSString *> *)cells;

/**
 获取对应cell
 */

- (UITableViewCell *)whl_dequeueReusableCellWithIdentifier:(NSString *)cell forIndexPath:(NSIndexPath *)indexPath;




@end
