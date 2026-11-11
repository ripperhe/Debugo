//
//  DGLogPluginConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by kika on 2024/4/17.
//  Copyright © 2024 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGLogTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGLogPluginConfiguration : NSObject

/// cell的class字符串
@property (nonatomic, copy) NSString *cellClsString;

/** 选中列表时，会调用这个 block，并传回模型信息，可以在该处实现业务 */
@property (nonatomic, copy) void(^executeBlock)(DGLogTypeModel *typeModel);

@end

NS_ASSUME_NONNULL_END
