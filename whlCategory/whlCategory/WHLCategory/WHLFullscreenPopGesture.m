//
//  WHLFullscreenPopGesture.m
//
//  Created by Haolin Wang on 2019/7/17.
//  Copyright © 2019 Haolin Wang. All rights reserved.
//

#import "WHLFullscreenPopGesture.h"
#import <objc/message.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface WHLFullscreenPopGestureDelegate : NSObject<UIGestureRecognizerDelegate>
+ (instancetype)shared;
@end

@implementation WHLFullscreenPopGestureDelegate
+ (instancetype)shared {
    static WHLFullscreenPopGestureDelegate *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = WHLFullscreenPopGestureDelegate.alloc.init;
    });
    return instance;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UINavigationController *_Nullable nav = [self _lookupResponder:gestureRecognizer.view class:UINavigationController.class];

    if (nav == nil) return false;

    if (nav.childViewControllers.count <= 1) return false;

    if ([[nav valueForKey:@"isTransitioning"] boolValue]) return false;

    if (nav.topViewController.whl_disableFullscreenGesture) return false;

    if ([self _blindAreaContains:nav point:[touch locationInView:nav.view]]) return false;

    if ([nav.childViewControllers.lastObject isKindOfClass:UINavigationController.class]) return false;

    if (nav.topViewController.whl_considerWebView) return !nav.topViewController.whl_considerWebView.canGoBack;

    return true;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (WHLFullscreenPopGesture.whl_gestureType == WHLFullscreenPopGestureTypeEdgeLeft) return true;

    CGPoint translate = [gestureRecognizer translationInView:gestureRecognizer.view];

    if (translate.x > 0 && translate.y == 0) return true;

    return false;
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateFailed ||
        gestureRecognizer.state == UIGestureRecognizerStateCancelled) return false;

    if (WHLFullscreenPopGesture.whl_gestureType == WHLFullscreenPopGestureTypeEdgeLeft) {
        [self _cancelGesture:otherGestureRecognizer];
        return true;
    }

    UINavigationController *nav = [self _lookupResponder:gestureRecognizer.view class:UINavigationController.class];

    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];

    if ([self _blindAreaContains:nav point:location]) return false;

    if ([otherGestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] ||
        [otherGestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) {
        if ([otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
            return [self _shouldRecognizeSimultaneously:(id)otherGestureRecognizer.view gestureRecognizer:gestureRecognizer otherGestureRecognizer:otherGestureRecognizer];
        }
    }

    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"_MKMapContentView")] ||
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIWebTouchEventsGestureRecognizer")]) {
        if ([self _edgeAreaContains:nav point:location]) {
            [self _cancelGesture:otherGestureRecognizer];
            return true;
        } else return false;
    }

    if ([otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) return false;

    return false;
}

- (BOOL)_shouldRecognizeSimultaneously:(UIScrollView *)scrollView gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer otherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([scrollView isKindOfClass:NSClassFromString(@"_UIQueuingScrollView")]) {
        if (scrollView.isDecelerating) return false;

        UIPageViewController *pageVC = [self _lookupResponder:scrollView class:UIPageViewController.class];

        if (pageVC.viewControllers.count == 0) return false;

        if ([pageVC.dataSource pageViewController:pageVC viewControllerBeforeViewController:pageVC.viewControllers.firstObject] != nil) return false;

        [self _cancelGesture:otherGestureRecognizer];

        return true;
    }

    CGPoint translate = [gestureRecognizer translationInView:gestureRecognizer.view];

    if (0 == scrollView.contentOffset.x + scrollView.contentInset.left
        && !scrollView.isDecelerating
        && translate.x > 0 && 0 == translate.y) {
        [self _cancelGesture:otherGestureRecognizer];
        return true;
    }

    return false;
}

// --

- (nullable __kindof UIResponder *)_lookupResponder:(UIView *)view class:(Class)cls {
    __kindof UIResponder *_Nullable next = view.nextResponder;
    while (next != nil && [next isKindOfClass:cls] == NO)
        next = next.nextResponder;
    return next;
}

- (void)_cancelGesture:(UIGestureRecognizer *)gesture {
    [gesture setValue:@(UIGestureRecognizerStateCancelled) forKey:@"state"];
}

