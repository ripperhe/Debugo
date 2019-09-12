//
//  DGTouchFingerView.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGTouchFingerView.h"
#import "DGCommon.h"

CGFloat const DGDefaultMaxFingerRadius = 22.0;
CGFloat const DGDefaultForceTouchScale = 1.5;

@interface DGTouchFingerView ()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CATransform3D touchEndTransform;
@property (nonatomic, assign) CGFloat touchEndAnimationDuration;
@property (nonatomic, strong) UITouch *touch;
@property (nonatomic, assign) CGPoint lastScale;

@end

@implementation DGTouchFingerView

- (id)initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (instancetype)initWithPoint:(CGPoint)point {
    if ((self = [super initWithFrame:CGRectMake(point.x - DGDefaultMaxFingerRadius, point.y - DGDefaultMaxFingerRadius, 2 * DGDefaultMaxFingerRadius, 2 * DGDefaultMaxFingerRadius)])) {
        self.opaque = NO;
        self.color = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
        self.backgroundColor = [self.color colorWithAlphaComponent:0.4];
        self.layer.cornerRadius = DGDefaultMaxFingerRadius;
        self.layer.borderWidth = 2.0f;
        self.touchEndAnimationDuration = 0.5f;
        self.lastScale = CGPointMake(1.0, 1.0);
        self.touchEndTransform = CATransform3DMakeScale(1.5, 1.5, 1);
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark - setter

- (void)setBackgroundColor:(UIColor *)color {
    [super setBackgroundColor:color];
    self.layer.borderColor = [color colorWithAlphaComponent:0.6f].CGColor;
}

- (void)updateWithTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.superview];
    self.center = point;
    if (@available(iOS 9.0, *)) {
        CGFloat force = MIN(touch.force, touch.maximumPossibleForce) <= 0 ? 0 : touch.force / touch.maximumPossibleForce;
        self.lastScale = CGPointMake(1 + force * DGDefaultForceTouchScale, 1 + force * DGDefaultForceTouchScale);
        self.transform = CGAffineTransformMakeScale(self.lastScale.x, self.lastScale.y);
        UIColor *forceColor = [self interpolatedColorFromStartColor:self.color endColor:UIColor.redColor fraction:force];
        self.backgroundColor = [forceColor colorWithAlphaComponent:0.4];
    }
}

- (UIColor *)interpolatedColorFromStartColor:(UIColor *)startColor endColor:(UIColor *)endColor fraction:(CGFloat)fraction {
    fraction = MIN(1, MAX(0, fraction));
    if (fraction == 0) return startColor;
    
    const CGFloat *c1 = CGColorGetComponents(startColor.CGColor);
    const CGFloat *c2 = CGColorGetComponents(endColor.CGColor);
    
    CGFloat r = c1[0] + (c2[0] - c1[0]) * fraction;
    CGFloat g = c1[1] + (c2[1] - c1[1]) * fraction;
    CGFloat b = c1[2] + (c2[2] - c1[2]) * fraction;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

- (void)removeFromSuperviewWithAnimation {
    dg_weakify(self)
    [UIView animateWithDuration:self.touchEndAnimationDuration animations:^{
        dg_strongify(self)
        self.alpha = 0.0f;
        self.layer.transform = self.touchEndTransform;
    } completion:^(BOOL finished) {
        dg_strongify(self)
        [self removeFromSuperview];
    }];
}

@end
