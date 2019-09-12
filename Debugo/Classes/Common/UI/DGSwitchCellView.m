//
//  DGSwitchCellView.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/12.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGSwitchCellView.h"
#import "DGCommon.h"

@implementation DGSwitchCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [self addSubview:label];
    self.label = label;
    
    UISwitch *switchView = [UISwitch new];
    [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:switchView];
    self.switchView = switchView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label sizeToFit];
    self.label.dg_x = 20;
    self.label.dg_centerY = self.dg_height * 0.5;
    
    [self.switchView sizeToFit];
    self.switchView.dg_right = self.dg_width - 20;
    self.switchView.dg_centerY = self.dg_height * 0.5;
}

- (void)valueChanged:(UISwitch *)switchView {
    if (self.switchValueChangedBlock) {
        self.switchValueChangedBlock(switchView);
    }
}

+ (CGFloat)expectHeight {
    return 60;
}

@end
