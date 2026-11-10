//
//  DGAlamofirePlugin.m
//  Debugo
//

#import "DGAlamofirePlugin.h"
#import "DGAFNetworkingListViewController.h"

@implementation DGAlamofirePlugin

+ (void)monitorSession:(id)session {
    [DGAlamofireCenter.sharedCenter monitorSession:session];
}

+ (DGAFNetworkingListModule)listModules {
    return DGAlamofireCenter.sharedCenter.listModules;
}

+ (void)setListModules:(DGAFNetworkingListModule)listModules {
    DGAlamofireCenter.sharedCenter.listModules = listModules;
}

+ (UIImage *)pluginImage {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:34 weight:UIImageSymbolWeightRegular];
    UIImage *image = [UIImage systemImageNamed:@"antenna.radiowaves.left.and.right" withConfiguration:configuration];
    UIColor *color = [UIColor colorWithRed:255 / 255.0 green:149 / 255.0 blue:0 / 255.0 alpha:1];
    return [image imageWithTintColor:color renderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (NSString *)pluginName {
    return @"Alamofire请求";
}

+ (UIViewController *)pluginViewController {
    return [[DGAFNetworkingListViewController alloc] initWithTitle:@"Alamofire请求拦截"
                                                   emptyText:@"还没有请求\n业务方传入 Alamofire.Session 后，对应请求会显示在这里"
                                                       store:DGAlamofireCenter.sharedCenter
                                      changeNotificationName:DGAlamofireRecordsDidChangeNotification];
}

@end
