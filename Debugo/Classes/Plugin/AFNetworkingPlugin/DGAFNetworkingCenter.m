//
//  DGAFNetworkingCenter.m
//  Debugo
//

#import "DGAFNetworkingCenter.h"
#import <objc/runtime.h>

NSNotificationName const DGAFNetworkingRecordsDidChangeNotification = @"DGAFNetworkingRecordsDidChangeNotification";

static NSString * const DGAFNetworkingTaskDidResumeNotification = @"com.alamofire.networking.task.resume";
static NSString * const DGAFNetworkingTaskDidCompleteNotification = @"com.alamofire.networking.task.complete";
static NSString * const DGAFNetworkingTaskDidCompleteSerializedResponseKey = @"com.alamofire.networking.task.complete.serializedresponse";
static NSString * const DGAFNetworkingTaskDidCompleteResponseDataKey = @"com.alamofire.networking.complete.finish.responsedata";
static NSString * const DGAFNetworkingTaskDidCompleteErrorKey = @"com.alamofire.networking.task.complete.error";
static NSString * const DGAFNetworkingTaskDidCompleteSessionTaskMetrics = @"com.alamofire.networking.complete.sessiontaskmetrics";

static const void *kDGAFNetworkingRecordKey = &kDGAFNetworkingRecordKey;
static const void *kDGAFNetworkingRequestBodyKey = &kDGAFNetworkingRequestBodyKey;
static const NSUInteger kDGAFNetworkingRecordLimit = 200;

typedef NSURLSessionDataTask *(*DGAFNetworkingDataTaskIMP)(id, SEL, NSURLRequest *, id, id, id);
static DGAFNetworkingDataTaskIMP dg_originalDataTaskIMP = NULL;

/// NSURLSession 创建任务后，HTTPBody 经常会被收成 HTTPBodyStream。
/// 流只能读一次，所以在 dataTask 创建前把 body 留一份。
static NSData *DGAFNetworkingSnapshotRequestBody(NSURLRequest *request) {
    if (request.HTTPBody.length > 0) {
        return request.HTTPBody;
    }
    NSInputStream *stream = request.HTTPBodyStream;
    if (!stream || ![request isKindOfClass:NSMutableURLRequest.class]) {
        return nil;
    }

    [stream open];
    if (stream.streamStatus == NSStreamStatusError || stream.streamStatus == NSStreamStatusNotOpen) {
        return nil;
    }

    NSMutableData *data = [NSMutableData data];
    uint8_t buffer[16 * 1024];
    while (1) {
        NSInteger count = [stream read:buffer maxLength:sizeof(buffer)];
        if (count <= 0) {
            break;
        }
        [data appendBytes:buffer length:(NSUInteger)count];
    }
    [stream close];
    [(NSMutableURLRequest *)request setHTTPBodyStream:[[NSInputStream alloc] initWithData:data]];
    return data;
}

static NSString *DGAFNetworkingRequestBodyText(NSURLSessionTask *task) {
    NSData *body = objc_getAssociatedObject(task, kDGAFNetworkingRequestBodyKey);
    if (![body isKindOfClass:NSData.class] || body.length == 0) {
        body = task.originalRequest.HTTPBody;
    }
    if (body.length == 0) {
        body = task.currentRequest.HTTPBody;
    }
    if (body.length > 0) {
        return DGAFNetworkingPrettyText(body);
    }
    if (task.originalRequest.HTTPBodyStream || task.currentRequest.HTTPBodyStream) {
        return @"(body stream，未读取以免消费请求体)";
    }
    return @"";
}

@interface DGAFNetworkingCenter ()

@property (nonatomic, strong) NSHashTable *managers;
@property (nonatomic, strong) NSMutableArray<DGAFNetworkingRecord *> *records;
@property (nonatomic, assign) BOOL observing;

- (BOOL)dg_isMonitoringManager:(id)manager;

@end

