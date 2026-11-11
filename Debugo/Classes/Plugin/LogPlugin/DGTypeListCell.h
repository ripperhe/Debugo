//
//  DGTypeListCell.h
//  Debugo
//
//  Created by Atlas on 2024/10/9.
//

#import <UIKit/UIKit.h>
#import "DGLogTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGTypeListCell : UITableViewCell

@property (nonatomic, strong) DGLogTypeModel *logTypeModel;

@end

NS_ASSUME_NONNULL_END
