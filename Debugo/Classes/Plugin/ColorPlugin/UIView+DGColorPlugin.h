//
//  UIView+DGColorPlugin.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/26.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DGRenderType) {
    /// 不渲染
    DGRenderTypeNone,
    /// 渲染子视图
    DGRenderTypeLeaves,
    /// 渲染自己和子视图
    DGRenderTypeContainerAndLeaves,
};

typedef NS_ENUM(NSUInteger, DGColorType) {
    /// 随机色
    DGColorTypeRandomColor,
    /// 半透明随机色
    DGColorTypeRandomColorWithAlpha,
    /// 半透明红色
    DGColorTypeRedColorWithAlpha,
};

@interface UIView (DGColorPlugin)

/// 背景色渲染规则
@property (nonatomic, assign) DGRenderType dg_renderType;
/// 背景色类型
@property (nonatomic, assign) DGColorType dg_colorType;
/// 标记一个view是否渲染过
@property (nonatomic, assign, readonly) BOOL dg_hasBeenRendered;
/// 标记一个view是否已经被添加了debug背景色，外部一般不使用
@property (nonatomic, assign, readonly) BOOL dg_hasDebugColor;
/// 视图原始色，外部一般不使用
@property (nonatomic, strong, readonly, nullable) UIColor *dg_originalColor;

@end

NS_ASSUME_NONNULL_END
