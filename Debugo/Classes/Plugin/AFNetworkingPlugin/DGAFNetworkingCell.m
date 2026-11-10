//
//  DGAFNetworkingCell.m
//  Debugo
//

#import "DGAFNetworkingCell.h"
#import "DGAFNetworkingLayout.h"

static UIColor *DGAFNetworkingPurple(void) {
    return [UIColor colorWithRed:108 / 255.0 green:92 / 255.0 blue:231 / 255.0 alpha:1];
}

@interface DGAFNetworkingInsetLabel : UILabel
@end

@implementation DGAFNetworkingInsetLabel

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + 14, 22);
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 7, 0, 7))];
}

@end

@interface DGAFNetworkingCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) DGAFNetworkingInsetLabel *statusLabel;
@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *clipboardButton;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, copy, nullable) NSString *clipboardFeedbackRecordID;
@property (nonatomic, strong) UILabel *uriLabel;
@property (nonatomic, strong) UIView *headersModuleView;
@property (nonatomic, strong) UILabel *headersLabel;
@property (nonatomic, strong) UIView *requestDataModuleView;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIView *responseHeadersModuleView;
@property (nonatomic, strong) UILabel *responseHeadersLabel;
@property (nonatomic, strong) UIView *responseModuleView;
@property (nonatomic, strong) UILabel *responseLabel;

@end

@implementation DGAFNetworkingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
        self.modules = DGAFNetworkingListModuleAll;
    }
    return self;
}

