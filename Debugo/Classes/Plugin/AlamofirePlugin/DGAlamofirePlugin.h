//
//  DGAlamofirePlugin.h
//  Debugo
//
//  业务方把 Alamofire.Session 传进来后，这个插件只拦截该对象发出的请求。
//  Debugo 本身不依赖 Alamofire；拦截逻辑在可选的 DGAlamofireSessionHook.swift 中，
//  需要将其加入 App Target，且工程已集成 Alamofire。

#import "DGPlugin.h"
#import "DGAlamofireCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAlamofirePlugin : DGPlugin

/// 监听 Alamofire.Session 上的请求，并展示在 Debugo「Alamofire请求」页。
/// session 必须是 Alamofire.Session 实例。插件只弱引用它，调用方需要自己持有。
+ (void)monitorSession:(id)session;

/// 列表 cell 展示哪些模块，默认全部展示。详情页不受这个开关影响。
@property (class, nonatomic, assign) DGAFNetworkingListModule listModules;

@end

NS_ASSUME_NONNULL_END
