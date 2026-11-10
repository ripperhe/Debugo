//
//  DGAFNetworkingRecord.h
//  Debugo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 把对象格式化成列表 / 详情里展示的文本，超长会截断。
FOUNDATION_EXPORT NSString *DGAFNetworkingPrettyText(id _Nullable object);
/// 把请求头或响应头格式化成多行文本。
FOUNDATION_EXPORT NSString *DGAFNetworkingHeaderText(NSDictionary * _Nullable headers);

/// 一条被拦截的网络请求。
@interface DGAFNetworkingRecord : NSObject

@property (nonatomic, copy) NSString *recordID;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, copy) NSString *requestHeaders;
@property (nonatomic, copy) NSString *requestBody;
@property (nonatomic, copy) NSString *responseHeaders;
@property (nonatomic, copy) NSString *responseBody;
@property (nonatomic, copy, nullable) NSString *errorText;

- (NSString *)timeText;
- (NSString *)durationText;
- (NSString *)statusText;
- (UIColor *)statusColor;
- (NSString *)detailText;

@end

NS_ASSUME_NONNULL_END