- (void)setupUI {
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 16;
    cardView.layer.masksToBounds = YES;
    [self.contentView addSubview:cardView];
    self.cardView = cardView;
    DGAFNetworkingPinEdges(cardView, self.contentView, UIEdgeInsetsMake(6, 12, 6, 12));

    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor grayColor];
    [cardView addSubview:timeLabel];
    self.timeLabel = timeLabel;

    DGAFNetworkingInsetLabel *statusLabel = [[DGAFNetworkingInsetLabel alloc] init];
    statusLabel.font = [UIFont boldSystemFontOfSize:12];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.layer.cornerRadius = 6;
    statusLabel.layer.masksToBounds = YES;
    [statusLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [statusLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [cardView addSubview:statusLabel];
    self.statusLabel = statusLabel;

    UILabel *methodLabel = [[UILabel alloc] init];
    methodLabel.font = [UIFont boldSystemFontOfSize:15];
    methodLabel.textColor = [UIColor blackColor];
    [methodLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [cardView addSubview:methodLabel];
    self.methodLabel = methodLabel;

    UILabel *durationLabel = [[UILabel alloc] init];
    durationLabel.font = [UIFont systemFontOfSize:13];
    durationLabel.textColor = [UIColor grayColor];
    [cardView addSubview:durationLabel];
    self.durationLabel = durationLabel;

    UIButton *clipboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clipboardButton setTitle:@"复制" forState:UIControlStateNormal];
    [clipboardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clipboardButton.titleLabel.font = [UIFont systemFontOfSize:16];
    clipboardButton.backgroundColor = DGAFNetworkingPurple();
    clipboardButton.layer.cornerRadius = 18;
    clipboardButton.contentEdgeInsets = UIEdgeInsetsMake(8, 18, 8, 18);
    [clipboardButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [clipboardButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [clipboardButton addTarget:self action:@selector(tapCopy) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:clipboardButton];
    self.clipboardButton = clipboardButton;

    self.uriLabel = [self bodyLabelWithLines:3];
    self.headersLabel = [self bodyLabelWithLines:6];
    self.bodyLabel = [self bodyLabelWithLines:8];
    self.responseHeadersLabel = [self bodyLabelWithLines:6];
    self.responseLabel = [self bodyLabelWithLines:10];
    self.headersModuleView = [self moduleViewWithTitle:@"Request headers:" body:self.headersLabel];
    self.requestDataModuleView = [self moduleViewWithTitle:@"Request data:" body:self.bodyLabel];
    self.responseHeadersModuleView = [self moduleViewWithTitle:@"Response headers:" body:self.responseHeadersLabel];
    self.responseModuleView = [self moduleViewWithTitle:@"Response body:" body:self.responseLabel];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.uriLabel,
        self.headersModuleView,
        self.requestDataModuleView,
        self.responseHeadersModuleView,
        self.responseModuleView,
    ]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10;
    stackView.alignment = UIStackViewAlignmentFill;
    [cardView addSubview:stackView];

    DGAFNetworkingDisableAutoresizing(timeLabel);
    DGAFNetworkingDisableAutoresizing(statusLabel);
    DGAFNetworkingDisableAutoresizing(methodLabel);
    DGAFNetworkingDisableAutoresizing(durationLabel);
    DGAFNetworkingDisableAutoresizing(clipboardButton);
    DGAFNetworkingDisableAutoresizing(stackView);

    [NSLayoutConstraint activateConstraints:@[
        DGAFNetworkingConstraint(statusLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, cardView, NSLayoutAttributeTop, 14),
        DGAFNetworkingConstraint(statusLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, cardView, NSLayoutAttributeLeft, 14),

        DGAFNetworkingConstraint(methodLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeRight, 8),
        DGAFNetworkingConstraint(methodLabel, NSLayoutAttributeCenterY, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeCenterY, 0),

        DGAFNetworkingConstraint(durationLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, methodLabel, NSLayoutAttributeRight, 8),
        DGAFNetworkingConstraint(durationLabel, NSLayoutAttributeCenterY, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeCenterY, 0),
        DGAFNetworkingConstraint(clipboardButton, NSLayoutAttributeLeft, NSLayoutRelationGreaterThanOrEqual, durationLabel, NSLayoutAttributeRight, 8),

        DGAFNetworkingConstraint(clipboardButton, NSLayoutAttributeCenterY, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeCenterY, 0),
        DGAFNetworkingConstraint(clipboardButton, NSLayoutAttributeHeight, NSLayoutRelationEqual, nil, NSLayoutAttributeNotAnAttribute, 36),
        DGAFNetworkingConstraint(cardView, NSLayoutAttributeRight, NSLayoutRelationEqual, clipboardButton, NSLayoutAttributeRight, 12),

        DGAFNetworkingConstraint(timeLabel, NSLayoutAttributeTop, NSLayoutRelationGreaterThanOrEqual, statusLabel, NSLayoutAttributeBottom, 8),
        DGAFNetworkingConstraint(timeLabel, NSLayoutAttributeTop, NSLayoutRelationGreaterThanOrEqual, clipboardButton, NSLayoutAttributeBottom, 8),
        DGAFNetworkingConstraint(timeLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, cardView, NSLayoutAttributeLeft, 14),
        DGAFNetworkingConstraint(cardView, NSLayoutAttributeRight, NSLayoutRelationEqual, timeLabel, NSLayoutAttributeRight, 14),

        DGAFNetworkingConstraint(stackView, NSLayoutAttributeTop, NSLayoutRelationEqual, timeLabel, NSLayoutAttributeBottom, 12),
        DGAFNetworkingConstraint(stackView, NSLayoutAttributeLeft, NSLayoutRelationEqual, cardView, NSLayoutAttributeLeft, 14),
        DGAFNetworkingConstraint(cardView, NSLayoutAttributeRight, NSLayoutRelationEqual, stackView, NSLayoutAttributeRight, 14),
        DGAFNetworkingConstraint(cardView, NSLayoutAttributeBottom, NSLayoutRelationEqual, stackView, NSLayoutAttributeBottom, 14),
    ]];
}

- (UIView *)moduleViewWithTitle:(NSString *)title body:(UILabel *)bodyLabel {
    UIView *moduleView = [[UIView alloc] init];
    UILabel *titleLabel = [self titleLabelWithText:title];
    [moduleView addSubview:titleLabel];
    [moduleView addSubview:bodyLabel];
    DGAFNetworkingPinHorizontal(titleLabel, moduleView, 0);
    DGAFNetworkingPinHorizontal(bodyLabel, moduleView, 0);
    [NSLayoutConstraint activateConstraints:@[
        DGAFNetworkingConstraint(titleLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, moduleView, NSLayoutAttributeTop, 0),
        DGAFNetworkingConstraint(bodyLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, titleLabel, NSLayoutAttributeBottom, 4),
        DGAFNetworkingConstraint(moduleView, NSLayoutAttributeBottom, NSLayoutRelationEqual, bodyLabel, NSLayoutAttributeBottom, 0),
    ]];
    return moduleView;
}

- (void)setModules:(DGAFNetworkingListModule)modules {
    _modules = modules;
    self.uriLabel.hidden = (modules & DGAFNetworkingListModuleURI) == 0;
    self.headersModuleView.hidden = (modules & DGAFNetworkingListModuleRequestHeaders) == 0;
    self.requestDataModuleView.hidden = (modules & DGAFNetworkingListModuleRequestData) == 0;
    self.responseHeadersModuleView.hidden = (modules & DGAFNetworkingListModuleResponseHeaders) == 0;
    self.responseModuleView.hidden = (modules & DGAFNetworkingListModuleResponseBody) == 0;
}

- (UILabel *)titleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    return label;
}

- (UILabel *)bodyLabelWithLines:(NSInteger)lines {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = lines;
    label.font = [UIFont fontWithName:@"Menlo" size:12] ?: [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    return label;
}

- (void)setRecord:(DGAFNetworkingRecord *)record {
    _record = record;
    if (!record) {
        return;
    }
    self.timeLabel.text = record.timeText;
    self.statusLabel.text = record.statusText;
    self.statusLabel.backgroundColor = record.statusColor;
    self.methodLabel.text = record.method;
    self.durationLabel.text = record.durationText;

    NSString *uri = record.URLString.length ? record.URLString : @"(空)";
    NSMutableAttributedString *uriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Uri:\n%@", uri]];
    [uriText addAttributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
        NSForegroundColorAttributeName: [UIColor blackColor],
    } range:NSMakeRange(0, 4)];
    [uriText addAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:13],
        NSForegroundColorAttributeName: [UIColor blackColor],
    } range:NSMakeRange(4, uriText.length - 4)];
    self.uriLabel.attributedText = uriText;

    self.headersLabel.text = record.requestHeaders.length ? record.requestHeaders : @"(空)";
    self.bodyLabel.text = record.requestBody.length ? record.requestBody : @"(空)";
    self.responseHeadersLabel.text = record.responseHeaders.length ? record.responseHeaders : (record.isFinished ? @"(空)" : @"请求中…");

    NSString *response = record.responseBody.length ? record.responseBody : (record.isFinished ? @"(空)" : @"请求中…");
    if (record.errorText.length) {
        response = [response stringByAppendingFormat:@"\n\nError:\n%@", record.errorText];
    }
    self.responseLabel.text = response;
    [self resetCopyButtonTitle];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetCopyButtonTitle];
}

- (void)resetCopyButtonTitle {
    self.clipboardFeedbackRecordID = nil;
    [self.clipboardButton setTitle:@"复制" forState:UIControlStateNormal];
}

- (void)tapCopy {
    if (!self.record) {
        return;
    }
    [UIPasteboard generalPasteboard].string = self.record.detailText ?: @"";
    [self.clipboardButton setTitle:@"已复制" forState:UIControlStateNormal];
    NSString *recordID = self.record.recordID ?: @"";
    self.clipboardFeedbackRecordID = recordID;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.clipboardFeedbackRecordID isEqualToString:recordID]) {
            [self resetCopyButtonTitle];
        }
    });
}

@end
