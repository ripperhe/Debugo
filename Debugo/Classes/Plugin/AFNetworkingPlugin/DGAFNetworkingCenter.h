//
//  DGAFNetworkingCenter.h
//  Debugo
//

#import <Foundation/Foundation.h>
#import "DGAFNetworkingRecord.h"

@class AFURLSessionManager;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const DGAFNetworkingRecordsDidChangeNotification;

/// 列表卡片里可单独开关的内容。详情页始终展示全部。
typedef NS_OPTIONS(NSUInteger, DGAFNetworkingListModule) {
    /// 请求地址
    DGAFNetworkingListModuleURI              = 1 << 0,
    /// 请求头
    DGAFNetworkingListModuleRequestHeaders   = 1 << 1,
    /// 请求体
    DGAFNetworkingListModuleRequestData      = 1 << 2,
    /// 响应头
    DGAFNetworkingListModuleResponseHeaders  = 1 << 3,
    /// 响应体
    DGAFNetworkingListModuleResponseBody     = 1 << 4,
    /// 以上全部模块
    DGAFNetworkingListModuleAll              = DGAFNetworkingListModuleURI | DGAFNetworkingListModuleRequestHeaders | DGAFNetworkingListModuleRequestData | DGAFNetworkingListModuleResponseHeaders | DGAFNetworkingListModuleResponseBody,
};

/// 网络请求列表的数据源。AFNetworking 与 Alamofire 各自使用独立的 store。
@protocol DGAFNetworkingRecordStore <NSObject>
- (NSArray<DGAFNetworkingRecord *> *)allRecords;
- (void)clearRecords;
@property (nonatomic, assign, readonly) DGAFNetworkingListModule listModules;
@end

/// 按传入的 AFURLSessionManager 拦截请求。调试器不持有 manager。
@interface DGAFNetworkingCenter : NSObject <DGAFNetworkingRecordStore>

+ (instancetype)sharedCenter;

/// 列表 cell 展示的模块，默认 DGAFNetworkingListModuleAll。
@property (nonatomic, assign) DGAFNetworkingListModule listModules;

- (void)monitorSessionManager:(AFURLSessionManager *)sessionManager;

- (NSArray<DGAFNetworkingRecord *> *)allRecords;

- (void)clearRecords;

@end

NS_ASSUME_NONNULL_END
