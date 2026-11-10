//
//  DGAFNetworkingPlugin.m
//  Debugo
//

#import "DGAFNetworkingPlugin.h"
#import "DGAFNetworkingCenter.h"
#import "DGAFNetworkingListViewController.h"

@implementation DGAFNetworkingPlugin

+ (void)monitorSessionManager:(AFURLSessionManager *)sessionManager {
    [DGAFNetworkingCenter.sharedCenter monitorSessionManager:sessionManager];
}

+ (DGAFNetworkingListModule)listModules {
    return DGAFNetworkingCenter.sharedCenter.listModules;
}

+ (void)setListModules:(DGAFNetworkingListModule)listModules {
    DGAFNetworkingCenter.sharedCenter.listModules = listModules;
}

+ (UIImage *)pluginImage {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:34 weight:UIImageSymbolWeightRegular];
    UIImage *image = [UIImage systemImageNamed:@"network" withConfiguration:configuration];
    UIColor *color = [UIColor colorWithRed:108 / 255.0 green:92 / 255.0 blue:231 / 255.0 alpha:1];
    return [image imageWithTintColor:color renderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (NSString *)pluginName {
    return @"AFNetworking请求";
}

+ (UIViewController *)pluginViewController {
    return [DGAFNetworkingListViewController new];
}

@end
