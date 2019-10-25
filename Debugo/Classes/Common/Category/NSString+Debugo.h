//
//  NSString+Debugo.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Debugo)

+ (NSString *)dg_stringByCombineComponents:(NSArray<NSString *> *)components separatedString:(nullable NSString *)separatedString;

@end

NS_ASSUME_NONNULL_END
