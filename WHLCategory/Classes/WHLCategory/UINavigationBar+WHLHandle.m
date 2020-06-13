//
//  UINavigationBar+WHLHandle.m
//
//  Created by 王浩霖 on 2018/4/6.
//  Copyright © 2018年 王浩霖. All rights reserved.
//

#import "UINavigationBar+WHLHandle.h"
#import <objc/runtime.h>
@class MyNavLayer;

@interface UINavigationBar ()
@property (nonatomic, strong) UIImage *backClearImage;
@property (nonatomic, strong) UIImage *lineClearImage;
@property (nonatomic, strong) MyNavLayer *myLayer;    //自定义插入层，自定义操作都要在这一层上进行
@end

static char backClear_key, lineClear_key, myLayer_key;

@implementation UINavigationBar (handle)

#pragma mark -- runtime:get/set
- (void)setBackClearImage:(UIImage *)backClearImage {
    objc_setAssociatedObject(self, &backClear_key, backClearImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)backClearImage {
    return objc_getAssociatedObject(self, &backClear_key);
}

- (void)setLineClearImage:(UIImage *)lineClearImage {
    objc_setAssociatedObject(self, &lineClear_key, lineClearImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)lineClearImage {
    return objc_getAssociatedObject(self, &lineClear_key);
}

- (void)setMyLayer:(MyNavLayer *)myLayer {
    objc_setAssociatedObject(self, &myLayer_key, myLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MyNavLayer *)myLayer {
    return objc_getAssociatedObject(self, &myLayer_key);
}

#pragma mark -- function
- (void)whl_navBarAlpha:(CGFloat)alpha {
    [self clearSystemLayer];
    if (!self.myLayer) {
        //状态栏高度
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        //导航栏高度
        CGFloat barHeight = self.bounds.size.height;
        CGRect barBounds = self.bounds;
        barBounds.size.height = statusHeight + barHeight;
        self.myLayer = [[MyNavLayer alloc]initWithFrame:barBounds];
    }

    self.myLayer.alpha = alpha;

    //通过kvc找到系统导航栏背景层，把自定义层添加到背景层
    /* 系统背景层无法改变其属性 所以通过添加自定义层，改变自定义层去实现效果*/
    [[(UIView *)[self valueForKey:@"backgroundView"] layer] addSublayer:self.myLayer];
}

- (void)whl_navBarBackGroundColor:(UIColor *)color image:(UIImage *)barImage {
    [self clearSystemLayer];
    if (!self.myLayer) {
        //状态栏高度
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        //导航栏高度
        CGFloat barHeight = self.bounds.size.height;

        CGRect barBounds = self.bounds;
        barBounds.size.height = statusHeight + barHeight;

        self.myLayer = [[MyNavLayer alloc]initWithFrame:barBounds];
    }

    if (color) {
        self.myLayer.backColor = color;
    }

    if (barImage) {
        self.myLayer.backImage = barImage;
    }

    //通过kvc找到系统导航栏背景层，把自定义层添加到背景层
    /*系统背景层无法改变其属性 所以通过添加自定义层，改变自定义层上的熟悉去实现效果*/
    [[(UIView *)[self valueForKey:@"backgroundView"] layer] addSublayer:self.myLayer];
}

- (void)whl_navBarMyLayerHeight:(CGFloat)height {
    height = height < 0 ? 0 : height;

    [self clearSystemLayer];

    if (!self.myLayer) {
        self.myLayer = [MyNavLayer layer];
    }
    [self.myLayer setFrame:CGRectMake(0, 0, self.bounds.size.width, height)];

    //通过kvc找到系统导航栏背景层，把自定义层添加到背景层
    /* 亲测，系统背景层无法改变其属性 所以通过添加自定义层，改变自定义层上的熟悉去实现效果*/
    [[(UIView *)[self valueForKey:@"backgroundView"] layer] addSublayer:self.myLayer];
}

- (void)whl_navBarBottomLineHidden:(BOOL)hidden {
    //如果是自定义图层
    if (self.myLayer) {
        self.myLayer.hiddenBottomLine = hidden;
    } else {
        //如果是系统层
        if (hidden) {
            if (!self.lineClearImage) {
                self.lineClearImage = [[UIImage alloc]init];
            }
        } else {
            if (self.lineClearImage) {
                self.lineClearImage = nil;
            }
        }
        [self setShadowImage:self.lineClearImage];
    }
}

- (void)whl_navBarToBeSystem {
    if (self.myLayer) {
        [self.myLayer removeFromSuperlayer];
        self.myLayer = nil;
    }
    if (self.lineClearImage) {
        self.lineClearImage = nil;
    }
    if (self.backClearImage) {
        self.backClearImage = nil;
    }
    [self setBackgroundImage:nil
               forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    self.barStyle = UIBarStyleDefault;
}

//去掉系统导航栏特征
- (void)clearSystemLayer {
    //通过插入空image把背景变透明
    if (!self.backClearImage) {
        self.backClearImage = [[UIImage alloc]init];
        [self setBackgroundImage:self.backClearImage
                   forBarMetrics:UIBarMetricsDefault];
        self.barStyle = UIBarStyleBlackOpaque;
    }
    //去掉系统底线，使用自定义底线
    if (!self.lineClearImage) {
        self.lineClearImage = [[UIImage alloc]init];
        [self setShadowImage:self.lineClearImage];
    }
}

@end

#pragma mark -- 自定义导航栏层
@interface MyNavLayer ()
@property (nonatomic, strong) CALayer *_Nullable backImageView;
@property (nonatomic, strong) CALayer *_Nullable bottomLine;
@end

@implementation MyNavLayer
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self creatMainUIByFrame:frame];
}

- (void)creatMainUIByFrame:(CGRect)frame {
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    [self.backImageView setFrame:CGRectMake(0, 0, width, height)];
    [self addSublayer:self.backImageView];

    [self.bottomLine setFrame:CGRectMake(0, height - 0.5, width, 0.5)];
    [self addSublayer:self.bottomLine];
}

//底层背景层永远透明
- (void)setBackgroundColor:(CGColorRef)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor].CGColor];
}

//设置图片背景颜色
- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.backImageView.backgroundColor = backColor.CGColor;
}

//设置图片背景透明度
- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    self.backImageView.opacity = alpha;
}

//设置图片
- (void)setBackImage:(UIImage *)backImage {
    _backImage = backImage;
    self.backImageView.contents = (__bridge id)backImage.CGImage;
}

- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine {
    _hiddenBottomLine = hiddenBottomLine;
    self.bottomLine.hidden = hiddenBottomLine;
}

#pragma mark -- 懒加载视图
- (CALayer *)backImageView {
    if (!_backImageView) {
        _backImageView = [CALayer layer];
        _backImageView.masksToBounds = YES;
        _backImageView.contentsGravity = kCAGravityResizeAspectFill;
    }
    return _backImageView;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        [_bottomLine setBackgroundColor:[UIColor grayColor].CGColor];
    }
    return _bottomLine;
}

@end
