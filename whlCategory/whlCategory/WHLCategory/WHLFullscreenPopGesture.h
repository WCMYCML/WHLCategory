//
//  WHLFullscreenPopGesture.h
//
//  Created by 王浩霖 on 2019/7/17.
//  Copyright © 2019 Haolin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKWebView;

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    WHLFullscreenPopGestureTypeEdgeLeft,
    WHLFullscreenPopGestureTypeFull,
} WHLFullscreenPopGestureType;

typedef enum : NSUInteger {
    WHLFullscreenPopGestureTransitionModeShifting,
    WHLFullscreenPopGestureTransitionModeMaskAndShifting,
} WHLFullscreenPopGestureTransitionMode;

typedef enum : NSUInteger {
    WHLPreViewDisplayModeSnapshot,
    WHLPreViewDisplayModeOrigin,
} WHLPreViewDisplayMode;

@interface WHLFullscreenPopGesture : NSObject
@property (class, nonatomic) WHLFullscreenPopGestureType whl_gestureType;
@property (class, nonatomic) WHLFullscreenPopGestureTransitionMode whl_transitionMode;
@property (class, nonatomic) CGFloat whl_maxOffsetToTriggerPop;
@end


typedef void (^_WHLViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (WHLExtendedFullscreenPopGesture)
@property (nonatomic, copy) _WHLViewControllerWillAppearInjectBlock whl_willAppearInjectBlock;
@property (nonatomic) WHLPreViewDisplayMode whl_displayMode;
@property (nonatomic) BOOL whl_disableFullscreenGesture;


/**
 隐藏本导航条
 by HaolinWang -  2020年07月23日
*/
/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.

@property (nonatomic, assign) BOOL whl_prefersNavigationBarHidden;
@property (nonatomic, copy, nullable) NSArray<NSValue *> *whl_blindArea;
@property (nonatomic, copy, nullable) NSArray<UIView *> *whl_blindAreaViews;
@property (nonatomic, copy, nullable) void(^whl_viewWillBeginDragging)(__kindof UIViewController *vc);
@property (nonatomic, copy, nullable) void(^whl_viewDidDrag)(__kindof UIViewController *vc);
@property (nonatomic, copy, nullable) void(^whl_viewDidEndDragging)(__kindof UIViewController *vc);
@property (nonatomic, strong, nullable) WKWebView *whl_considerWebView;

@end

@interface UINavigationController (WHLExtendedFullscreenPopGesture)
@property (nonatomic, readonly) UIGestureRecognizerState whl_fullscreenGestureState;
@end

@interface UINavigationController (WHLPrefersNavigationBar)

/// A view controller is able to control navigation bar's appearance by itself,
/// rather than a global way, checking "fd_prefersNavigationBarHidden" property.
/// Default to YES, disable it if you don't want so.
@property (nonatomic, assign) BOOL whl_viewControllerBasedNavigationBarAppearanceEnabled;

@end

NS_ASSUME_NONNULL_END
