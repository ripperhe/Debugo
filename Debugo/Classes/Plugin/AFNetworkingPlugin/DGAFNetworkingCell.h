//
//  DGAFNetworkingCell.h
//  Debugo
//

#import <UIKit/UIKit.h>
#import "DGAFNetworkingRecord.h"
#import "DGAFNetworkingCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAFNetworkingCell : UITableViewCell

@property (nonatomic, strong, nullable) DGAFNetworkingRecord *record;
/// 当前 cell 展示的模块。未设置时展示全部。
@property (nonatomic, assign) DGAFNetworkingListModule modules;

@end

NS_ASSUME_NONNULL_END
