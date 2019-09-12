//
//  DGSwitchCellView.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/12.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGSwitchCellView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, copy) void(^switchValueChangedBlock)(UISwitch *switchView);

+ (CGFloat)expectHeight;

@end

NS_ASSUME_NONNULL_END
