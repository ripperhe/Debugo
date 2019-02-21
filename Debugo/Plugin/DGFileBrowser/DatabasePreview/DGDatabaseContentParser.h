//
//  DGDatabaseContentParser.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/14.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseContentParser : NSObject

+ (NSString *)parseContentForTimestamp:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
