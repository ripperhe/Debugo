//
//  FTPopOverMenu.h
//  FTPopOverMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import "DGPopOverMenu.h"

///------------------------------------------------
/// Code From FTPopOverMenu https://github.com/liufengting/FTPopOverMenu
///------------------------------------------------

// changeable
#define DGDefaultMargin                     4.f
#define DGDefaultMenuTextMargin             6.f
#define DGDefaultMenuIconMargin             6.f
#define DGDefaultMenuCornerRadius           5.f
#define DGDefaultAnimationDuration          0.2
// change them at your own risk
#define KSCREEN_WIDTH                       [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_HEIGHT                      [[UIScreen mainScreen] bounds].size.height
#define DGDefaultBackgroundColor            [UIColor clearColor]
#define DGDefaultTintColor                  [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1.f]
#define DGDefaultTextColor                  [UIColor whiteColor]
#define DGDefaultSelectedTextColor          [UIColor redColor]
#define DGDefaultCellSelectedBackgroundColor    [UIColor grayColor]
#define DGDefaultSeparatorColor             [UIColor grayColor]
#define DGDefaultMenuFont                   [UIFont systemFontOfSize:14.f]
#define DGDefaultMenuWidth                  120.f
#define DGDefaultMenuIconSize               24.f
#define DGDefaultMenuRowHeight              40.f
#define DGDefaultMenuBorderWidth            0.8
#define DGDefaultMenuArrowWidth             8.f
#define DGDefaultMenuArrowHeight            10.f
#define DGDefaultMenuArrowWidth_R           12.f
#define DGDefaultMenuArrowHeight_R          12.f
#define DGDefaultMenuArrowRoundRadius       4.f
#define DGDefaultShadowColor                [UIColor blackColor]
#define DGDefaultShadowRadius               5.f
#define DGDefaultShadowOpacity              0.f
#define DGDefaultShadowOffsetX              0.f
#define DGDefaultShadowOffsetY              2.f


static NSString  *const DGPopOverMenuTableViewCellIndentifier = @"DGPopOverMenuTableViewCellIndentifier";
static NSString  *const DGPopOverMenuImageCacheDirectory = @"com.DGPopOverMenuImageCache";
/**
 *  DGPopOverMenuArrowDirection
 */
typedef NS_ENUM(NSUInteger, DGPopOverMenuArrowDirection) {
    /**
     *  Up
     */
    DGPopOverMenuArrowDirectionUp,
    /**
     *  Down
     */
    DGPopOverMenuArrowDirectionDown,
};

#pragma mark - DGPopOverMenuModel

@implementation DGPopOverMenuModel

- (instancetype)initWithTitle:(NSString *)title image:(id)image selected:(BOOL)selected {
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.selected = selected;
    }
    return self;
}

@end

#pragma mark - DGPopOverMenuConfiguration

@interface DGPopOverMenuConfiguration ()

@end

@implementation DGPopOverMenuConfiguration

+ (DGPopOverMenuConfiguration *)defaultConfiguration {
    DGPopOverMenuConfiguration *configuration = [[DGPopOverMenuConfiguration alloc] init];
    return configuration;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuRowHeight = DGDefaultMenuRowHeight;
        self.menuWidth = DGDefaultMenuWidth;
        self.textColor = DGDefaultTextColor;
        self.textFont = DGDefaultMenuFont;
        self.backgroundColor = DGDefaultTintColor;
        self.borderColor = DGDefaultTintColor;
        self.borderWidth = DGDefaultMenuBorderWidth;
        self.textAlignment = NSTextAlignmentLeft;
        self.ignoreImageOriginalColor = NO;
        self.allowRoundedArrow = NO;
        self.menuTextMargin = DGDefaultMenuTextMargin;
        self.menuIconMargin = DGDefaultMenuIconMargin;
        self.animationDuration = DGDefaultAnimationDuration;
        self.selectedTextColor = DGDefaultSelectedTextColor;
        self.selectedCellBackgroundColor = DGDefaultCellSelectedBackgroundColor;
        self.separatorColor = DGDefaultSeparatorColor;
        self.shadowColor = DGDefaultShadowColor;
        self.shadowRadius = DGDefaultShadowRadius;
        self.shadowOpacity = DGDefaultShadowOpacity;
        self.shadowOffsetX = DGDefaultShadowOffsetX;
        self.shadowOffsetY = DGDefaultShadowOffsetY;
    }
    return self;
}