- (BOOL)_edgeAreaContains:(UINavigationController *)nav point:(CGPoint)point {
    CGFloat offset = 50;
    CGRect rect = CGRectMake(0, 0, offset, nav.view.bounds.size.height);

    return [self _rectContains:nav rect:rect point:point shouldConvertRect:NO];
}

- (BOOL)_blindAreaContains:(UINavigationController *)nav point:(CGPoint)point {
    for (NSValue *rect in nav.topViewController.whl_blindArea) {
        if ([self _rectContains:nav rect:[rect CGRectValue] point:point shouldConvertRect:YES]) return true;
    }

    for (UIView *view in nav.topViewController.whl_blindAreaViews) {
        if ([self _rectContains:nav rect:[view frame] point:point shouldConvertRect:YES]) return true;
    }

    return false;
}

- (BOOL)_rectContains:(UINavigationController *)nav rect:(CGRect)rect point:(CGPoint)point shouldConvertRect:(BOOL)shouldConvert {
    if (shouldConvert) {
        rect = [nav.topViewController.view convertRect:rect toView:nav.view];
    }

    return CGRectContainsPoint(rect, point);
}

@end

#pragma mark -

@interface WHLSnapshot : NSObject
- (instancetype)initWithTarget:(UIViewController *)target;
@end

@interface WHLSnapshot ()
@property (nonatomic, weak, readonly, nullable) UIViewController *target;
@property (nonatomic, strong, readonly) UIView *rootView;
@property (nonatomic, strong, nullable) UIView *maskView;
@end

@implementation WHLSnapshot
- (instancetype)initWithTarget:(UIViewController *)target {
    self = [super init];
    if (self) {
        // target
        _target = target;

        // nav
        UINavigationController *nav = target.navigationController;
        _rootView = [[UIView alloc] initWithFrame:nav.view.bounds];
        _rootView.backgroundColor = UIColor.whiteColor;

        // snapshot
        switch (target.whl_displayMode) {
            case WHLPreViewDisplayModeSnapshot: {
                UIView *superview = nav.tabBarController != nil ? nav.tabBarController.view : nav.view;
                UIView *snapshot = [superview snapshotViewAfterScreenUpdates:NO];
                [_rootView addSubview:snapshot];
            }
            break;
            case WHLPreViewDisplayModeOrigin: {
                if (nav.isNavigationBarHidden == false) {
                    CGRect rect = [nav.view convertRect:nav.navigationBar.frame toView:nav.view.window];
                    rect.size.height += rect.origin.y + 1;
                    rect.origin.y = 0;
                    UIView *navbarSnapshot = [nav.view.superview resizableSnapshotViewFromRect:rect afterScreenUpdates:false withCapInsets:UIEdgeInsetsZero];
                    [_rootView addSubview:navbarSnapshot];
                }

                UITabBar *tabBar = nav.tabBarController.tabBar;
                if (tabBar.isHidden == false) {
                    CGRect rect = [tabBar convertRect:tabBar.bounds toView:nav.view.window];
                    rect.origin.y -= 1;
                    rect.size.height += 1;
                    UIView *snapshot = [nav.view.window resizableSnapshotViewFromRect:rect afterScreenUpdates:false withCapInsets:UIEdgeInsetsZero];
                    snapshot.frame = rect;
                    [_rootView addSubview:snapshot];
                }
            }
            break;
        }

        // mask
        if (WHLFullscreenPopGesture.whl_transitionMode == WHLFullscreenPopGestureTransitionModeMaskAndShifting) {
            _maskView = [[UIView alloc] initWithFrame:_rootView.bounds];
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            [_rootView addSubview:_maskView];
        }
    }
    return self;
}

- (void)began {
    if (_target.whl_displayMode == WHLPreViewDisplayModeOrigin) {
        [_rootView insertSubview:_target.view atIndex:0];
    }
}

- (void)completed {
    if (_target.whl_displayMode == WHLPreViewDisplayModeOrigin &&
        _target.view.superview == _rootView) {
        [_target.view removeFromSuperview];
    }
}

@end

#pragma mark -

@interface UIViewController (_WHLFullscreenPopGesturePrivate)
@property (nonatomic, strong, nullable) WHLSnapshot *whl_previousViewControllerSnapshot;
@end

@implementation UIViewController (_WHLFullscreenPopGesturePrivate)


