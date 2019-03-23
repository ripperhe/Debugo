//
//  DGDatabaseContentTableViewCell.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseContentTableViewCell.h"

@interface DGDatabaseContentTableViewCell()

@property (nonatomic, strong) NSArray <UILabel *>*labels;
@property (nonatomic, strong) NSArray <NSNumber *>*columnWidths;

@end

@implementation DGDatabaseContentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labels = [NSArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelHeight = self.contentView.frame.size.height;
    CGFloat currentLeft = 0;
    for (NSInteger i = 0; i < _labels.count; i++) {
        CGFloat labelWidth = [[self.columnWidths objectAtIndex:i] floatValue];
        UILabel *label = _labels[i];
        label.frame = CGRectMake(currentLeft + 5, 0, (labelWidth - 10), labelHeight);
        currentLeft += labelWidth;
    }
}

- (void)loadContents:(NSArray *)contents columnWidths:(nonnull NSArray<NSNumber *> *)columnWidths {
    self.columnWidths = columnWidths;
    if (contents.count != _labels.count) {
        for (UIView *label in self.contentView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                [label removeFromSuperview];
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < contents.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
            label.font = [UIFont systemFontOfSize:14];
            label.userInteractionEnabled = YES;
            label.tag = 10000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
            [label addGestureRecognizer:tap];
            [self.contentView addSubview:label];
            [array addObject:label];
        }
        self.labels = array;
    }
    for (NSInteger i = 0; i < contents.count; i++) {
        self.labels[i].text = contents[i];
    }
}

- (void)tapLabelAction:(UITapGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    if (self.clickLabel) {
        self.clickLabel(label, label.tag - 10000);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = selected?[UIColor colorWithRed:0.96 green:0.89 blue:0.89 alpha:1.00]:UIColor.clearColor;
}

@end
