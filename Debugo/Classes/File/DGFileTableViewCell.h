//
//  DGFileTableViewCell.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/14.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFileTableViewCell : UITableViewCell

- (void)refreshWithFile:(DGFile *)file;

@end

NS_ASSUME_NONNULL_END
