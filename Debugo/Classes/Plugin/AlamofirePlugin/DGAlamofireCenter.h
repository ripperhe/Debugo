//
//  DGAlamofireCenter.h
//  Debugo
//

#import <Foundation/Foundation.h>
#import "DGAFNetworkingCenter.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const DGAlamofireRecordsDidChangeNotification;

/// 按传入的 Alamofire.Session 拦截请求。调试器不持有 Session。
@interface DGAlamofireCenter : NSObject <DGAFNetworkingRecordStore>

+ (instancetype)sharedCenter;

/// 列表 cell 展示的模块，默认 DGAFNetworkingListModuleAll。
@property (nonatomic, assign) DGAFNetworkingListModule listModules;

/// 传入 Alamofire.Session 实例。插件只弱引用，调用方需要自己持有它。
- (void)monitorSession:(id)session;

- (BOOL)isMonitoringSession:(id)session;

/// 按 recordID 插入或更新一条记录。供 Alamofire hook 写入。
- (void)upsertRecord:(DGAFNetworkingRecord *)record;

- (NSArray<DGAFNetworkingRecord *> *)allRecords;

- (void)clearRecords;

@end

NS_ASSUME_NONNULL_END
