//
//  UIView+CustomAlertView.h
//
//  Created by Haolin Wang on 2017/4/17.
//  Copyright © 2017年 Haolin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TagValue  3333
typedef NS_ENUM(NSInteger, WHLCustomAnimationMode) {
    WHLCustomAnimationModeAlert = 0,//弹出效果
    WHLCustomAnimationModeDrop, //由上方掉落
    WHLCustomAnimationModeShare,//下方弹出（类似分享效果）
    WHLCustomAnimationModeNone,//没有动画
};

@interface UIView (CustomAlertView)


@property (nonatomic, copy) dispatch_block_t CQhideCustomAlertViewBlock;

/**
 显示 弹出view 任意view导入头文件之后即可调用
 @param animationMode CustomAnimationMode 三种模式
 @param alpha CGFloat  背景透明度 0-1  默认0.2  传-1即为默认值
 @param isNeed BOOL 是否需要背景模糊效果
 */
-(void)whl_showInWindowWithMode:(WHLCustomAnimationMode)animationMode inView:(UIView *)superV bgAlpha:(CGFloat)alpha needEffectView:(BOOL)isNeed;


/**
 隐藏 view
 */
-(void)whl_hideView;


/**
 给view 各个边加 layer.border
 */
- (void)whl_setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

@end

