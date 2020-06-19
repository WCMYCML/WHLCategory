//
//  UITableView+WHLRegisterCell.m
//
//  Created by Haolin Wang on 2017/7/1.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import "UITableView+WHLRegisterCell.h"

@implementation UITableView (WHLRegisterCell)

- (void)whl_registerCellWithNibCells:(NSArray <NSString *> *)cells {
    for (NSString *cell in cells) {
        [self registerNib:[UINib nibWithNibName:cell bundle:nil] forCellReuseIdentifier:cell];
    }
}

- (void)whl_registerCellWithClassCells:(NSArray <NSString *> *)cells {
    for (NSString *currentCell in cells) {
        [self registerClass:NSClassFromString(currentCell) forCellReuseIdentifier:currentCell];
    }
}

- (UITableViewCell *)whl_dequeueReusableCellWithIdentifier:(NSString *)cellIndent forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellIndent forIndexPath:indexPath];

    if (cell == nil) {
        [self registerNib:[UINib nibWithNibName:cellIndent bundle:nil] forCellReuseIdentifier:cellIndent];
        cell = [self dequeueReusableCellWithIdentifier:cellIndent forIndexPath:indexPath];
    }
    return cell;
}

@end
