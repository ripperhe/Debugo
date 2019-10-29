//
//  DGPodModel.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/24.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGPodModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, strong) NSArray<NSString *> *nameComponents;
@property (nonatomic, strong) DGOrderedDictionary<NSString *, DGPodModel *> *subPods;

// 以下为网络请求获取

@property (nonatomic, copy, nullable) NSString *latestVersion;
@property (nonatomic, copy, nullable) NSString *homepage;
@property (nonatomic, copy, nullable) NSString *specFilePath;

@end

NS_ASSUME_NONNULL_END
