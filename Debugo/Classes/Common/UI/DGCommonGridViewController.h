//
//  DGCommonGridViewController.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGCommonGridConfiguration : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) Class selectedPushViewControllerClass;
@property (nonatomic, copy) UIViewController *(^selectedPushViewControlerBlock)(void);
@property (nonatomic, copy) void(^selectedBlock)(void);

@end

@interface DGCommonGridViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<DGCommonGridConfiguration *> *dataArray;

/// 用于子类重写，配置数据源
- (void)setupDatasouce;
/// 用于子类方便添加网格
- (void)addGrid:(void (^)(DGCommonGridConfiguration *configuration))block;

@end

NS_ASSUME_NONNULL_END
