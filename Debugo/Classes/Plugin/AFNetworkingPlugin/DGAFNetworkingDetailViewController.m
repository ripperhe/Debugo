//
//  DGAFNetworkingDetailViewController.m
//  Debugo
//

#import "DGAFNetworkingDetailViewController.h"
#import "DGAFNetworkingCenter.h"
#import "DGAFNetworkingLayout.h"
#import "DGTool.h"

@interface DGAFNetworkingDetailInsetLabel : UILabel
@end

@implementation DGAFNetworkingDetailInsetLabel

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + 14, 22);
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 7, 0, 7))];
}

@end

@interface DGAFNetworkingDetailViewController ()

@property (nonatomic, strong) DGAFNetworkingRecord *record;
@property (nonatomic, strong) DGAFNetworkingDetailInsetLabel *statusLabel;
@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *uriLabel;
@property (nonatomic, strong) UILabel *headersLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UILabel *responseHeadersLabel;
@property (nonatomic, strong) UILabel *responseLabel;

@end

@implementation DGAFNetworkingDetailViewController

- (instancetype)initWithRecord:(DGAFNetworkingRecord *)record {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _record = record;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDGBackgroundColor;
    self.navigationItem.title = @"请求详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复制" style:UIBarButtonItemStylePlain target:self action:@selector(copyText)];
    [self setupUI];
    [self reloadContent];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContent) name:DGAFNetworkingRecordsDidChangeNotification object:nil];
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    DGAFNetworkingPinEdges(scrollView, self.view, UIEdgeInsetsZero);

    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    DGAFNetworkingPinEdges(contentView, scrollView, UIEdgeInsetsZero);
    [NSLayoutConstraint activateConstraints:@[
        DGAFNetworkingConstraint(contentView, NSLayoutAttributeWidth, NSLayoutRelationEqual, scrollView, NSLayoutAttributeWidth, 0),
    ]];

    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 16;
    cardView.layer.masksToBounds = YES;
    [contentView addSubview:cardView];
    DGAFNetworkingPinEdges(cardView, contentView, UIEdgeInsetsMake(6, 12, 12, 12));

    DGAFNetworkingDetailInsetLabel *statusLabel = [[DGAFNetworkingDetailInsetLabel alloc] init];
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

    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor grayColor];
    [cardView addSubview:timeLabel];
    self.timeLabel = timeLabel;

    self.uriLabel = [self makeBodyLabel];
    UILabel *headersTitleLabel = [self titleLabelWithText:@"Request headers:"];
    self.headersLabel = [self makeBodyLabel];
    UILabel *bodyTitleLabel = [self titleLabelWithText:@"Request data:"];
    self.bodyLabel = [self makeBodyLabel];
    UILabel *responseHeadersTitleLabel = [self titleLabelWithText:@"Response headers:"];
    self.responseHeadersLabel = [self makeBodyLabel];
    UILabel *responseTitleLabel = [self titleLabelWithText:@"Response body:"];
    self.responseLabel = [self makeBodyLabel];

    NSArray<UILabel *> *labels = @[
        self.uriLabel,
        headersTitleLabel,
        self.headersLabel,
        bodyTitleLabel,
        self.bodyLabel,
        responseHeadersTitleLabel,
        self.responseHeadersLabel,
        responseTitleLabel,
        self.responseLabel,
    ];
    for (UILabel *label in labels) {
        [cardView addSubview:label];
        DGAFNetworkingPinHorizontal(label, cardView, 14);
    }

    DGAFNetworkingDisableAutoresizing(statusLabel);
    DGAFNetworkingDisableAutoresizing(methodLabel);
    DGAFNetworkingDisableAutoresizing(durationLabel);
    DGAFNetworkingDisableAutoresizing(timeLabel);

    [NSLayoutConstraint activateConstraints:@[
        DGAFNetworkingConstraint(statusLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, cardView, NSLayoutAttributeTop, 14),
        DGAFNetworkingConstraint(statusLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, cardView, NSLayoutAttributeLeft, 14),

        DGAFNetworkingConstraint(methodLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeRight, 8),
        DGAFNetworkingConstraint(methodLabel, NSLayoutAttributeCenterY, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeCenterY, 0),

        DGAFNetworkingConstraint(durationLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, methodLabel, NSLayoutAttributeRight, 8),
        DGAFNetworkingConstraint(durationLabel, NSLayoutAttributeCenterY, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeCenterY, 0),
        DGAFNetworkingConstraint(cardView, NSLayoutAttributeRight, NSLayoutRelationGreaterThanOrEqual, durationLabel, NSLayoutAttributeRight, 14),

        DGAFNetworkingConstraint(timeLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, statusLabel, NSLayoutAttributeBottom, 8),
        DGAFNetworkingConstraint(timeLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, cardView, NSLayoutAttributeLeft, 14),
        DGAFNetworkingConstraint(cardView, NSLayoutAttributeRight, NSLayoutRelationEqual, timeLabel, NSLayoutAttributeRight, 14),

        DGAFNetworkingConstraint(self.uriLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, timeLabel, NSLayoutAttributeBottom, 12),
        DGAFNetworkingConstraint(headersTitleLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, self.uriLabel, NSLayoutAttributeBottom, 10),
        DGAFNetworkingConstraint(self.headersLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, headersTitleLabel, NSLayoutAttributeBottom, 4),
        DGAFNetworkingConstraint(bodyTitleLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, self.headersLabel, NSLayoutAttributeBottom, 10),
        DGAFNetworkingConstraint(self.bodyLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, bodyTitleLabel, NSLayoutAttributeBottom, 4),
        DGAFNetworkingConstraint(responseHeadersTitleLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, self.bodyLabel, NSLayoutAttributeBottom, 10),
        DGAFNetworkingConstraint(self.responseHeadersLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, responseHeadersTitleLabel, NSLayoutAttributeBottom, 4),
        DGAFNetworkingConstraint(responseTitleLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, self.responseHeadersLabel, NSLayoutAttributeBottom, 10),
        DGAFNetworkingConstraint(self.responseLabel, NSLayoutAttributeTop, NSLayoutRelationEqual, responseTitleLabel, NSLayoutAttributeBottom, 4),
        DGAFNetworkingConstraint(cardView, NSLayoutAttributeBottom, NSLayoutRelationEqual, self.responseLabel, NSLayoutAttributeBottom, 14),
    ]];
}

- (UILabel *)titleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    return label;
}

- (UILabel *)makeBodyLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Menlo" size:12] ?: [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    return label;
}

- (void)reloadContent {
    DGAFNetworkingRecord *record = self.record;
    if (!record) {
        return;
    }
    self.statusLabel.text = record.statusText;
    self.statusLabel.backgroundColor = record.statusColor;
    self.methodLabel.text = record.method;
    self.durationLabel.text = record.durationText;
    self.timeLabel.text = record.timeText;

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
}

- (void)copyText {
    [UIPasteboard generalPasteboard].string = self.record.detailText ?: @"";
    self.navigationItem.rightBarButtonItem.title = @"已复制";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.title = @"复制";
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
