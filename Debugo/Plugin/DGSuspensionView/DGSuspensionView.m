//
//  DGSuspensionView.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGSuspensionView.h"

#define kIsIPhoneX ([[UIScreen mainScreen] nativeBounds].size.height >= 2436.0)
#define kTopMargin (kIsIPhoneX ? 88.0 : 64.0)
#define kBottomMargin (kIsIPhoneX ? 83.0 : 49.0)
#define kHiddenProportion 0.14545455

@interface DGSuspensionView()

@property (nonatomic, strong) DGSuspensionViewConfig *config;

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIButton *button;

@property (nonatomic, assign) BOOL isDragging;

@end

@implementation DGSuspensionView

//+ (void)initialize {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//#if DGSuspensionViewCanBeEnabled
//        printf("◦ DGSuspensionViewCanBeEnabled ✅\n");
//#else
//        printf("◦ DGSuspensionViewCanBeEnabled ❌\n");
//#endif
//    });
//}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

+ (instancetype)defaultSuspensionView {
    return [self suspensionViewWithFrame:CGRectMake(0, 100, 55, 55) config:nil];
}

+ (instancetype)suspensionViewWithFrame:(CGRect)frame config:(DGSuspensionViewConfig *)config {
    return [[self alloc] initWithFrame:frame config:config];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame config:nil];
}

- (instancetype)initWithFrame:(CGRect)frame config:(DGSuspensionViewConfig *)config {
    // check w、h
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (frame.size.width >= bounds.size.width || frame.size.height >= bounds.size.height) {
        NSAssert(0, @"DGSuspensionView: 传入的 frame 值不对!");
        return nil;
    }
    
    // update center
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    CGPoint newCenter = [DGSuspensionView checkNewCenterWithPoint:center size:frame.size];
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    frame = CGRectMake(newCenter.x - w * 0.5, newCenter.y - h * 0.5, w, h);
    
    // config
    if (!config) {
        config = [DGSuspensionViewConfig defaultConfig];
    }

    if(self = [super initWithFrame:frame])
    {
        self.config = config;
        
        // rootViewController
        self.rootViewController = [[DGSuspensionViewController alloc] init];
        self.contentView.alpha = self.config.leanStateAlpha;
        // button
        [self setupBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isDragging == NO) {
        // deal rotate
        CGPoint newCenter = [DGSuspensionView checkNewCenterWithPoint:self.center size:self.frame.size];
        if (CGPointEqualToPoint(newCenter, self.center) == NO) {
            self.center = newCenter;
        }
    }
}

- (void)setupBtn {
    UIButton *button = [UIButton buttonWithType:self.config.buttonType];
    button.userInteractionEnabled = YES;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.clipsToBounds = YES;
    button.backgroundColor = [UIColor colorWithRed:0.21f green:0.45f blue:0.88f alpha:1.00f];
    
    // click
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    // pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    pan.delaysTouchesBegan = YES;
    [button addGestureRecognizer:pan];
    
    // long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [button addGestureRecognizer:longPress];
    
    [self.contentView addSubview:button];
    self.button = button;
    
    [self setFrame:self.frame];
}

#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_button) {
        // setCenter 不会调用该方法，放在 layoutSubviews 拖动的时候会一直调用
        CGRect btnFrame = self.bounds;
        _button.frame = btnFrame;
        _button.layer.cornerRadius = btnFrame.size.width <= btnFrame.size.height ? btnFrame.size.width / 2.0 : btnFrame.size.height / 2.0;
    }
}

#pragma mark - getter
- (UIView *)contentView {
    return self.rootViewController.view;
}

- (NSString *)memoryAddressKey {
    return [NSString stringWithFormat:@"%p", self];
}

