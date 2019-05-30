//
//  NSDate+Debugo.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "NSDate+Debugo.h"

@implementation NSDate (Debugo)

- (NSString *)dg_dateString {
    return [self dg_dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
}

- (NSString *)dg_dateStringWithFormat:(NSString *)format {
    // https://stackoverflow.com/questions/1526990/nstimezone-what-is-the-difference-between-localtimezone-and-systemtimezone
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

@end
