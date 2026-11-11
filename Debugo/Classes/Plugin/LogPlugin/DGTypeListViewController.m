//
//  DGTypeListViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGTypeListViewController.h"
#import "DGLogPlugin.h"
#import "DGTypeListCell.h"

static CGFloat const kDGLogGrabberHeight = 14.0;
static CGFloat const kDGLogTitleHeight = 40.0;
static CGFloat const kDGLogToolbarBottom = 6.0;
static CGFloat const kDGLogIconSide = 32.0;
static CGFloat const kDGLogFooterButtonRow = 52.0;
static CGFloat const kDGLogFilterHeight = 42.0;

static UIButton *DGLogMakeIconButton(NSString *symbol, NSString *fallback, NSString *accessibility, BOOL filled) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.accessibilityLabel = accessibility;
    button.layer.cornerRadius = kDGLogIconSide * 0.5;
    UIImage *image = nil;
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:14 weight:UIImageSymbolWeightSemibold];
        image = [[UIImage systemImageNamed:symbol withConfiguration:configuration] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setTitle:fallback forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    }
    if (filled) {
        button.backgroundColor = [UIColor colorWithRed:1 green:0.23 blue:0.19 alpha:0.1];
        button.tintColor = [UIColor colorWithRed:0.92 green:0.22 blue:0.18 alpha:1];
    } else {
        button.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        button.tintColor = [UIColor colorWithWhite:0.22 alpha:1];
    }
    [button setTitleColor:button.tintColor forState:UIControlStateNormal];
    return button;
}

static void DGLogAttachDrag(UIView *view, id target, SEL action) {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    pan.maximumNumberOfTouches = 1;
    pan.cancelsTouchesInView = YES;
    [view addGestureRecognizer:pan];
}

static void DGLogHandleDrag(UIView *view, UIPanGestureRecognizer *pan) {
    if ([view.window isKindOfClass:[DGLogWindow class]]) {
        [(DGLogWindow *)view.window handlePanGesture:pan];
    }
}

#pragma mark - Toolbar

@interface DGLogToolbar : UIView

@property (nonatomic, copy) void (^growHandler)(void);
@property (nonatomic, copy) void (^shrinkHandler)(void);
@property (nonatomic, copy) void (^closeHandler)(void);

- (CGFloat)preferredHeight;
- (void)updateCountWithTotal:(NSInteger)total matched:(NSInteger)matched filtering:(BOOL)filtering;

@end

@interface DGLogToolbar ()

@property (nonatomic, strong) UIView *grabber;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *sizeControl;
@property (nonatomic, strong) UIButton *growButton;
@property (nonatomic, strong) UIButton *shrinkButton;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation DGLogToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _grabber = [[UIView alloc] init];
        _grabber.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1];
        _grabber.layer.cornerRadius = 2;
        [self addSubview:_grabber];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"日志";
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];

        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.layer.cornerRadius = 9;
        _countLabel.clipsToBounds = YES;
        [self addSubview:_countLabel];

        _sizeControl = [[UIView alloc] init];
        _sizeControl.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _sizeControl.layer.cornerRadius = 16;
        [self addSubview:_sizeControl];

        UIView *sizeDivider = [[UIView alloc] init];
        sizeDivider.backgroundColor = [UIColor colorWithWhite:0.84 alpha:1];
        sizeDivider.tag = 71;
        [_sizeControl addSubview:sizeDivider];

        _growButton = DGLogMakeIconButton(@"plus", @"大", @"放大", NO);
        _shrinkButton = DGLogMakeIconButton(@"minus", @"小", @"缩小", NO);
        _growButton.backgroundColor = [UIColor clearColor];
        _shrinkButton.backgroundColor = [UIColor clearColor];
        [_sizeControl addSubview:_growButton];
        [_sizeControl addSubview:_shrinkButton];

        _closeButton = DGLogMakeIconButton(@"xmark", @"关", @"关闭", YES);
        [self addSubview:_closeButton];
        [_growButton addTarget:self action:@selector(growTapped) forControlEvents:UIControlEventTouchUpInside];
        [_shrinkButton addTarget:self action:@selector(shrinkTapped) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];

        DGLogAttachDrag(self, self, @selector(handleHeaderPan:));
        DGLogAttachDrag(_closeButton, self, @selector(handleHeaderPan:));
        DGLogAttachDrag(_growButton, self, @selector(handleHeaderPan:));
        DGLogAttachDrag(_shrinkButton, self, @selector(handleHeaderPan:));
        DGLogAttachDrag(_sizeControl, self, @selector(handleHeaderPan:));

        [self updateCountWithTotal:0 matched:0 filtering:NO];
    }
    return self;
}

