//
//  DGTouchFingerView.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


@import UIKit;

/*!
 *  Represents a single view on screen.
 */
@interface DGTouchFingerView : UIView

- (id)initWithPoint:(CGPoint)point;
- (void)updateWithTouch:(UITouch *)touch;
- (void)removeFromSuperviewWithAnimation;

@end