static NSURLSessionDataTask *DGAFNetworkingSwizzledDataTask(id self, SEL _cmd, NSURLRequest *request, id uploadProgress, id downloadProgress, id completionHandler) {
    NSData *body = nil;
    if ([DGAFNetworkingCenter.sharedCenter dg_isMonitoringManager:self]) {
        body = DGAFNetworkingSnapshotRequestBody(request);
    }
    NSURLSessionDataTask *task = dg_originalDataTaskIMP ? dg_originalDataTaskIMP(self, _cmd, request, uploadProgress, downloadProgress, completionHandler) : nil;
    if (task && body.length > 0) {
        objc_setAssociatedObject(task, kDGAFNetworkingRequestBodyKey, body, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return task;
}

static void DGAFNetworkingInstallDataTaskHook(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"AFURLSessionManager");
        SEL sel = @selector(dataTaskWithRequest:uploadProgress:downloadProgress:completionHandler:);
        Method method = class_getInstanceMethod(cls, sel);
        if (!method) {
            return;
        }
        dg_originalDataTaskIMP = (DGAFNetworkingDataTaskIMP)method_setImplementation(method, (IMP)DGAFNetworkingSwizzledDataTask);
    });
}

@implementation DGAFNetworkingCenter

+ (instancetype)sharedCenter {
    static DGAFNetworkingCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[DGAFNetworkingCenter alloc] init];
    });
    return center;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _managers = [NSHashTable weakObjectsHashTable];
        _records = [NSMutableArray array];
        _listModules = DGAFNetworkingListModuleAll;
    }
    return self;
}

- (void)monitorSessionManager:(AFURLSessionManager *)sessionManager {
    Class managerClass = NSClassFromString(@"AFURLSessionManager");
    id manager = sessionManager;
    if (!managerClass || ![manager isKindOfClass:managerClass]) {
        return;
    }
    DGAFNetworkingInstallDataTaskHook();
    @synchronized (self.managers) {
        [self.managers addObject:manager];
    }
    if (NSThread.isMainThread) {
        [self startObservingIfNeeded];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startObservingIfNeeded];
        });
    }
}

- (BOOL)dg_isMonitoringManager:(id)manager {
    if (!manager) {
        return NO;
    }
    @synchronized (self.managers) {
        return [self.managers containsObject:manager];
    }
}

- (NSArray<DGAFNetworkingRecord *> *)allRecords {
    if (!NSThread.isMainThread) {
        __block NSArray<DGAFNetworkingRecord *> *records = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            records = [self.records copy];
        });
        return records;
    }
    return [self.records copy];
}

- (void)setListModules:(DGAFNetworkingListModule)listModules {
    if (_listModules == listModules) {
        return;
    }
    _listModules = listModules;
    if (NSThread.isMainThread) {
        [self postChange];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postChange];
        });
    }
}

- (void)clearRecords {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.records removeAllObjects];
        [self postChange];
    });
}

#pragma mark - Observe

- (void)startObservingIfNeeded {
    if (self.observing) {
        return;
    }
    self.observing = YES;
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center addObserver:self selector:@selector(taskDidResume:) name:DGAFNetworkingTaskDidResumeNotification object:nil];
    [center addObserver:self selector:@selector(taskDidComplete:) name:DGAFNetworkingTaskDidCompleteNotification object:nil];
}

- (nullable id)managerForTask:(NSURLSessionTask *)task {
    if (![task isKindOfClass:NSURLSessionTask.class]) {
        return nil;
    }
    NSString *description = task.taskDescription;
    if (description.length == 0) {
        return nil;
    }
    @synchronized (self.managers) {
        for (id manager in self.managers) {
            NSString *expected = [NSString stringWithFormat:@"%p", manager];
            if ([description isEqualToString:expected]) {
                return manager;
            }
        }
    }
    return nil;
}

- (void)taskDidResume:(NSNotification *)notification {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self taskDidResume:notification];
        });
        return;
    }
    NSURLSessionTask *task = notification.object;
    if (![self managerForTask:task]) {
        return;
    }
    if (objc_getAssociatedObject(task, kDGAFNetworkingRecordKey)) {
        return;
    }
    DGAFNetworkingRecord *record = [self recordForTask:task];
    objc_setAssociatedObject(task, kDGAFNetworkingRecordKey, record, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self insertRecord:record];
}

