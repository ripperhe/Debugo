//
//  DGApplePlugin.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGPlugin.h"

/**
 支持 iOS 10 以上系统版本，因为是系统 API 暂未找到代码关闭且不影响其他功能的方法
 * 通过 pluginSwitch 查看是否开启
 * 通过 setPluginSwitch:YES 开启
 * 在 DebuggingOverlay 界面上点击 Dismiss 按钮关闭
 */

@interface DGApplePlugin : DGPlugin

@end