@end

#pragma mark - DGPopOverMenuCell

@interface DGPopOverMenuCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *menuNameLabel;

@end

@implementation DGPopOverMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                    menuName:(NSString *)menuName
                   menuImage:(id)menuImage
                    selected:(BOOL)selected
                configuration:(DGPopOverMenuConfiguration *)configuration {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self setupWithMenuName:menuName menuImage:menuImage selected:selected configuration:configuration];
    }
    return self;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)menuNameLabel {
    if (!_menuNameLabel) {
        _menuNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _menuNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _menuNameLabel;
}

- (void)setupWithMenuName:(NSString *)menuName menuImage:(id)menuImage selected:(BOOL)selected configuration:(DGPopOverMenuConfiguration *)configuration {
    CGFloat margin = (configuration.menuRowHeight - DGDefaultMenuIconSize)/2.f;
    CGRect iconImageRect = CGRectMake(configuration.menuIconMargin, margin, DGDefaultMenuIconSize, DGDefaultMenuIconSize);
    CGFloat menuNameX = iconImageRect.origin.x + iconImageRect.size.width + configuration.menuTextMargin;
    CGRect menuNameRect = CGRectMake(menuNameX, 0, configuration.menuWidth - menuNameX - configuration.menuTextMargin, configuration.menuRowHeight);

    if (!menuImage) {
        menuNameRect = CGRectMake(configuration.menuTextMargin, 0, configuration.menuWidth - configuration.menuTextMargin*2, configuration.menuRowHeight);
    }else{
        self.iconImageView.frame = iconImageRect;
        self.iconImageView.tintColor = configuration.textColor;

        [self getImageWithResource:menuImage
                        completion:^(UIImage *image) {
                            if (configuration.ignoreImageOriginalColor) {
                                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            }
                            self.iconImageView.image = image;
                        }];
        [self.contentView addSubview:self.iconImageView];
    }
    self.menuNameLabel.frame = menuNameRect;
    self.menuNameLabel.font = configuration.textFont;
    self.menuNameLabel.textColor = configuration.textColor;
    self.menuNameLabel.textAlignment = configuration.textAlignment;
    self.menuNameLabel.text = menuName;
    [self.contentView addSubview:self.menuNameLabel];

    if (selected) {
        self.menuNameLabel.textColor = configuration.selectedTextColor;
        self.backgroundColor = configuration.selectedCellBackgroundColor;
    }
}

/**
 get image from local or remote

 @param resource image reource
 @param completion get image back
 */
- (void)getImageWithResource:(id)resource completion:(void (^)(UIImage *image))completion {
    if ([resource isKindOfClass:[UIImage class]]) {
        completion(resource);
    }else if ([resource isKindOfClass:[NSString class]]) {
        if ([resource hasPrefix:@"http"]) {
            [self downloadImageWithURL:[NSURL URLWithString:resource] completion:completion];
        }else{
            completion([UIImage imageNamed:resource]);
        }
    }else if ([resource isKindOfClass:[NSURL class]]) {
        [self downloadImageWithURL:resource completion:completion];
    }else{
        NSLog(@"Image resource not recougnized.");
        completion(nil);
    }
}

/**
 download image if needed, cache image into disk if needed.

 @param url imageURL
 @param completion get image back
 */
- (void)downloadImageWithURL:(NSURL *)url completion:(void (^)(UIImage *image))completion {
    if ([self isExitImageForImageURL:url]) {
        NSString *filePath = [self filePathForImageURL:url];
        completion([UIImage imageWithContentsOfFile:filePath]);
    }else{
        // download
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (image) {
                NSData *data = UIImagePNGRepresentation(image);
                [data writeToFile:[self filePathForImageURL:url] atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }
        });
    }
}

/**
 return if the image is downloaded and cached before

 @param url imageURL
 @return if the image is downloaded and cached before
 */
- (BOOL)isExitImageForImageURL:(NSURL *)url {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePathForImageURL:url]];
}