- (CGFloat)preferredHeight {
    return kDGLogGrabberHeight + kDGLogTitleHeight + kDGLogToolbarBottom;
}

- (void)updateCountWithTotal:(NSInteger)total matched:(NSInteger)matched filtering:(BOOL)filtering {
    if (filtering) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)matched, (long)total];
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)total];
    }
    self.countLabel.textColor = kDGHighlightColor;
    self.countLabel.backgroundColor = [kDGHighlightColor colorWithAlphaComponent:0.12];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = self.bounds.size.width;
    self.grabber.frame = CGRectMake((width - 32) * 0.5, 5, 32, 4);

    CGFloat titleY = kDGLogGrabberHeight;
    CGFloat actionY = titleY + (kDGLogTitleHeight - kDGLogIconSide) * 0.5;
    self.closeButton.frame = CGRectMake(16, actionY, kDGLogIconSide, kDGLogIconSide);
    self.sizeControl.frame = CGRectMake(width - 16 - 76, actionY, 76, kDGLogIconSide);
    self.growButton.frame = CGRectMake(0, 0, 38, kDGLogIconSide);
    self.shrinkButton.frame = CGRectMake(38, 0, 38, kDGLogIconSide);
    UIView *sizeDivider = [self.sizeControl viewWithTag:71];
    sizeDivider.frame = CGRectMake(37.5, 9, 1, 14);

    [self.titleLabel sizeToFit];
    CGFloat titleWidth = self.titleLabel.bounds.size.width;
    self.titleLabel.frame = CGRectMake((width - titleWidth) * 0.5, titleY, titleWidth, kDGLogTitleHeight);

    CGSize countSize = [self.countLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 18)];
    CGFloat countWidth = MAX(22, countSize.width + 12);
    CGFloat countY = titleY + (kDGLogTitleHeight - 18) * 0.5;
    self.countLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 8, countY, countWidth, 18);
}

- (void)growTapped {
    if (self.growHandler) self.growHandler();
}

- (void)shrinkTapped {
    if (self.shrinkHandler) self.shrinkHandler();
}

- (void)closeTapped {
    if (self.closeHandler) self.closeHandler();
}

- (void)handleHeaderPan:(UIPanGestureRecognizer *)pan {
    DGLogHandleDrag(self, pan);
}

@end

#pragma mark - Footer

@interface DGLogFooter : UIView <UITextFieldDelegate>

@property (nonatomic, copy) void (^clearHandler)(void);
@property (nonatomic, copy) void (^filterTextHandler)(NSString *text);
@property (nonatomic, copy) void (^filterEditingHandler)(BOOL editing);
@property (nonatomic, copy) void (^heightChangedHandler)(void);

- (CGFloat)preferredHeight;

@end

@interface DGLogFooter ()

@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UITextField *filterField;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, assign) BOOL filterVisible;

@end

@implementation DGLogFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:_separator];

        _clearButton = DGLogMakeIconButton(@"trash", @"清", @"清空", YES);
        _filterButton = DGLogMakeIconButton(@"line.3.horizontal.decrease", @"滤", @"过滤", NO);
        [self addSubview:_clearButton];
        [self addSubview:_filterButton];
        [_clearButton addTarget:self action:@selector(clearTapped) forControlEvents:UIControlEventTouchUpInside];
        [_filterButton addTarget:self action:@selector(filterTapped) forControlEvents:UIControlEventTouchUpInside];

        _filterField = [[UITextField alloc] init];
        _filterField.hidden = YES;
        _filterField.delegate = self;
        _filterField.font = [UIFont systemFontOfSize:14];
        _filterField.textColor = [UIColor colorWithWhite:0.12 alpha:1];
        _filterField.tintColor = kDGHighlightColor;
        _filterField.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        _filterField.layer.cornerRadius = 10;
        _filterField.placeholder = @"过滤类型或内容";
        _filterField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _filterField.returnKeyType = UIReturnKeyDone;
        _filterField.autocorrectionType = UITextAutocorrectionTypeNo;
        _filterField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _filterField.leftView = [self filterLeftView];
        _filterField.leftViewMode = UITextFieldViewModeAlways;
        [_filterField addTarget:self action:@selector(filterTextChanged) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_filterField];
        [self updateFilterButtonStyle];

        DGLogAttachDrag(self, self, @selector(handleFooterPan:));
        DGLogAttachDrag(_clearButton, self, @selector(handleFooterPan:));
        DGLogAttachDrag(_filterButton, self, @selector(handleFooterPan:));
    }
    return self;
}

