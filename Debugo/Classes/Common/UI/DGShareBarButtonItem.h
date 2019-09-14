//
//  DGShareBarButtonItem.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/3/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGShareBarButtonItem : UIBarButtonItem

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) NSArray <NSString *>*(^shareFilePathsWhenClickedBlock)(DGShareBarButtonItem *);

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action NS_UNAVAILABLE ;
- (instancetype)initWithViewController:(UIViewController *)viewController shareFilePathsWhenClickedBlock:(nullable NSArray <NSString *>* (^)(DGShareBarButtonItem *item))shareFilePathsWhenClickedBlock;

@end

NS_ASSUME_NONNULL_END
