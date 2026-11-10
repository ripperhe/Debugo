//
//  DGAFNetworkingRecord.m
//  Debugo
//

#import "DGAFNetworkingRecord.h"

static const NSUInteger kDGAFNetworkingBodyLimit = 100 * 1024;

static UIColor *DGAFNetworkingColor(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

static NSString *DGAFNetworkingLimitedText(NSString *text) {
    if (text.length <= kDGAFNetworkingBodyLimit) {
        return text ?: @"";
    }
    return [[text substringToIndex:kDGAFNetworkingBodyLimit] stringByAppendingString:@"\n…(已截断)"];
}

NSString *DGAFNetworkingPrettyText(id object) {
    if (!object || object == (id)kCFNull) {
        return @"";
    }
    if ([object isKindOfClass:NSString.class]) {
        NSData *data = [(NSString *)object dataUsingEncoding:NSUTF8StringEncoding];
        id json = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] : nil;
        if (json && ![json isKindOfClass:NSString.class]) {
            return DGAFNetworkingPrettyText(json);
        }
        return DGAFNetworkingLimitedText(object);
    }
    if ([object isKindOfClass:NSData.class]) {
        NSData *data = object;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (json && ![json isKindOfClass:NSString.class] && ![json isKindOfClass:NSData.class]) {
            return DGAFNetworkingPrettyText(json);
        }
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (string.length) {
            return DGAFNetworkingLimitedText(string);
        }
        return [NSString stringWithFormat:@"<binary %lu bytes>", (unsigned long)data.length];
    }
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        if (data) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return DGAFNetworkingLimitedText(string);
        }
    }
    return DGAFNetworkingLimitedText([object description]);
}

NSString *DGAFNetworkingHeaderText(NSDictionary *headers) {
    if (headers.count == 0) {
        return @"";
    }
    NSArray *keys = [headers.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray<NSString *> *lines = [NSMutableArray arrayWithCapacity:keys.count];
    for (id key in keys) {
        [lines addObject:[NSString stringWithFormat:@"%@: %@", key, headers[key]]];
    }
    return [lines componentsJoinedByString:@"\n"];
}

@implementation DGAFNetworkingRecord

- (NSString *)timeText {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    return [formatter stringFromDate:self.startDate ?: [NSDate date]];
}

- (NSString *)durationText {
    if (!self.isFinished) {
        return @"...";
    }
    if (self.duration < 1) {
        return [NSString stringWithFormat:@"%.0fms", self.duration * 1000];
    }
    return [NSString stringWithFormat:@"%.2fs", self.duration];
}

- (NSString *)statusText {
    if (!self.isFinished) {
        return @"...";
    }
    if (self.statusCode <= 0) {
        return @"ERR";
    }
    return [NSString stringWithFormat:@"%ld", (long)self.statusCode];
}

- (UIColor *)statusColor {
    if (!self.isFinished) {
        return DGAFNetworkingColor(142, 142, 147);
    }
    if (self.statusCode >= 200 && self.statusCode < 300) {
        return DGAFNetworkingColor(52, 199, 89);
    }
    if (self.statusCode >= 300 && self.statusCode < 400) {
        return DGAFNetworkingColor(255, 149, 0);
    }
    return DGAFNetworkingColor(123, 97, 255);
}

- (NSString *)detailText {
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"%@ %@ %@\n", self.statusText, self.method ?: @"", self.durationText];
    [text appendFormat:@"%@\n\n", self.timeText];
    [text appendFormat:@"Uri:\n%@\n\n", self.URLString ?: @""];
    [text appendFormat:@"Request headers:\n%@\n\n", self.requestHeaders.length ? self.requestHeaders : @"(空)"];
    [text appendFormat:@"Request data:\n%@\n\n", self.requestBody.length ? self.requestBody : @"(空)"];
    [text appendFormat:@"Response headers:\n%@\n\n", self.responseHeaders.length ? self.responseHeaders : @"(空)"];
    [text appendFormat:@"Response body:\n%@", self.responseBody.length ? self.responseBody : @"(空)"];
    if (self.errorText.length) {
        [text appendFormat:@"\n\nError:\n%@", self.errorText];
    }
    return text;
}

@end