- (void)taskDidComplete:(NSNotification *)notification {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self taskDidComplete:notification];
        });
        return;
    }
    NSURLSessionTask *task = notification.object;
    if (![self managerForTask:task]) {
        return;
    }
    DGAFNetworkingRecord *record = objc_getAssociatedObject(task, kDGAFNetworkingRecordKey);
    BOOL inserted = NO;
    if (!record) {
        record = [self recordForTask:task];
        objc_setAssociatedObject(task, kDGAFNetworkingRecordKey, record, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        inserted = YES;
    }
    [self fillRecord:record task:task userInfo:notification.userInfo];
    if (inserted || ![self.records containsObject:record]) {
        [self insertRecord:record];
    } else {
        [self postChange];
    }
}

- (DGAFNetworkingRecord *)recordForTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest ?: task.originalRequest;
    DGAFNetworkingRecord *record = [[DGAFNetworkingRecord alloc] init];
    record.recordID = [NSString stringWithFormat:@"%p-%lu", task, (unsigned long)task.taskIdentifier];
    record.startDate = [NSDate date];
    record.method = request.HTTPMethod.uppercaseString ?: @"";
    record.URLString = request.URL.absoluteString ?: @"";
    record.requestHeaders = DGAFNetworkingHeaderText(request.allHTTPHeaderFields);
    record.requestBody = DGAFNetworkingRequestBodyText(task);
    return record;
}

- (void)fillRecord:(DGAFNetworkingRecord *)record task:(NSURLSessionTask *)task userInfo:(NSDictionary *)userInfo {
    NSURLRequest *request = task.currentRequest ?: task.originalRequest;
    if (request.URL.absoluteString.length) {
        record.URLString = request.URL.absoluteString;
    }
    if (request.HTTPMethod.length) {
        record.method = request.HTTPMethod.uppercaseString;
    }
    if (request.allHTTPHeaderFields.count) {
        record.requestHeaders = DGAFNetworkingHeaderText(request.allHTTPHeaderFields);
    }
    NSString *requestBody = DGAFNetworkingRequestBodyText(task);
    if (requestBody.length > 0) {
        record.requestBody = requestBody;
    }

    if ([task.response isKindOfClass:NSHTTPURLResponse.class]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        record.statusCode = response.statusCode;
        record.responseHeaders = DGAFNetworkingHeaderText(response.allHeaderFields);
    }

    if (@available(iOS 10.0, *)) {
        NSURLSessionTaskMetrics *metrics = userInfo[DGAFNetworkingTaskDidCompleteSessionTaskMetrics];
        if ([metrics isKindOfClass:NSURLSessionTaskMetrics.class] && metrics.taskInterval.duration > 0) {
            record.duration = metrics.taskInterval.duration;
        } else if (record.startDate) {
            record.duration = [[NSDate date] timeIntervalSinceDate:record.startDate];
        }
    } else if (record.startDate) {
        record.duration = [[NSDate date] timeIntervalSinceDate:record.startDate];
    }

    id serialized = userInfo[DGAFNetworkingTaskDidCompleteSerializedResponseKey];
    NSData *data = userInfo[DGAFNetworkingTaskDidCompleteResponseDataKey];
    if (serialized) {
        record.responseBody = DGAFNetworkingPrettyText(serialized);
    } else if ([data isKindOfClass:NSData.class]) {
        record.responseBody = DGAFNetworkingPrettyText(data);
    } else {
        record.responseBody = @"";
    }

    NSError *error = userInfo[DGAFNetworkingTaskDidCompleteErrorKey];
    record.errorText = [error isKindOfClass:NSError.class] ? error.localizedDescription : nil;
    record.finished = YES;
}

- (void)insertRecord:(DGAFNetworkingRecord *)record {
    [self.records insertObject:record atIndex:0];
    if (self.records.count > kDGAFNetworkingRecordLimit) {
        [self.records removeObjectsInRange:NSMakeRange(kDGAFNetworkingRecordLimit, self.records.count - kDGAFNetworkingRecordLimit)];
    }
    [self postChange];
}

- (void)postChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:DGAFNetworkingRecordsDidChangeNotification object:self];
}

@end