- (void)setWhl_previousViewControllerSnapshot:( nullable WHLSnapshot *)whl_previousViewControllerSnapshot{
    objc_setAssociatedObject(self, @selector(whl_previousViewControllerSnapshot), whl_previousViewControllerSnapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (nullable WHLSnapshot *)whl_previousViewControllerSnapshot {
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark -

@interface WHLTransitionHandler : NSObject
+ (instancetype)shared;

@property (nonatomic) CGFloat shift;
@end

@implementation WHLTransitionHandler
+ (instancetype)shared {
    static WHLTransitionHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = WHLTransitionHandler.alloc.init;
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shift = -UIScreen.mainScreen.bounds.size.width * 0.382;
    }
    return self;
}

- (void)pushWithNav:(UINavigationController *)nav viewController:(UIViewController *)viewController {
    UIViewController *last = nav.childViewControllers.lastObject;
    if (last != nil) {
        viewController.whl_previousViewControllerSnapshot = [WHLSnapshot.alloc initWithTarget:last];
    }
}

- (void)beganWithNav:(UINavigationController *)nav viewController:(UIViewController *)viewController offset:(CGFloat)offset {
    WHLSnapshot *snapshot = viewController.whl_previousViewControllerSnapshot;
    if (snapshot == nil) return;

    // keyboard
    [nav.view endEditing:YES];
    [nav.view.superview insertSubview:snapshot.rootView belowSubview:nav.view];

    //
    [snapshot began];

    snapshot.rootView.transform = CGAffineTransformMakeTranslation(self.shift, 0);

    if (WHLFullscreenPopGesture.whl_transitionMode == WHLFullscreenPopGestureTransitionModeMaskAndShifting) {
        snapshot.maskView.alpha = 1;
        CGFloat width = snapshot.rootView.frame.size.width;
        snapshot.maskView.transform = CGAffineTransformMakeTranslation(-(self.shift + width), 0);
    }

    //
    if (viewController.whl_viewWillBeginDragging) {
        viewController.whl_viewWillBeginDragging(viewController);
    }

    [self changedWithNav:nav viewController:viewController offset:offset];
}

- (void)changedWithNav:(UINavigationController *)nav viewController:(UIViewController *)viewController offset:(CGFloat)offset {
    WHLSnapshot *snapshot = viewController.whl_previousViewControllerSnapshot;
    if (snapshot == nil) return;

    if (offset < 0) offset = 0;
    //
    nav.view.transform = CGAffineTransformMakeTranslation(offset, 0);
    //
    CGFloat width = snapshot.rootView.frame.size.width;
    CGFloat rate = offset / width;
    snapshot.rootView.transform = CGAffineTransformMakeTranslation(self.shift * (1 - rate), 0);
    if (WHLFullscreenPopGesture.whl_transitionMode == WHLFullscreenPopGestureTransitionModeMaskAndShifting) {
        snapshot.maskView.alpha = 1 - rate;
        snapshot.maskView.transform = CGAffineTransformMakeTranslation(-(self.shift + width) + (self.shift * rate) + offset, 0);
    }
    //
    if (viewController.whl_viewDidDrag) {
        viewController.whl_viewDidDrag(viewController);
    }
}

- (void)completedWithNav:(UINavigationController *)nav viewController:(UIViewController *)viewController offset:(CGFloat)offset {
    WHLSnapshot *snapshot = viewController.whl_previousViewControllerSnapshot;
    if (snapshot == nil) return;

    CGFloat screenwidth = nav.view.frame.size.width;
    CGFloat rate = offset / screenwidth;
    CGFloat maxOffset = WHLFullscreenPopGesture.whl_maxOffsetToTriggerPop;
    BOOL shouldPop = rate > maxOffset;
    CGFloat animDuration = 0.25;

    if (shouldPop == false) {
        animDuration = animDuration * (offset / (maxOffset * screenwidth) ) + 0.05;
    }

    [UIView animateWithDuration:animDuration animations:^{
        if (shouldPop == true) {
            snapshot.rootView.transform = CGAffineTransformIdentity;
            snapshot.maskView.transform = CGAffineTransformIdentity;
            snapshot.maskView.alpha = 0.001;
            nav.view.transform = CGAffineTransformMakeTranslation(screenwidth, 0);
        } else {
            snapshot.maskView.transform = CGAffineTransformMakeTranslation(-(self.shift + screenwidth), 0);
            snapshot.maskView.alpha = 1;
            nav.view.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [snapshot.rootView removeFromSuperview];
        [snapshot completed];

        if (shouldPop == true) {
            nav.view.transform = CGAffineTransformIdentity;
            [nav popViewControllerAnimated:false];
        }

        if (viewController.whl_viewDidEndDragging) {
            viewController.whl_viewDidEndDragging(viewController);
        }
    }];
}

@end

#pragma mark -

@interface UINavigationController (_WHLFullscreenPopGesturePrivate)
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *whl_fullscreenGesture;
@end

@implementation UINavigationController (_WHLFullscreenPopGesturePrivate)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = UINavigationController.class;
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(whl_pushViewController:animated:);

        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)whl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self whl_setupIfNeeded];
    [WHLTransitionHandler.shared pushWithNav:self viewController:viewController];
    [self whl_pushViewController:viewController animated:animated];
}

