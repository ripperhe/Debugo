//
//  DGDatabaseContentTableViewCell.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseContentTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^clickButton)(UIButton *button, NSInteger column);

- (void)loadContents:(NSArray *)contents columnWidths:(NSArray <NSNumber *>*)columnWidths;

@end

NS_ASSUME_NONNULL_END
