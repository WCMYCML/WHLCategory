//
//  UICollectionView+WHLRegisterCell.m
//
//  Created by 王浩霖 on 2017/7/5.
//  Copyright © 2017年 王浩霖. All rights reserved.
//

#import "UICollectionView+WHLRegisterCell.h"

@implementation UICollectionView (WHLRegisterCell)

- (void)whl_registerCellWithNibCells:(NSArray <NSString *> *)cells {
    //
    for (NSString *IndexCell in cells) {
        [self registerNib:[UINib nibWithNibName:IndexCell bundle:nil] forCellWithReuseIdentifier:IndexCell];
    }
}

- (void)whl_registerCellWithClassCells:(NSArray <NSString *> *)cells {
    //
    for (NSString *indexCell in cells) {
        [self registerClass:NSClassFromString(indexCell) forCellWithReuseIdentifier:indexCell];
    }
}

- (void)whl_registerHeadNibReusableViewWithStrs:(NSArray <NSString *> *)cells {
    for (NSString *headCell in cells) {
        [self registerNib:[UINib nibWithNibName:headCell bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headCell];
    }
}

- (void)whl_registerFootNibReusableViewWithStrs:(NSArray <NSString *> *)cells {
    for (NSString *headCell in cells) {
        [self registerNib:[UINib nibWithNibName:headCell bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headCell];
    }
}

@end
