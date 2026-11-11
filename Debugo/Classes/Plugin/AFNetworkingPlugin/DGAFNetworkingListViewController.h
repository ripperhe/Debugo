//
//  DGAFNetworkingListViewController.h
//  Debugo
//

#import <UIKit/UIKit.h>
#import "DGAFNetworkingCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAFNetworkingListViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title
                    emptyText:(NSString *)emptyText
                        store:(id<DGAFNetworkingRecordStore>)store
       changeNotificationName:(NSNotificationName)changeNotificationName;

@end

NS_ASSUME_NONNULL_END
