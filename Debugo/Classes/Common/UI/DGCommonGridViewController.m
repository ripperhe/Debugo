//
//  DGCommonGridViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGCommonGridViewController.h"
#import "DGCommon.h"

@interface DGCommonGridButton : UIButton <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property(nonatomic, strong) CALayer *highlightedBackgroundLayer;
@property (nonatomic, copy) void(^actionBlock)(void);

- (void)addAction:(void (^)(void))block;

@end

@implementation DGCommonGridConfiguration

@end

@interface DGCommonGridViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) NSMutableArray<DGCommonGridButton *> *gridButtons;
@property (nonatomic, strong) CAShapeLayer *gridLayer;

@end

@implementation DGCommonGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDatasouce];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    
    CGFloat gridWidth = CGRectGetWidth(self.scrollView.bounds) - (self.scrollView.dg_safeAreaInsets.left + self.scrollView.dg_safeAreaInsets.right);
    CGFloat gridX = self.scrollView.dg_safeAreaInsets.left;
    
    NSInteger columnCount = 0;
    CGFloat itemWidth = 0;
    
    if (CGRectGetWidth(self.scrollView.bounds) <= 414.0) {
        columnCount = 3;
        itemWidth = gridWidth / columnCount;
    } else {
        CGFloat minimumItemWidth = 414.0 / 3.0;
        CGFloat maximumItemWidth = gridWidth / 5.0;
        CGFloat freeSpacingWhenDisplayingMinimumCount = gridWidth / maximumItemWidth - floor(gridWidth / maximumItemWidth);
        CGFloat freeSpacingWhenDisplayingMaximumCount = gridWidth / minimumItemWidth - floor(gridWidth / minimumItemWidth);
        if (freeSpacingWhenDisplayingMinimumCount < freeSpacingWhenDisplayingMaximumCount) {
            // 按每行最少item的情况来布局的话，空间利用率会更高，所以按最少item来
            columnCount = floor(gridWidth / maximumItemWidth);
            itemWidth = floor(gridWidth / columnCount);
        } else {
            columnCount = floor(gridWidth / minimumItemWidth);
            itemWidth = floor(gridWidth / columnCount);
        }
    }
    
    __block CGFloat itemX = 0;
    __block CGFloat itemY = 0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [self.gridButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx % columnCount == 0) {
            // 第一列
            obj.frame = CGRectMake(gridX, itemY, itemWidth, itemWidth);
            itemX = gridX + itemWidth;
        }else if(idx % columnCount == columnCount - 1) {
            // 最后一列
            obj.frame = CGRectMake(itemX, itemY, itemWidth, itemWidth);
            itemY += itemWidth;
        }else {
            obj.frame = CGRectMake(itemX, itemY, itemWidth, itemWidth);
            itemX += itemWidth;
        }
        
        CGPoint topLeft = obj.frame.origin;
        CGPoint topRight = CGPointMake(CGRectGetMaxX(obj.frame), CGRectGetMinY(obj.frame));
        CGPoint bottomLeft = CGPointMake(CGRectGetMinX(obj.frame), CGRectGetMaxY(obj.frame));
        CGPoint bottomRight = CGPointMake(CGRectGetMaxX(obj.frame), CGRectGetMaxY(obj.frame));
        
        if (idx % columnCount == 0) {
            // 第一列
            [path moveToPoint:bottomLeft];
            [path addLineToPoint:topLeft];
        }
        if (idx < columnCount) {
            // 第一行
            [path moveToPoint:topLeft];
            [path addLineToPoint:topRight];
        }
        [path moveToPoint:topRight];
        [path addLineToPoint:bottomRight];
        [path moveToPoint:bottomRight];
        [path addLineToPoint:bottomLeft];
    }];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.gridButtons.lastObject.frame));
    self.separatorView.dg_size = self.scrollView.contentSize;
    self.gridLayer.path = path.CGPath;
}

#pragma mark -

- (void)setupDatasouce {
    // 用于重写
}

- (void)addGrid:(void (^)(DGCommonGridConfiguration * _Nonnull))block {
    DGCommonGridConfiguration *configuration = [DGCommonGridConfiguration new];
    block(configuration);
    [self.dataArray addObject:configuration];
}

