//
//  DGLogWindow.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGWindow.h"

@interface DGLogWindow : DGWindow

/// 内容视图
@property (nonatomic, weak, readonly) UIView *contentView;

/// 变大
- (void)growUpHeight;

/// 变小
- (void)growDownHeight;

/// 头部拖拽
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan;

@end