/**
 get local disk cash filePath for imageurl

 @param url imageURL
 @return filePath
 */
- (NSString *)filePathForImageURL:(NSURL *)url {
    NSString *diskCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DGPopOverMenuImageCacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]){
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:@{}
                                                        error:&error];
    }
    NSData *data = [url.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *pathComponent = [data base64EncodedStringWithOptions:NSUTF8StringEncoding];
    NSString *filePath = [diskCachePath stringByAppendingPathComponent:pathComponent];
    return filePath;
}

@end



#pragma mark - DGPopOverMenuView

@interface DGPopOverMenuView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSArray *menuStringArray;
@property (nonatomic, strong) NSArray *menuImageArray;
@property (nonatomic, assign) DGPopOverMenuArrowDirection arrowDirection;
@property (nonatomic, strong) DGPopOverMenuDoneBlock doneBlock;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) DGPopOverMenuConfiguration *config;

@end

@implementation DGPopOverMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (DGPopOverMenuConfiguration *)config {
    if (!_config) {
        _config = [DGPopOverMenuConfiguration defaultConfiguration];
    }
    return _config;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.backgroundColor = DGDefaultBackgroundColor;
        _menuTableView.separatorColor = self.config.separatorColor;
        _menuTableView.layer.cornerRadius = DGDefaultMenuCornerRadius;
        _menuTableView.scrollEnabled = NO;
        _menuTableView.clipsToBounds = YES;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        [self addSubview:_menuTableView];
    }
    return _menuTableView;
}

- (CGFloat)menuArrowWidth {
    return self.config.allowRoundedArrow ? DGDefaultMenuArrowWidth_R : DGDefaultMenuArrowWidth;
}

- (CGFloat)menuArrowHeight {
    return self.config.allowRoundedArrow ? DGDefaultMenuArrowHeight_R : DGDefaultMenuArrowHeight;
}

