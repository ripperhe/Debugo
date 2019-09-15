//
//  DGFilePreviewConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFilePreviewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFilePluginConfiguration : NSObject

/// 自定义快捷显示数据库文件（数据库文件或包含数据库的文件夹）
@property (nonatomic, strong) NSArray<NSString *> *shortcutForDatabasePaths;
/// 自定义快捷显示任意文件（文件或文件夹均可）
@property (nonatomic, strong) NSArray<NSString *> *shortcutForAnyPaths;

/// 需要自行控制显示数据库文件的表的列宽的时候，设置该block
@property (nonatomic, copy) DGDatabasePreviewConfiguration * _Nullable(^databaseFilePreviewConfigurationBlock)(NSString *filePath);

@end

NS_ASSUME_NONNULL_END
