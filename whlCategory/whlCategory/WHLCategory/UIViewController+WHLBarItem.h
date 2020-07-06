//
//  UIViewController+WHLBarItem.h
//
//  Created by 罗义德 on 16/7/21.
//  Copyright © 2016年 Haolin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  与导航栏按钮相关的类别
 */

@interface UIViewController (WHLBarItem)


/**
 *  导航栏添加左边图片按钮
 */
- (UIButton *)whl_createLeftItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag;

/**
 *  导航栏添加左边带有消息未读数目按钮
 */
- (UILabel *)whl_createLeftItemWithUnReadCount:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag;

/**
 *  导航栏添加左边文字按钮
 */
- (UIButton *)whl_createLeftItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag;

/**
 *  导航栏添加右边图片按钮
 */
- (UIButton *)whl_createRightItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag;

/**
 *  导航栏添加右边文字按钮
 */
- (UIButton *)whl_createRightItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag;

/**
 *  导航栏添加右边多图片按钮
 */
- (void)whl_createRightItemsWithImages:(NSArray *)imageNameArr target:(id)target selector:(SEL)sel tags:(NSArray *)tagArr;

/**
 *  导航栏添加右边多文字按钮
 */
- (void)whl_createRightItemsWithTextArray:(NSArray *)textArr target:(id)target selector:(SEL)sel tags:(NSArray *)tagArr;

@end