- (void)showWithFrame:(CGRect )frame
          anglePoint:(CGPoint )anglePoint
       withNameArray:(NSArray *)nameArray
      imageNameArray:(NSArray *)imageNameArray
    shouldAutoScroll:(BOOL)shouldAutoScroll
               config:(DGPopOverMenuConfiguration *)config
      arrowDirection:(DGPopOverMenuArrowDirection)arrowDirection
           doneBlock:(DGPopOverMenuDoneBlock)doneBlock {
    self.frame = frame;
    self.config = config ? config : [DGPopOverMenuConfiguration defaultConfiguration];
    _menuStringArray = nameArray;
    _menuImageArray = imageNameArray;
    _arrowDirection = arrowDirection;
    self.doneBlock = doneBlock;
    self.menuTableView.scrollEnabled = shouldAutoScroll;


    CGRect menuRect = CGRectMake(0, self.menuArrowHeight, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    if (_arrowDirection == DGPopOverMenuArrowDirectionDown) {
        menuRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    }
    [self.menuTableView setFrame:menuRect];
    [self.menuTableView reloadData];

    [self drawBackgroundLayerWithAnglePoint:anglePoint];
}

- (void)drawBackgroundLayerWithAnglePoint:(CGPoint)anglePoint {
    if (_backgroundLayer) {
        [_backgroundLayer removeFromSuperlayer];
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    BOOL allowRoundedArrow = self.config.allowRoundedArrow;
    CGFloat offset = 2.f*DGDefaultMenuArrowRoundRadius*sinf(M_PI_4/2.f);
    CGFloat roundcenterHeight = offset + DGDefaultMenuArrowRoundRadius*sqrtf(2.f);
    CGPoint roundcenterPoint = CGPointMake(anglePoint.x, roundcenterHeight);

    switch (_arrowDirection) {
        case DGPopOverMenuArrowDirectionUp:{

            if (allowRoundedArrow) {
                [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight - 2.f*DGDefaultMenuArrowRoundRadius) radius:2.f*DGDefaultMenuArrowRoundRadius startAngle:M_PI_2 endAngle:M_PI_4*3.f clockwise:YES];
                [path addLineToPoint:CGPointMake(anglePoint.x + DGDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y - DGDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                [path addArcWithCenter:roundcenterPoint radius:DGDefaultMenuArrowRoundRadius startAngle:M_PI_4*7.f endAngle:M_PI_4*5.f clockwise:NO];
                [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), self.menuArrowHeight - offset/sqrtf(2.f))];
                [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, self.menuArrowHeight - 2.f*DGDefaultMenuArrowRoundRadius) radius:2.f*DGDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_2 clockwise:YES];
            } else {
                [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight)];
                [path addLineToPoint:anglePoint];
                [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, self.menuArrowHeight)];
            }

            [path addLineToPoint:CGPointMake( DGDefaultMenuCornerRadius, self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(DGDefaultMenuCornerRadius, self.menuArrowHeight + DGDefaultMenuCornerRadius) radius:DGDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            [path addLineToPoint:CGPointMake( 0, self.bounds.size.height - DGDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(DGDefaultMenuCornerRadius, self.bounds.size.height - DGDefaultMenuCornerRadius) radius:DGDefaultMenuCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - DGDefaultMenuCornerRadius, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - DGDefaultMenuCornerRadius, self.bounds.size.height - DGDefaultMenuCornerRadius) radius:DGDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , DGDefaultMenuCornerRadius + self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - DGDefaultMenuCornerRadius, DGDefaultMenuCornerRadius + self.menuArrowHeight) radius:DGDefaultMenuCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
            [path closePath];

        }break;
        case DGPopOverMenuArrowDirectionDown:{

            roundcenterPoint = CGPointMake(anglePoint.x, anglePoint.y - roundcenterHeight);

            if (allowRoundedArrow) {
                [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*DGDefaultMenuArrowRoundRadius) radius:2.f*DGDefaultMenuArrowRoundRadius startAngle:M_PI_2*3 endAngle:M_PI_4*5.f clockwise:NO];
                [path addLineToPoint:CGPointMake(anglePoint.x + DGDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y + DGDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                [path addArcWithCenter:roundcenterPoint radius:DGDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_4*3.f clockwise:YES];
                [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), anglePoint.y - self.menuArrowHeight + offset/sqrtf(2.f))];
                [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*DGDefaultMenuArrowRoundRadius) radius:2.f*DGDefaultMenuArrowRoundRadius startAngle:M_PI_4*7 endAngle:M_PI_2*3 clockwise:NO];
            } else {
                [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
                [path addLineToPoint:anglePoint];
                [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
            }

            [path addLineToPoint:CGPointMake( DGDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(DGDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight - DGDefaultMenuCornerRadius) radius:DGDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path addLineToPoint:CGPointMake( 0, DGDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(DGDefaultMenuCornerRadius, DGDefaultMenuCornerRadius) radius:DGDefaultMenuCornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - DGDefaultMenuCornerRadius, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - DGDefaultMenuCornerRadius, DGDefaultMenuCornerRadius) radius:DGDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , anglePoint.y - (DGDefaultMenuCornerRadius + self.menuArrowHeight))];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - DGDefaultMenuCornerRadius, anglePoint.y - (DGDefaultMenuCornerRadius + self.menuArrowHeight)) radius:DGDefaultMenuCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path closePath];

        }break;
        default:
            break;
    }

    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.lineWidth = self.config.borderWidth;
    _backgroundLayer.fillColor = self.config.backgroundColor.CGColor;
    _backgroundLayer.strokeColor = self.config.borderColor.CGColor;
    _backgroundLayer.shadowOpacity = self.config.shadowOpacity;
    _backgroundLayer.shadowColor = self.config.shadowColor.CGColor;
    _backgroundLayer.shadowRadius = self.config.shadowRadius;
    _backgroundLayer.shadowOffset = CGSizeMake(self.config.shadowOffsetX, self.config.shadowOffsetY);
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.config.menuRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuStringArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id menuImage;
    BOOL selected = NO;
    if (_menuImageArray.count - 1 >= indexPath.row) {
        menuImage = _menuImageArray[indexPath.row];
    }
    NSString *title = [NSString string];
    id object = _menuStringArray[indexPath.row];
    if ([object isKindOfClass:[DGPopOverMenuModel class]]) {
        title = ((DGPopOverMenuModel *)object).title;
        menuImage = ((DGPopOverMenuModel *)object).image;
        selected = ((DGPopOverMenuModel *)object).selected;
    }else{
        title = [NSString stringWithFormat:@"%@", object];
    }

    DGPopOverMenuCell *menuCell = [[DGPopOverMenuCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:DGPopOverMenuTableViewCellIndentifier
                                                                 menuName:title
                                                                menuImage:menuImage
                                                                 selected:selected
                                                            configuration:self.config];
    if (indexPath.row == _menuStringArray.count-1) {
        menuCell.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0);
    }else{
        menuCell.separatorInset = UIEdgeInsetsMake(0, self.config.menuTextMargin, 0, self.config.menuTextMargin);
    }
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id object = _menuStringArray[indexPath.row];
    if ([object isKindOfClass:[DGPopOverMenuModel class]]) {
        [_menuStringArray enumerateObjectsUsingBlock:^(DGPopOverMenuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = idx == indexPath.row;
        }];
        [self.menuTableView reloadData];
    }

    if (self.doneBlock) {
        self.doneBlock(indexPath.row);
    }
}