- (UIView *)filterLeftView {
    UIImage *image = nil;
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:13 weight:UIImageSymbolWeightMedium];
        image = [[UIImage systemImageNamed:@"magnifyingglass" withConfiguration:configuration] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    if (!image) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 34)];
    }
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 34)];
    UIImageView *icon = [[UIImageView alloc] initWithImage:image];
    icon.tintColor = [UIColor colorWithWhite:0.55 alpha:1];
    icon.contentMode = UIViewContentModeCenter;
    icon.frame = container.bounds;
    [container addSubview:icon];
    return container;
}

- (CGFloat)preferredHeight {
    CGFloat height = kDGLogFooterButtonRow;
    if (self.filterVisible) {
        height += kDGLogFilterHeight;
    }
    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.separator.frame = CGRectMake(0, 0, width, 0.5);

    CGFloat buttonY = height - 10 - kDGLogIconSide;
    CGFloat left = 16;
    self.clearButton.frame = CGRectMake(left, buttonY, kDGLogIconSide, kDGLogIconSide);
    self.filterButton.frame = CGRectMake(left + kDGLogIconSide + 12, buttonY, kDGLogIconSide, kDGLogIconSide);
    self.filterField.frame = CGRectMake(16, 10, width - 32, 34);
}

- (void)clearTapped {
    if (self.clearHandler) self.clearHandler();
}

- (void)handleFooterPan:(UIPanGestureRecognizer *)pan {
    DGLogHandleDrag(self, pan);
}

- (void)filterTapped {
    self.filterVisible = !self.filterVisible;
    self.filterField.hidden = !self.filterVisible;
    [self updateFilterButtonStyle];
    if (self.filterEditingHandler) {
        self.filterEditingHandler(self.filterVisible);
    }
    if (self.filterVisible) {
        [self.filterField becomeFirstResponder];
    } else {
        self.filterField.text = nil;
        [self.filterField resignFirstResponder];
        if (self.filterTextHandler) self.filterTextHandler(@"");
    }
    if (self.heightChangedHandler) self.heightChangedHandler();
}

- (void)filterTextChanged {
    if (self.filterTextHandler) {
        self.filterTextHandler(self.filterField.text ?: @"");
    }
}

- (void)updateFilterButtonStyle {
    if (self.filterVisible) {
        self.filterButton.backgroundColor = kDGHighlightColor;
        self.filterButton.tintColor = [UIColor whiteColor];
        [self.filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.filterButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.filterButton.tintColor = [UIColor colorWithWhite:0.22 alpha:1];
        [self.filterButton setTitleColor:self.filterButton.tintColor forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

#pragma mark - List

@interface DGTypeListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DGLogToolbar *toolbar;
@property (nonatomic, strong) DGLogFooter *footer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) NSMutableArray<DGLogTypeModel *> *dataArray;
@property (nonatomic, copy) NSArray<DGLogTypeModel *> *visibleArray;
@property (nonatomic, copy) NSString *keyword;

@end

@implementation DGTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.keyword = @"";

    DGLogToolbar *toolbar = [[DGLogToolbar alloc] init];
    dg_weakify(self)
    toolbar.growHandler = ^{
        dg_strongify(self)
        [self growUp];
    };
    toolbar.shrinkHandler = ^{
        dg_strongify(self)
        [self growDown];
    };
    toolbar.closeHandler = ^{
        dg_strongify(self)
        [self close];
    };
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;

    DGLogFooter *footer = [[DGLogFooter alloc] init];
    footer.clearHandler = ^{
        dg_strongify(self)
        [self clear];
    };
    footer.filterTextHandler = ^(NSString *text) {
        dg_strongify(self)
        self.keyword = text ?: @"";
        [self reloadListScrollingToBottom:NO];
    };
    footer.filterEditingHandler = ^(BOOL editing) {
        dg_strongify(self)
        [self setFilterEditing:editing];
    };
    footer.heightChangedHandler = ^{
        dg_strongify(self)
        [UIView animateWithDuration:0.22 animations:^{
            [self layoutContent];
        }];
    };
    [self.view addSubview:footer];
    self.footer = footer;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 64;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(4, 0, 12, 0);
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:tableView];
    self.tableView = tableView;

    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont systemFontOfSize:14];
    emptyLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    emptyLabel.numberOfLines = 0;
    [self.view addSubview:emptyLabel];
    self.emptyLabel = emptyLabel;
    [self.view bringSubviewToFront:self.footer];

    [self addNoti];
    [self reloadListScrollingToBottom:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutContent];
}

