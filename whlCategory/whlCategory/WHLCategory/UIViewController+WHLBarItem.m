//
//  UIViewController+WHLBarItem.m
//
//  Created by Haolin Wang on 16/7/21.
//  Copyright © 2016年 Haolin Wang. All rights reserved.
//

#import "UIViewController+WHLBarItem.h"
#import "UIBarButtonItem+WHLCreate.h"

//字体大小
CGFloat const TEXT_FONT = 18;

@implementation UIViewController (WHLBarItem)

/**
 *  导航栏添加左边图片按钮
 */
- (UIButton *)whl_createLeftItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *leftItem =  [self buttonWithImage:imageName title:nil target:target selector:sel tag:tag];
    [leftItem sizeToFit];

    if (@available(iOS 11.0, *)) {
        leftItem.frame = CGRectMake(0, 0, leftItem.frame.size.width + 14 + 20, 40);
        leftItem.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    } else {
        leftItem.frame = CGRectMake(0, 0, leftItem.frame.size.width + 30, 40);
        leftItem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];

    return leftItem;
}

/**
 *  导航栏添加左边带有消息未读数目按钮
 */
- (UILabel *)whl_createLeftItemWithUnReadCount:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *leftItem = [self buttonWithImage:imageName title:nil target:target selector:sel tag:tag];
    leftItem.frame = CGRectMake(0, 2, 40, 40);
    leftItem.imageEdgeInsets = UIEdgeInsetsMake(0, -(40 - CGRectGetWidth(leftItem.imageView.frame)) / 2, 0, (40 - CGRectGetWidth(leftItem.imageView.frame)) / 2);

    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 45, 40)];
    countLabel.textAlignment = NSTextAlignmentLeft;
    countLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    countLabel.textColor = [UIColor whiteColor];
    [leftItem addSubview:countLabel];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    return countLabel;
}

/**
 *  导航栏添加左边文字按钮
 */
- (UIButton *)whl_createLeftItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *leftItem = [self buttonWithImage:nil title:title target:target selector:sel tag:tag];
    leftItem.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [leftItem setTitleColor:color forState:UIControlStateNormal];
    CGSize size = [title boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: leftItem.titleLabel.font } context:nil].size;
    leftItem.frame = CGRectMake(0, 2, size.width, 40);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    return leftItem;
}

/**
 *  导航栏添加右边图片按钮
 */
- (UIButton *)whl_createRightItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *rightItem = [self buttonWithImage:imageName title:nil target:target selector:sel tag:tag];
    rightItem.frame = CGRectMake(0, 2, 40, 40);

    rightItem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    return rightItem;
}

/**
 *  导航栏添加右边文字按钮
 */
- (UIButton *)whl_createRightItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *rightItem = [self buttonWithImage:nil title:title target:target selector:sel tag:tag];
    [rightItem setTitleColor:color forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    CGSize size = [title boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: rightItem.titleLabel.font } context:nil].size;

    rightItem.frame = CGRectMake(0, 2, size.width + 30, 40);
    rightItem.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    return rightItem;
}

/**
 *  导航栏添加右边多图片按钮
 */
- (void)whl_createRightItemsWithImages:(NSArray *)imageNameArr target:(id)target selector:(SEL)sel tags:(NSArray *)tagArr {
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNameArr.count; i++) {
        UIButton *rightItem = [self buttonWithImage:[imageNameArr objectAtIndex:i] title:nil target:target selector:sel tag:[[tagArr objectAtIndex:i] integerValue]];
        rightItem.frame = CGRectMake(0, 2, 40, 40);

        [rightItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        rightItem.imageEdgeInsets = UIEdgeInsetsMake(0, (40 - CGRectGetWidth(rightItem.imageView.frame)) / 2, 0, -(40 - CGRectGetWidth(rightItem.imageView.frame)) / 2);
        rightItem.adjustsImageWhenHighlighted = NO;
        [buttonArr addObject:[[UIBarButtonItem alloc] initWithCustomView:rightItem]];
    }
    self.navigationItem.rightBarButtonItems = buttonArr;
}

- (void)whl_createRightItemsWithTextArray:(NSArray *)textArr target:(id)target selector:(SEL)sel tags:(NSArray *)tagArr
{
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < textArr.count; i++) {
        UIButton *rightItem = [self buttonWithImage:nil title:textArr[i] target:target selector:sel tag:[[tagArr objectAtIndex:i] integerValue]];
        rightItem.frame = CGRectMake(0, 2, 40, 40);

        [rightItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        rightItem.imageEdgeInsets = UIEdgeInsetsMake(0, (40 - CGRectGetWidth(rightItem.imageView.frame)) / 2, 0, -(40 - CGRectGetWidth(rightItem.imageView.frame)) / 2);
        rightItem.adjustsImageWhenHighlighted = NO;
        [buttonArr addObject:[[UIBarButtonItem alloc] initWithCustomView:rightItem]];
    }
    self.navigationItem.rightBarButtonItems = buttonArr;
}

#pragma mark private method

- (UIButton *)buttonWithImage:(NSString *)image title:(NSString *)title target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT];
    }
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//      button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

@end
