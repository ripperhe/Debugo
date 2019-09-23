//
//  DGDatabaseContentTableViewCell.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseContentTableViewCell.h"

@interface DGDatabaseContentTableViewCell()

@property (nonatomic, strong) NSArray <UIButton *>*buttons;
@property (nonatomic, strong) NSArray <NSNumber *>*columnWidths;

@end

@implementation DGDatabaseContentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.contentView.frame.size.height;
    CGFloat currentLeft = 0;
    for (NSInteger i = 0; i < _buttons.count; i++) {
        CGFloat width = [[self.columnWidths objectAtIndex:i] floatValue];
        UIButton *button = _buttons[i];
        button.frame = CGRectMake(currentLeft, 0, width, height);
        currentLeft += width;
    }
}

- (void)loadContents:(NSArray *)contents columnWidths:(nonnull NSArray<NSNumber *> *)columnWidths {
    self.columnWidths = columnWidths;
    if (contents.count != _buttons.count) {
        for (UIView *v in self.contentView.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                [v removeFromSuperview];
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < contents.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 10000 + i;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
            [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [array addObject:button];
        }
        self.buttons = array;
    }
    for (NSInteger i = 0; i < contents.count; i++) {
        [self.buttons[i] setTitle:contents[i] forState:UIControlStateNormal];
    }
}

- (void)clickButton:(UIButton *)sender {
    if (self.clickButton) {
        self.clickButton(sender, sender.tag - 10000);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = selected?[UIColor colorWithRed:0.96 green:0.89 blue:0.89 alpha:1.00]:UIColor.clearColor;
}

@end
