//
//  DGLogWindow.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGLogWindow.h"
#import "DGCommon.h"
#import "DGLogBackViewController.h"

#define DGLogWindowTopMargin (dg_mainWindow().safeAreaInsets.top + 44.0)
#define DGLogWindowBottomMargin (dg_mainWindow().safeAreaInsets.bottom + 49.0)
#define DGLogWindowMinHeight 100.0
#define DGLogWindowHeightStep 30.0

@interface DGLogWindow()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) CGPoint panStartCenter;
@property (nonatomic, copy) NSString *memoryAddressKey;

@end

@implementation DGLogWindow

- (void)dealloc {
    DGLogFunction;
}

- (instancetype)initWithFrame:(CGRect)frame {
    // update center
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    CGPoint newCenter = [DGLogWindow checkNewCenterWithPoint:center size:frame.size];
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    frame = CGRectMake(newCenter.x - w * 0.5, newCenter.y - h * 0.5, w, h);
    
    if(self = [super initWithFrame:frame]) {
        self.windowLevel = 1000000;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        // rootViewController
        self.rootViewController = [[DGLogBackViewController alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isDragging == NO) {
        // deal rotate
        CGPoint newCenter = [DGLogWindow checkNewCenterWithPoint:self.center size:self.frame.size];
        if (CGPointEqualToPoint(newCenter, self.center) == NO) {
            self.center = newCenter;
        }
    }
}

/// 变大
- (void)growUpHeight {
    [self changeHeightBy:DGLogWindowHeightStep];
}

/// 变小
- (void)growDownHeight {
    [self changeHeightBy:-DGLogWindowHeightStep];
}

- (void)changeHeightBy:(CGFloat)delta {
    CGFloat maxH = UIScreen.mainScreen.bounds.size.height - DGLogWindowTopMargin - DGLogWindowBottomMargin;
    CGFloat height = MAX(DGLogWindowMinHeight, MIN(maxH, self.dg_height + delta));
    CGFloat w = self.frame.size.width;
    CGPoint newCenter = [DGLogWindow checkNewCenterWithPoint:CGPointMake(self.center.x, self.frame.origin.y + height * 0.5) size:CGSizeMake(w, height)];
    [UIView animateWithDuration:.2 animations:^{
        self.frame = CGRectMake(newCenter.x - w * 0.5, newCenter.y - height * 0.5, w, height);
        [self layoutIfNeeded];
    }];
}

#pragma mark - getter
- (UIView *)contentView {
    return self.rootViewController.view;
}

- (NSString *)memoryAddressKey {
    if (!_memoryAddressKey) {
        _memoryAddressKey = [NSString stringWithFormat:@"%@_%p", NSStringFromClass([self class]), self];
    }
    return _memoryAddressKey;
}

#pragma mark - event response
- (void)handlePanGesture:(UIPanGestureRecognizer*)p {
    UIWindow *appWindow = dg_mainWindow();
    // 窗口与屏幕等宽时只允许上下拖动
    BOOL canMoveX = self.frame.size.width < UIScreen.mainScreen.bounds.size.width;
    
    if (p.state == UIGestureRecognizerStateBegan) {
        [self.layer removeAllAnimations];
        self.isDragging = YES;
        self.panStartCenter = self.center;
        self.contentView.alpha = 1;
    } else if (p.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [p translationInView:appWindow];
        CGPoint target = CGPointMake(self.panStartCenter.x + (canMoveX ? translation.x : 0),
                                     self.panStartCenter.y + translation.y);
        self.center = [self rubberBandCenterWithPoint:target];
    } else if (p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        CGPoint velocity = [p velocityInView:appWindow];
        if (!canMoveX) {
            velocity.x = 0;
        }
        // 按松手速度做惯性投射, 再吸附到合法区域
        CGFloat decelerationFactor = 0.15;
        CGPoint projected = CGPointMake(self.center.x + velocity.x * decelerationFactor,
                                        self.center.y + velocity.y * decelerationFactor);
        CGPoint newCenter = [DGLogWindow checkNewCenterWithPoint:projected size:self.frame.size];
        
        CGFloat distance = hypot(newCenter.x - self.center.x, newCenter.y - self.center.y);
        CGFloat speed = hypot(velocity.x, velocity.y);
        CGFloat springVelocity = distance > 1 ? MIN(speed / distance, 20) : 0;
        
        [UIView animateWithDuration:.4
                              delay:0
             usingSpringWithDamping:.85
              initialSpringVelocity:springVelocity
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.center = newCenter;
        } completion:^(BOOL finished) {
            self.isDragging = NO;
        }];
    } else {
        DGLog(@"%@ pan state : %zd", self, p.state);
    }
}

/// 超出可拖动区域时增加阻尼, 避免窗口被拖出屏幕
- (CGPoint)rubberBandCenterWithPoint:(CGPoint)point {
    CGPoint limit = [DGLogWindow checkNewCenterWithPoint:point size:self.frame.size];
    CGFloat overflowY = point.y - limit.y;
    if (fabs(overflowY) < 0.01) {
        return CGPointMake(point.x, point.y);
    }
    CGFloat dimension = 100.0;
    CGFloat resisted = (1.0 - 1.0 / (fabs(overflowY) * 0.55 / dimension + 1.0)) * dimension;
    return CGPointMake(point.x, limit.y + (overflowY > 0 ? resisted : -resisted));
}

#pragma mark - private methods
+ (CGPoint)checkNewCenterWithPoint:(CGPoint)point size:(CGSize)size {
    CGFloat ballWidth = size.width;
    CGFloat ballHeight = size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGFloat left = fabs(point.x);
    CGFloat right = fabs(screenWidth - left);
    
    CGPoint newCenter = CGPointZero;
    CGFloat targetY = 0;
    
    //Correcting Y
    if (point.y < DGLogWindowTopMargin + ballHeight / 2.0) {
        targetY = DGLogWindowTopMargin + ballHeight / 2.0;
    } else if (point.y > (screenHeight - ballHeight / 2.0 - DGLogWindowBottomMargin)) {
        targetY = screenHeight - ballHeight / 2.0 - DGLogWindowBottomMargin;
    } else {
        targetY = point.y;
    }
    
    CGFloat centerXSpace = (0.5 - 0) * ballWidth;
    
    if (left <= right) {
        newCenter = CGPointMake(centerXSpace, targetY);
    } else {
        newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
    }
    
    return newCenter;
}

@end