@end


#pragma mark - DGPopOverMenu

@interface DGPopOverMenu () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) DGPopOverMenuView *popMenuView;
@property (nonatomic, strong) DGPopOverMenuDoneBlock doneBlock;
@property (nonatomic, strong) DGPopOverMenuDismissBlock dismissBlock;

@property (nonatomic, strong) UIView *sender;
@property (nonatomic, assign) CGRect senderFrame;
@property (nonatomic, strong) NSArray<NSString*> *menuArray;
@property (nonatomic, strong) NSArray<NSString*> *menuImageArray;
@property (nonatomic, assign) BOOL isCurrentlyOnScreen;
@property (nonatomic, strong) DGPopOverMenuConfiguration *config;

@end

@implementation DGPopOverMenu

+ (DGPopOverMenu *)sharedInstance {
    static dispatch_once_t once = 0;
    static DGPopOverMenu *shared;
    dispatch_once(&once, ^{ shared = [[DGPopOverMenu alloc] init]; });
    return shared;
}

#pragma mark - Public Method

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray *)menuArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:nil config:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray config:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
         configuration:(DGPopOverMenuConfiguration *)configuration
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray config:configuration doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray *)menuArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:[event.allTouches.anyObject view] senderFrame:CGRectNull withMenu:menuArray imageNameArray:nil config:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:[event.allTouches.anyObject view] senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray config:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray *)menuArray
            imageArray:(NSArray *)imageArray
         configuration:(DGPopOverMenuConfiguration *)configuration
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:[event.allTouches.anyObject view] senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray config:configuration doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray *)menuArray
                   doneBlock:(DGPopOverMenuDoneBlock)doneBlock
                dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame withMenu:menuArray imageNameArray:nil config:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray *)menuArray
                  imageArray:(NSArray *)imageArray
                   doneBlock:(DGPopOverMenuDoneBlock)doneBlock
                dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame withMenu:menuArray imageNameArray:imageArray config:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray *)menuArray
                  imageArray:(NSArray *)imageArray
               configuration:(DGPopOverMenuConfiguration *)configuration
                   doneBlock:(DGPopOverMenuDoneBlock)doneBlock
                dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame withMenu:menuArray imageNameArray:imageArray config:configuration doneBlock:doneBlock dismissBlock:dismissBlock];
}

+(void)dismiss {
    [[self sharedInstance] dismiss];
}

#pragma mark - Private Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangeStatusBarOrientationNotification:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (DGPopOverMenuConfiguration *)config {
    if (!_config) {
        _config = [DGPopOverMenuConfiguration defaultConfiguration];
    }
    return _config;
}

