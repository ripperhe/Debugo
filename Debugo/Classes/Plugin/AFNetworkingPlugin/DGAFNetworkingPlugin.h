//
//  DGAFNetworkingPlugin.h
//  Debugo
//
//  业务方把 AFURLSessionManager 传进来后，这个插件只拦截该对象发出的请求。

#import "DGPlugin.h"
#import "DGAFNetworkingCenter.h"

@class AFURLSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface DGAFNetworkingPlugin : DGPlugin

/// 监听 sessionManager 上的请求，并展示在 Debugo「AFNetworking请求」页。
/// 插件只弱引用 sessionManager，调用方需要自己持有它。
+ (void)monitorSessionManager:(AFURLSessionManager *)sessionManager;

/// 列表 cell 展示哪些模块，默认全部展示。详情页不受这个开关影响。
/// 例如只看地址和请求体：DGAFNetworkingListModuleURI | DGAFNetworkingListModuleRequestData
@property (class, nonatomic, assign) DGAFNetworkingListModule listModules;

@end

NS_ASSUME_NONNULL_END