- (void)whl_setupIfNeeded {
    if (self.interactivePopGestureRecognizer == nil) return;

    if ([objc_getAssociatedObject(self, _cmd) boolValue]) return;

    objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.interactivePopGestureRecognizer.enabled = false;
    self.view.clipsToBounds = false;

    [CATransaction begin];
    [CATransaction setDisableActions:true];
    self.view.layer.shadowOffset = CGSizeMake(0.5, 0);
    self.view.layer.shadowColor = [[UIColor alloc] initWithWhite:0.2 alpha:1].CGColor;
    self.view.layer.shadowOpacity = 1;
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    [CATransaction commit];
    [self.view addGestureRecognizer:self.whl_fullscreenGesture];
}

- (UIPanGestureRecognizer *)whl_fullscreenGesture {
    UIPanGestureRecognizer *_Nullable gesture = objc_getAssociatedObject(self, _cmd);
    if (gesture == nil) {
        if (WHLFullscreenPopGesture.whl_gestureType == WHLFullscreenPopGestureTypeEdgeLeft) {
            gesture = UIScreenEdgePanGestureRecognizer.alloc.init;
            [(UIScreenEdgePanGestureRecognizer *)gesture setEdges:UIRectEdgeLeft];
        } else {
            gesture = UIPanGestureRecognizer.alloc.init;
        }

        gesture.delaysTouchesBegan = YES;
        gesture.delegate = WHLFullscreenPopGestureDelegate.shared;
        [gesture addTarget:self action:@selector(whl_handleFullscreenGesture:)];
        objc_setAssociatedObject(self, _cmd, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gesture;
}

- (void)whl_handleFullscreenGesture:(UIPanGestureRecognizer *)gesture {
    CGFloat offset = [gesture translationInView:gesture.view].x;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [WHLTransitionHandler.shared beganWithNav:self viewController:self.topViewController offset:offset];
            break;
        case UIGestureRecognizerStateChanged:
            [WHLTransitionHandler.shared changedWithNav:self viewController:self.topViewController offset:offset];
            break;
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled: case UIGestureRecognizerStateFailed:
            [WHLTransitionHandler.shared completedWithNav:self viewController:self.topViewController offset:offset];
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}

@end

#pragma mark -

@implementation WHLFullscreenPopGesture

static WHLFullscreenPopGestureType _whl_gestureType = WHLFullscreenPopGestureTypeEdgeLeft;

+ (void)setWhl_gestureType:(WHLFullscreenPopGestureType)whl_gestureType{
    _whl_gestureType = whl_gestureType;

}

+ (WHLFullscreenPopGestureType)whl_gestureType {
    return _whl_gestureType;
}

static WHLFullscreenPopGestureTransitionMode _whl_whl_transitionMode = WHLFullscreenPopGestureTransitionModeShifting;


+ (void)setWhl_whl_transitionMode:(WHLFullscreenPopGestureTransitionMode)whl_whl_transitionMode{
    _whl_whl_transitionMode = whl_whl_transitionMode;

    
}
+ (WHLFullscreenPopGestureTransitionMode)transitionMode {
    return _whl_whl_transitionMode;
}

static CGFloat _whl_maxOffsetToTriggerPop = 0.35;

+ (void)setWhl_maxOffsetToTriggerPop:(CGFloat)whl_maxOffsetToTriggerPop{
    _whl_maxOffsetToTriggerPop = whl_maxOffsetToTriggerPop;

}

+ (CGFloat)whl_maxOffsetToTriggerPop {
    return _whl_maxOffsetToTriggerPop;
}

@end

#pragma mark -

@implementation UIViewController (WHLExtendedFullscreenPopGesture)

#pragma mark - ******************** for hide navcBar **************************

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(whl_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)whl_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self whl_viewWillAppear:animated];

    if (self.whl_willAppearInjectBlock) {
        self.whl_willAppearInjectBlock(self, animated);
    }
}