- (UIWindow *)backgroundWindow {
    /** ******************************************************* */
    // ripper: fix window
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows.reverseObjectEnumerator) {
        if (window.hidden == YES || window.opaque == NO) {
            continue;
        }
        if (CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds) == NO) {
            continue;
        }
        SEL canBecomeKeySel = NSSelectorFromString(@"_canBecomeKeyWindow");
        if ([window respondsToSelector:canBecomeKeySel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            BOOL canBecomeKey = (BOOL)[window performSelector:canBecomeKeySel];
#pragma clang diagnostic pop
            if (!canBecomeKey) {
                continue;
            }
        }
        return window;
    }
    if ([UIApplication sharedApplication].keyWindow) {
        return [UIApplication sharedApplication].keyWindow;
    }
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        return [UIApplication sharedApplication].delegate.window;
    }
    return nil;
    /** ******************************************************* */
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
//    if (window == nil && [delegate respondsToSelector:@selector(window)]){
//        window = [delegate performSelector:@selector(window)];
//    }
//    return window;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.backgroundColor = DGDefaultBackgroundColor;
    }
    return _backgroundView;
}

- (DGPopOverMenuView *)popMenuView {
    if (!_popMenuView) {
        _popMenuView = [[DGPopOverMenuView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _popMenuView.alpha = 0;
    }
    return _popMenuView;
}

- (CGFloat)menuArrowWidth {
    return self.config.allowRoundedArrow ? DGDefaultMenuArrowWidth_R : DGDefaultMenuArrowWidth;
}

- (CGFloat)menuArrowHeight {
    return self.config.allowRoundedArrow ? DGDefaultMenuArrowHeight_R : DGDefaultMenuArrowHeight;
}

- (void)onChangeStatusBarOrientationNotification:(NSNotification *)notification {
    if (self.isCurrentlyOnScreen) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self adjustPopOverMenu];
        });
    }
}

- (void) showForSender:(UIView *)sender
           senderFrame:(CGRect )senderFrame
              withMenu:(NSArray *)menuArray
        imageNameArray:(NSArray *)imageNameArray
                config:(DGPopOverMenuConfiguration *)config
             doneBlock:(DGPopOverMenuDoneBlock)doneBlock
          dismissBlock:(DGPopOverMenuDismissBlock)dismissBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.config = config ? config : [DGPopOverMenuConfiguration defaultConfiguration];
        [self.backgroundView addSubview:self.popMenuView];
        [[self backgroundWindow] addSubview:self.backgroundView];

        self.sender = sender;
        self.senderFrame = senderFrame;
        self.menuArray = menuArray;
        self.menuImageArray = imageNameArray;
        self.doneBlock = doneBlock;
        self.dismissBlock = dismissBlock;

        [self adjustPopOverMenu];
    });
}

- (void)adjustPopOverMenu {

    [self.backgroundView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];

    CGRect senderRect ;

    if (self.sender) {
        senderRect = [self.sender.superview convertRect:self.sender.frame toView:self.backgroundView];
        // if run into touch problems on nav bar, use the fowllowing line.
        //        senderRect.origin.y = MAX(64-senderRect.origin.y, senderRect.origin.y);
    } else {
        senderRect = self.senderFrame;
    }
    if (senderRect.origin.y > KSCREEN_HEIGHT) {
        senderRect.origin.y = KSCREEN_HEIGHT;
    }

    CGFloat menuHeight = self.config.menuRowHeight * self.menuArray.count + self.menuArrowHeight;
    CGPoint menuArrowPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width)/2, 0);
    CGFloat menuX = 0;
    CGRect menuRect = CGRectZero;
    BOOL shouldAutoScroll = NO;
    DGPopOverMenuArrowDirection arrowDirection;

    if (senderRect.origin.y + senderRect.size.height/2  < KSCREEN_HEIGHT/2) {
        arrowDirection = DGPopOverMenuArrowDirectionUp;
        menuArrowPoint.y = 0;
    }else{
        arrowDirection = DGPopOverMenuArrowDirectionDown;
        menuArrowPoint.y = menuHeight;

    }

    if (menuArrowPoint.x + self.config.menuWidth/2 + DGDefaultMargin > KSCREEN_WIDTH) {
        menuArrowPoint.x = MIN(menuArrowPoint.x - (KSCREEN_WIDTH - self.config.menuWidth - DGDefaultMargin), self.config.menuWidth - self.menuArrowWidth - DGDefaultMargin);
        menuX = KSCREEN_WIDTH - self.config.menuWidth - DGDefaultMargin;
    }else if ( menuArrowPoint.x - self.config.menuWidth/2 - DGDefaultMargin < 0){
        menuArrowPoint.x = MAX( DGDefaultMenuCornerRadius + self.menuArrowWidth, menuArrowPoint.x - DGDefaultMargin);
        menuX = DGDefaultMargin;
    }else{
        menuArrowPoint.x = self.config.menuWidth/2;
        menuX = senderRect.origin.x + (senderRect.size.width)/2 - self.config.menuWidth/2;
    }

    if (arrowDirection == DGPopOverMenuArrowDirectionUp) {
        menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), self.config.menuWidth, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y + menuRect.size.height > KSCREEN_HEIGHT) {
            menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), self.config.menuWidth, KSCREEN_HEIGHT - menuRect.origin.y - DGDefaultMargin);
            shouldAutoScroll = YES;
        }
    }else{

        menuRect = CGRectMake(menuX, (senderRect.origin.y - menuHeight), self.config.menuWidth, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y  < 0) {
            menuRect = CGRectMake(menuX, DGDefaultMargin, self.config.menuWidth, senderRect.origin.y - DGDefaultMargin);
            menuArrowPoint.y = senderRect.origin.y;
            shouldAutoScroll = YES;
        }
    }

    [self prepareToShowWithMenuRect:menuRect
                     menuArrowPoint:menuArrowPoint
                   shouldAutoScroll:shouldAutoScroll
                     arrowDirection:arrowDirection];


    [self show];
}

