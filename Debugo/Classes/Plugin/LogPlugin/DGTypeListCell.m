//
//  DGTypeListCell.m
//  Debugo
//
//  Created by Atlas on 2024/10/9.
//

#import "DGTypeListCell.h"
#import "DGCommon.h"

@interface DGTypeListCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) NSLayoutConstraint *badgeWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bodyTopConstraint;

@end

@implementation DGTypeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *cardView = [[UIView alloc] init];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:cardView];
        self.cardView = cardView;

        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightSemibold];
        badgeLabel.textColor = kDGHighlightColor;
        badgeLabel.backgroundColor = [kDGHighlightColor colorWithAlphaComponent:0.12];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.layer.cornerRadius = 9;
        badgeLabel.clipsToBounds = YES;
        badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [cardView addSubview:badgeLabel];
        self.badgeLabel = badgeLabel;

        UILabel *bodyLabel = [[UILabel alloc] init];
        bodyLabel.font = [UIFont systemFontOfSize:13];
        bodyLabel.textColor = [UIColor colorWithWhite:0.25 alpha:1];
        bodyLabel.numberOfLines = 0;
        bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [bodyLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [bodyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [cardView addSubview:bodyLabel];
        self.bodyLabel = bodyLabel;

        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [cardView addSubview:separator];
        [NSLayoutConstraint activateConstraints:@[
            [separator.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:16],
            [separator.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor],
            [separator.bottomAnchor constraintEqualToAnchor:cardView.bottomAnchor],
            [separator.heightAnchor constraintEqualToConstant:0.5],
        ]];

        self.badgeWidthConstraint = [badgeLabel.widthAnchor constraintEqualToConstant:36];
        self.bodyTopConstraint = [bodyLabel.topAnchor constraintEqualToAnchor:badgeLabel.bottomAnchor constant:6];
        [NSLayoutConstraint activateConstraints:@[
            [cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],

            [badgeLabel.topAnchor constraintEqualToAnchor:cardView.topAnchor constant:10],
            [badgeLabel.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:12],
            [badgeLabel.heightAnchor constraintEqualToConstant:18],
            self.badgeWidthConstraint,

            self.bodyTopConstraint,
            [bodyLabel.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:12],
            [bodyLabel.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-12],
            [bodyLabel.bottomAnchor constraintEqualToAnchor:cardView.bottomAnchor constant:-10],
        ]];
    }
    return self;
}

- (void)setLogTypeModel:(DGLogTypeModel *)logTypeModel {
    _logTypeModel = logTypeModel;
    self.badgeLabel.text = [NSString stringWithFormat:@"#%d", logTypeModel.typeID];
    CGSize badgeSize = [self.badgeLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 18)];
    self.badgeWidthConstraint.constant = MAX(28, badgeSize.width + 12);

    NSString *detail = logTypeModel.dg_dic.count ? logTypeModel.dg_dic.description : @"";
    self.bodyLabel.text = detail;
    self.bodyTopConstraint.constant = detail.length > 0 ? 6 : 0;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    UIColor *color = highlighted ? [UIColor colorWithWhite:0.97 alpha:1] : [UIColor whiteColor];
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            self.cardView.backgroundColor = color;
        }];
    } else {
        self.cardView.backgroundColor = color;
    }
}

@end