- (_WHLViewControllerWillAppearInjectBlock)whl_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWhl_willAppearInjectBlock:(_WHLViewControllerWillAppearInjectBlock)block {
    objc_setAssociatedObject(self, @selector(whl_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - ******************** end ***************************************
- (void)setwhl_displayMode:(WHLPreViewDisplayMode)whl_displayMode {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    objc_setAssociatedObject(self, @selector(whl_displayMode), @(whl_displayMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WHLPreViewDisplayMode)whl_displayMode {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setwhl_disableFullscreenGesture:(BOOL)whl_disableFullscreenGesture {
    objc_setAssociatedObject(self, @selector(whl_disableFullscreenGesture), @(whl_disableFullscreenGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)whl_disableFullscreenGesture {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)whl_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setwhl_prefersNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(whl_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setwhl_blindArea:(nullable NSArray<NSValue *> *)whl_blindArea {
    objc_setAssociatedObject(self, @selector(whl_blindArea), whl_blindArea, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (nullable NSArray<NSValue *> *)whl_blindArea {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setwhl_blindAreaViews:(nullable NSArray<UIView *> *)whl_blindAreaViews {
    objc_setAssociatedObject(self, @selector(whl_blindAreaViews), whl_blindAreaViews, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (nullable NSArray<UIView *> *)whl_blindAreaViews {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setwhl_viewWillBeginDragging:(void (^_Nullable)(__kindof UIViewController *_Nonnull))whl_viewWillBeginDragging {
    objc_setAssociatedObject(self, @selector(whl_viewWillBeginDragging), whl_viewWillBeginDragging, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^_Nullable)(__kindof UIViewController *_Nonnull))whl_viewWillBeginDragging {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setwhl_viewDidDrag:(void (^_Nullable)(__kindof UIViewController *_Nonnull))whl_viewDidDrag {
    objc_setAssociatedObject(self, @selector(whl_viewDidDrag), whl_viewDidDrag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^_Nullable)(__kindof UIViewController *_Nonnull))whl_viewDidDrag {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setwhl_viewDidEndDragging:(void (^_Nullable)(__kindof UIViewController *_Nonnull))whl_viewDidEndDragging {
    objc_setAssociatedObject(self, @selector(whl_viewDidEndDragging), whl_viewDidEndDragging, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^_Nullable)(__kindof UIViewController *_Nonnull))whl_viewDidEndDragging {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setwhl_considerWebView:(nullable WKWebView *)whl_considerWebView {
    whl_considerWebView.allowsBackForwardNavigationGestures = YES;
    objc_setAssociatedObject(self, @selector(whl_considerWebView), whl_considerWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable WKWebView *)whl_considerWebView {
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark -
@implementation UINavigationController (WHLExtendedFullscreenPopGesture)
- (UIGestureRecognizerState)whl_fullscreenGestureState {
    return self.whl_fullscreenGesture.state;
}

@end

#pragma mark - ********************🔥 导航条hide管理 🔥**************************

@implementation UINavigationController (WHLPrefersNavigationBar)

+ (void)load
{
    // Inject "-pushViewController:animated:"
    Method originalMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(whl_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)whl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Handle perferred navigation bar appearance.
    [self whl_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    // Forward to primary implementation.
    [self whl_pushViewController:viewController animated:animated];
}

- (void)whl_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.whl_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    _WHLViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.whl_prefersNavigationBarHidden animated:animated];
        }
    };
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.whl_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.whl_willAppearInjectBlock) {
        disappearingViewController.whl_willAppearInjectBlock = block;
    }
}

- (BOOL)whl_viewControllerBasedNavigationBarAppearanceEnabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.whl_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setWhl_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enable {
    SEL key = @selector(whl_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

NS_ASSUME_NONNULL_END