- (void)prepareToShowWithMenuRect:(CGRect)menuRect menuArrowPoint:(CGPoint)menuArrowPoint shouldAutoScroll:(BOOL)shouldAutoScroll arrowDirection:(DGPopOverMenuArrowDirection)arrowDirection {
    CGPoint anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 0);
    if (arrowDirection == DGPopOverMenuArrowDirectionDown) {
        anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 1);
    }
    _popMenuView.transform = CGAffineTransformMakeScale(1, 1);

    [_popMenuView showWithFrame:menuRect
                     anglePoint:menuArrowPoint
                  withNameArray:self.menuArray
                 imageNameArray:self.menuImageArray
               shouldAutoScroll:shouldAutoScroll
                         config:self.config
                 arrowDirection:arrowDirection
                      doneBlock:^(NSInteger selectedIndex) {
                          [self doneActionWithSelectedIndex:selectedIndex];
                      }];

    [self setAnchorPoint:anchorPoint forView:_popMenuView];

    _popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);

    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);

    CGPoint position = view.layer.position;

    position.x -= oldPoint.x;
    position.x += newPoint.x;

    position.y -= oldPoint.y;
    position.y += newPoint.y;

    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:_popMenuView];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else if (CGRectContainsPoint(CGRectMake(0, 0, self.config.menuWidth, self.config.menuRowHeight), point)) {
        [self doneActionWithSelectedIndex:0];
        return NO;
    }
    return YES;
}

#pragma mark - onBackgroundViewTapped

- (void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture {
    [self dismiss];
}

#pragma mark - show animation

- (void)show {
    self.isCurrentlyOnScreen = YES;
    [UIView animateWithDuration:DGDefaultAnimationDuration
                     animations:^{
                         self.popMenuView.alpha = 1;
                         self.popMenuView.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

#pragma mark - dismiss animation

- (void)dismiss {
    self.isCurrentlyOnScreen = NO;
    [self doneActionWithSelectedIndex:-1];
}

#pragma mark - doneActionWithSelectedIndex

- (void)doneActionWithSelectedIndex:(NSInteger)selectedIndex {
    [UIView animateWithDuration:DGDefaultAnimationDuration
                     animations:^{
                         self.popMenuView.alpha = 0;
                         self.popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }completion:^(BOOL finished) {
                         if (finished) {
                             [self.popMenuView removeFromSuperview];
                             [self.backgroundView removeFromSuperview];
                             if (selectedIndex < 0) {
                                 if (self.dismissBlock) {
                                     self.dismissBlock();
                                 }
                             }else{
                                 if (self.doneBlock) {
                                     self.doneBlock(selectedIndex);
                                 }
                             }
                         }
                     }];
}

@end
