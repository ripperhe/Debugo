//
//  DGAlamofireCenter.m
//  Debugo
//

#import "DGAlamofireCenter.h"
#import <objc/message.h>
#import <objc/runtime.h>

NSNotificationName const DGAlamofireRecordsDidChangeNotification = @"DGAlamofireRecordsDidChangeNotification";

static const NSUInteger kDGAlamofireRecordLimit = 200;

@interface DGAlamofireCenter ()

@property (nonatomic, strong) NSHashTable *sessions;
@property (nonatomic, strong) NSMutableArray<DGAFNetworkingRecord *> *records;

@end

@implementation DGAlamofireCenter

+ (instancetype)sharedCenter {
    static DGAlamofireCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self alloc] init];
    });
    return center;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessions = [NSHashTable weakObjectsHashTable];
        _records = [NSMutableArray array];
        _listModules = DGAFNetworkingListModuleAll;
    }
    return self;
}

- (void)monitorSession:(id)session {
    if (!session) {
        return;
    }
    @synchronized (self.sessions) {
        [self.sessions addObject:session];
    }
    [self startHookIfNeeded];
}

- (BOOL)isMonitoringSession:(id)session {
    if (!session) {
        return NO;
    }
    @synchronized (self.sessions) {
        return [self.sessions containsObject:session];
    }
}

- (void)startHookIfNeeded {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class hook = NSClassFromString(@"DGAlamofireSessionHook");
        SEL selector = NSSelectorFromString(@"startObserving");
        if (hook && [hook respondsToSelector:selector]) {
            ((void (*)(id, SEL))objc_msgSend)(hook, selector);
        }
    });
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
    [self runOnMain:^{
        [self postChange];
    }];
}

- (void)clearRecords {
    [self runOnMain:^{
        [self.records removeAllObjects];
        [self postChange];
    }];
}

- (void)upsertRecord:(DGAFNetworkingRecord *)record {
    if (!record.recordID.length) {
        return;
    }
    [self runOnMain:^{
        NSUInteger index = [self.records indexOfObjectPassingTest:^BOOL(DGAFNetworkingRecord *obj, NSUInteger idx, BOOL *stop) {
            return [obj.recordID isEqualToString:record.recordID];
        }];
        if (index == NSNotFound) {
            [self.records insertObject:record atIndex:0];
            if (self.records.count > kDGAlamofireRecordLimit) {
                [self.records removeObjectsInRange:NSMakeRange(kDGAlamofireRecordLimit, self.records.count - kDGAlamofireRecordLimit)];
            }
        } else {
            DGAFNetworkingRecord *existing = self.records[index];
            NSDate *startDate = existing.startDate;
            existing.duration = record.duration;
            existing.method = record.method;
            existing.URLString = record.URLString;
            existing.statusCode = record.statusCode;
            existing.finished = record.isFinished;
            existing.requestHeaders = record.requestHeaders;
            existing.requestBody = record.requestBody;
            existing.responseHeaders = record.responseHeaders;
            existing.responseBody = record.responseBody;
            existing.errorText = record.errorText;
            if (record.startDate && (!startDate || [record.startDate compare:startDate] == NSOrderedAscending)) {
                existing.startDate = record.startDate;
            }
        }
        [self postChange];
    }];
}

- (void)runOnMain:(void (^)(void))block {
    if (NSThread.isMainThread) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)postChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:DGAlamofireRecordsDidChangeNotification object:self];
}

@end