#pragma mark - event response
- (void)handlePanGesture:(UIPanGestureRecognizer*)p {
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    
    if(p.state == UIGestureRecognizerStateBegan) {
        self.isDragging = YES;
//        NSLog(@"%@ pan began %@", self, NSStringFromCGPoint(panPoint));
        self.contentView.alpha = 1;
        if ([self.dg_delegate respondsToSelector:(@selector(suspensionViewPanStart:))]) {
            [self.dg_delegate suspensionViewPanStart:self];
        }
    }else if(p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
//        NSLog(@"%@ pan end %@", self, NSStringFromCGPoint(panPoint));
        self.contentView.alpha = self.config.leanStateAlpha;
        CGPoint newCenter = [DGSuspensionView checkNewCenterWithPoint:panPoint size:self.frame.size];
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        } completion:^(BOOL finished) {
            self.isDragging = NO;
        }];
        if ([self.dg_delegate respondsToSelector:@selector(suspensionViewPanEnd:)]) {
            [self.dg_delegate suspensionViewPanEnd:self];
        }
    }else{
        NSLog(@"%@ pan state : %zd", self, p.state);
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)l {
    if (l.state == UIGestureRecognizerStateBegan) {
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [feedBackGenertor impactOccurred];
        }
        if (self.config.showLongPressAnimation) {
            CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            bounceAnimation.fromValue = @1.0;
            bounceAnimation.toValue = @1.2;
            bounceAnimation.duration = .25;
            bounceAnimation.removedOnCompletion = NO;
            bounceAnimation.fillMode = kCAFillModeForwards;
            [self.layer addAnimation:bounceAnimation forKey:@"longPressBigger"];
        }
        if ([self.dg_delegate respondsToSelector:@selector(suspensionViewLongPressStart:)]) {
            [self.dg_delegate suspensionViewLongPressStart:self];
        }
    }else if (l.state == UIGestureRecognizerStateEnded || l.state == UIGestureRecognizerStateCancelled){
        if (self.config.showLongPressAnimation) {
            [self.layer removeAnimationForKey:@"longPressBigger"];
            
            CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            bounceAnimation.fromValue = @1.2;
            bounceAnimation.toValue = @1.0;
            bounceAnimation.duration = .25;
            bounceAnimation.removedOnCompletion = YES;
            [self.layer addAnimation:bounceAnimation forKey:@"sss"];
        }
        if ([self.dg_delegate respondsToSelector:@selector(suspensionViewLongPressEnd:)]) {
            [self.dg_delegate suspensionViewLongPressEnd:self];
        }
    }
}

- (void)click {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }

    if (self.config.showClickAnimation) {
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.9],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:0.9],
                                  [NSNumber numberWithFloat:1.0], nil];
        bounceAnimation.duration = .25;
        bounceAnimation.removedOnCompletion = YES;
        [self.layer addAnimation:bounceAnimation forKey:nil];
    }

    if([self.dg_delegate respondsToSelector:@selector(suspensionViewClick:)]) {
        [self.dg_delegate suspensionViewClick:self];
    }
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
    if (point.y < kTopMargin + ballHeight / 2.0) {
        targetY = kTopMargin + ballHeight / 2.0;
    }else if (point.y > (screenHeight - ballHeight / 2.0 - kBottomMargin)) {
        targetY = screenHeight - ballHeight / 2.0 - kBottomMargin;
    }else{
        targetY = point.y;
    }
    
    CGFloat centerXSpace = (0.5 - kHiddenProportion) * ballWidth;
    
    if (left <= right) {
        newCenter = CGPointMake(centerXSpace, targetY);
    }else {
        newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
    }
    
    return newCenter;
}

#pragma mark - public methods
- (void)show {
    if ([DGSuspensionManager.shared windowForKey:self.memoryAddressKey]) return;

    [self setHidden:NO];
    [DGSuspensionManager.shared saveWindow:self forKey:self.memoryAddressKey];
}

- (void)removeFromScreen {
    [DGSuspensionManager.shared destroyWindowForKey:self.memoryAddressKey];
}

@end
