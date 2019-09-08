//
//  DGDatabaseContentParser.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/14.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseContentParser.h"

@implementation DGDatabaseContentParser

+ (BOOL)checkString:(NSString *)string pattern:(NSString *)pattern {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:string];
}

+ (NSString *)parseContentForTimestamp:(NSString *)content {
    if (!content.length) return nil;

    NSTimeInterval time = 0;
    
    NSString *pattern10Int = @"^[0-9]{10}$";
    NSString *pattern10Double = @"^[0-9]{10}.[0-9]+$";
    NSString *pattern13Int = @"^[0-9]{13}$";
    NSString *pattern13Double = @"^[0-9]{13}.[0-9]+$";

    if ([self checkString:content pattern:pattern10Int] || [self checkString:content pattern:pattern10Double]) {
        time = [content doubleValue];
    }else if ([self checkString:content pattern:pattern13Int] || [self checkString:content pattern:pattern13Double]) {
        time = content.doubleValue / 1000;
    }else {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}



@end
