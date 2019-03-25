//
//  NSDate+Debugo.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (Debugo)

// yyyy-MM-dd HH:mm:ss.SSS
- (NSString *)dg_dateString;

- (NSString *)dg_dateStringWithFormat:(NSString *)format;

@end