- (void)layoutContent {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGFloat toolbarHeight = [self.toolbar preferredHeight];
    CGFloat footerHeight = [self.footer preferredHeight];
    self.toolbar.frame = CGRectMake(0, 0, width, toolbarHeight);
    self.footer.frame = CGRectMake(0, height - footerHeight, width, footerHeight);
    self.tableView.frame = CGRectMake(0, toolbarHeight, width, MAX(0, height - toolbarHeight - footerHeight));
    self.emptyLabel.frame = self.tableView.frame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setFilterEditing:NO];
}

#pragma mark - Actions

- (void)growUp {
    [DGLogPlugin.shared.logWindow growUpHeight];
}

- (void)growDown {
    [DGLogPlugin.shared.logWindow growDownHeight];
}

- (void)clear {
    [DGLogPlugin.shared.arrayM removeAllObjects];
    [self.dataArray removeAllObjects];
    [self reloadListScrollingToBottom:NO];
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

- (void)close {
    [self setFilterEditing:NO];
    [DGLogPlugin setPluginSwitch:NO];
}

/// 日志窗口默认不能成为 keyWindow, 过滤输入时临时打开, 结束后交回主窗口
- (void)setFilterEditing:(BOOL)editing {
    DGLogWindow *window = DGLogPlugin.shared.logWindow;
    if (!window) {
        return;
    }
    window.dg_canBecomeKeyWindow = editing;
    if (editing) {
        [window makeKeyWindow];
    } else if (window.isKeyWindow) {
        [dg_mainWindow() makeKeyWindow];
    }
}

- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDebugoLogWindowNoti:) name:DebugoLogWindowNotification object:nil];
}

- (void)receiveDebugoLogWindowNoti:(NSNotification *)noti {
    if ([NSThread isMainThread]) {
        [self reloadDataInMainThreadWithNoti:noti];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadDataInMainThreadWithNoti:noti];
        });
    }
}

- (void)reloadDataInMainThreadWithNoti:(NSNotification *)noti {
    DGLogTypeModel *typeModel = noti.userInfo[@"typeModel"];
    if (!typeModel) {
        return;
    }
    [self.dataArray addObject:typeModel];
    [self reloadListScrollingToBottom:self.keyword.length == 0];
}

#pragma mark - Data

- (NSMutableArray<DGLogTypeModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObjectsFromArray:DGLogPlugin.shared.arrayM];
    }
    return _dataArray;
}

- (void)reloadListScrollingToBottom:(BOOL)scroll {
    self.visibleArray = [self filteredLogs];
    BOOL filtering = self.keyword.length > 0;
    [self.toolbar updateCountWithTotal:self.dataArray.count matched:self.visibleArray.count filtering:filtering];
    self.emptyLabel.hidden = self.visibleArray.count > 0;
    self.emptyLabel.text = self.dataArray.count == 0 ? @"暂无日志" : @"没有匹配的日志";
    [self.tableView reloadData];

    if (scroll && self.visibleArray.count > 0) {
        NSIndexPath *last = [NSIndexPath indexPathForRow:self.visibleArray.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:last atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (NSArray<DGLogTypeModel *> *)filteredLogs {
    if (self.keyword.length == 0) {
        return [self.dataArray copy];
    }
    NSString *keyword = self.keyword.lowercaseString;
    NSMutableArray<DGLogTypeModel *> *result = [NSMutableArray array];
    for (DGLogTypeModel *model in self.dataArray) {
        if ([self model:model containsKeyword:keyword]) {
            [result addObject:model];
        }
    }
    return result;
}

/// 当前按类型编号和内容做关键字匹配, 后续可以在这里扩展等级、模块等条件
- (BOOL)model:(DGLogTypeModel *)model containsKeyword:(NSString *)keyword {
    NSString *type = [NSString stringWithFormat:@"%d", model.typeID];
    if ([type.lowercaseString containsString:keyword]) {
        return YES;
    }
    NSString *detail = model.dg_dic.description.lowercaseString;
    return [detail containsString:keyword];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.visibleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DGLogTypeModel *typeModel = self.visibleArray[indexPath.row];
    NSString *cellID = @"DGTypeListViewControllerCell";
    DGTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        Class cls = NSClassFromString(DGLogPlugin.shared.configuration.cellClsString);
        if (cls) {
            cell = [[cls alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        } else {
            cell = [[DGTypeListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.28 alpha:1];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.logTypeModel = typeModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kDGImpactFeedback
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DGLogTypeModel *typeModel = self.visibleArray[indexPath.row];
    if (DGLogPlugin.shared.configuration.executeBlock) {
        DGLogPlugin.shared.configuration.executeBlock(typeModel);
    }
}

@end
