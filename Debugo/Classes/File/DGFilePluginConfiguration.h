//
//  DGFileConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFileConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFilePluginConfiguration : NSObject

/// 自定义快捷显示数据库文件（数据库文件或包含数据库的文件夹）
@property (nonatomic, strong) NSArray <NSString *>*shortcutForDatabasePaths;
/// 自定义快捷显示任意文件（文件或文件夹均可）
@property (nonatomic, strong) NSArray <NSString *>*shortcutForAnyPaths;

/// 需要自行控制显示数据库文件的表的行高、列宽的时候需要实现该代理方法
@property (nonatomic, copy) DGDatabasePreviewConfiguration * __nullable (^databasePreviewConfigurationFetcher)(NSURL *databaseURL);

@end

NS_ASSUME_NONNULL_END
