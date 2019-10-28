//
//  DGSpecRepoModel.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGPodModel.h"
#import "DGOrderedDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGSpecRepoModel : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isOfficial;
@property (nonatomic, assign) BOOL isRemote;
@property (nonatomic, strong) DGOrderedDictionary<NSString *, DGPodModel *> *pods;

@end

NS_ASSUME_NONNULL_END
