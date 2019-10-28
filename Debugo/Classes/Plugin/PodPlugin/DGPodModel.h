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
@property (nonatomic, copy) NSString *homepage;
@end

NS_ASSUME_NONNULL_END