- (void)setupViews {
    self.view.backgroundColor = kDGBackgroundColor;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    [self.dataArray enumerateObjectsUsingBlock:^(DGCommonGridConfiguration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DGCommonGridButton *button = [self generateButtonWithConfiguration:obj index:idx];
        [self.gridButtons addObject:button];
        [self.scrollView addSubview:button];
    }];
    
    self.separatorView = [UIView dg_make:^(UIView *view) {
        view.backgroundColor = [UIColor clearColor];
        self.gridLayer = [CAShapeLayer dg_make:^(CAShapeLayer * layer) {
            layer.strokeColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00].CGColor;
            layer.lineWidth = 0.5;
        }];
        [view.layer addSublayer:self.gridLayer];
    }];
    [self.scrollView addSubview:self.separatorView];
}

- (DGCommonGridButton *)generateButtonWithConfiguration:(DGCommonGridConfiguration *)configuration index:(NSInteger)index {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 12;
    paragraphStyle.maximumLineHeight = 12;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:configuration.title attributes:@{NSForegroundColorAttributeName: UIColor.blackColor, NSFontAttributeName: [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName: paragraphStyle}];
    
    DGCommonGridButton *button = [DGCommonGridButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    if (configuration.imageName.length) {
        [button setImage:[DGBundle imageNamed:configuration.imageName] forState:UIControlStateNormal];
    }else if (configuration.image) {
        [button setImage:configuration.image forState:UIControlStateNormal];
    }
    dg_weakify(self)
    dg_weakify(configuration)
    [button addAction:^{
        dg_strongify(self)
        dg_strongify(configuration)
        kDGImpactFeedback
        if (configuration.selectedPushViewControllerClass) {
            UIViewController *vc = [configuration.selectedPushViewControllerClass new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (configuration.selectedPushViewControlerBlock) {
            UIViewController *vc = configuration.selectedPushViewControlerBlock();
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (configuration.selectedBlock) {
            configuration.selectedBlock();
        }
    }];
    return button;
}

#pragma mark - getter
- (NSMutableArray<DGCommonGridConfiguration *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<DGCommonGridButton *> *)gridButtons {
    if (!_gridButtons) {
        _gridButtons = [NSMutableArray array];
    }
    return _gridButtons;
}

@end

@implementation DGCommonGridButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.numberOfLines = 2;
        self.adjustsImageWhenDisabled = NO;
        self.adjustsImageWhenHighlighted = NO;
        // 处理高亮
        self.highlightedBackgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:241/255.0 alpha:1];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    }
    return self;
}

- (void)layoutSubviews {
    // 不用父类的，自己计算
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) return;
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - (self.contentEdgeInsets.left + self.contentEdgeInsets.right), CGRectGetHeight(self.bounds) - (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom));
    CGPoint center = CGPointMake((self.contentEdgeInsets.left + contentSize.width / 2), (self.contentEdgeInsets.top + contentSize.height / 2));
    
    self.imageView.center = CGPointMake(center.x, center.y - 12);
    
    CGFloat yOffset = kDGScreenMin >= 375.0 ? 27 : 21;
    CGFloat height = [self.titleLabel sizeThatFits:CGSizeMake(contentSize.width, CGFLOAT_MAX)].height;
    self.titleLabel.frame = CGRectMake(self.contentEdgeInsets.left, center.y + yOffset, contentSize.width, height);
}

- (void)addAction:(void (^)(void))block {
    self.actionBlock = block;
}

- (void)adjustHighlight:(BOOL)isHighlight {
    if (!self.highlightedBackgroundLayer) {
        self.highlightedBackgroundLayer = [CALayer layer];
        [self.layer insertSublayer:self.highlightedBackgroundLayer atIndex:0];
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.highlightedBackgroundLayer.frame = self.bounds;
    self.highlightedBackgroundLayer.cornerRadius = self.layer.cornerRadius;
    self.highlightedBackgroundLayer.backgroundColor = isHighlight ? self.highlightedBackgroundColor.CGColor : UIColor.clearColor.CGColor;
    [CATransaction commit];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(adjustHighlight:) object:nil];
    [self adjustHighlight:YES];
    [self performSelector:@selector(adjustHighlight:) withObject:@NO afterDelay:.125];
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
