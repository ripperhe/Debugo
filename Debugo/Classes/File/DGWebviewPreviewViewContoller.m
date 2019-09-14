//
//  DGWebviewPreviewViewContoller.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGWebviewPreviewViewContoller.h"
#import <WebKit/WebKit.h>
#import "DGCommon.h"

@interface DGWebviewPreviewViewContoller ()

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation DGWebviewPreviewViewContoller

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add share button
    dg_weakify(self)
    self.navigationItem.rightBarButtonItem = [[DGShareBarButtonItem alloc] initWithViewController:self shareFilePathsWhenClickedBlock:^NSArray<NSString *> * _Nonnull(DGShareBarButtonItem * _Nonnull item) {
        dg_strongify(self)
        return @[self.file.fileURL.path];
    }];

    [self webView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

#pragma mark - setter
- (void)setFile:(DGFile *)file {
    _file = file;
    self.title = file.displayName;
    [self processForDisplay];
}

#pragma mark - getter
- (WKWebView *)webView {
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] init];
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

#pragma mark - processing
- (void)processForDisplay {
    if (!self.file) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfURL:self.file.fileURL];
    if (!data) {
        return;
    }
    NSString *rawString = nil;
    
    // Prepare plist for display
    if (self.file.type == DGFileTypePLIST) {
        NSError *error;
        NSObject *plistObject = [NSPropertyListSerialization propertyListWithData:data
                                                  options:0
                                                   format:nil
                                                    error:&error];
        if (error) {
            NSLog(@"%@ %s error:%@", self, __func__, error);
        }else{
            NSString *plistDescription = plistObject.description;
            if (plistDescription.length) {
                // 解决中文乱码
                plistDescription = [NSString stringWithCString:[plistDescription cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
                rawString = plistDescription;
            }
        }
    }
    
    // Prepare json file for display
    if (self.file.type == DGFileTypeJSON) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"%@ %s error:%@", self, __func__, error);
        }
        if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
            NSError *error;
            id prettyJson = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
            if (error) {
                NSLog(@"%@ %s error:%@", self, __func__, error);
            }else{
                NSString *jsonString = [[NSString alloc] initWithData:prettyJson encoding:NSUTF8StringEncoding];
                // Unescape forward slashes
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
                if (jsonString.length) {
                    rawString = jsonString;
                }
            }
        }
    }
    
    // Default prepare for display
    if (!rawString) {
        rawString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    // Convert and display string
    NSString *convertedString = [self convertSpecialCharacters:rawString];
    if (convertedString.length) {
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='initial-scale=1.0, user-scalable=no'></head><body><pre>%@</pre></body></html>", convertedString];
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
}

// Make sure we convert HTML special characters
// Code from https://gist.github.com/mikesteele/70ae98d04fdc35cb1d5f
- (NSString *)convertSpecialCharacters:(NSString *)string {
    if (!string.length) {
        return nil;
    }
    NSString *newString = string;
    NSDictionary *char_dictionary = @{
                                      @"&amp;": @"&",
                                      @"&lt;": @"<",
                                      @"&gt;": @">",
                                      @"&quot;": @"\"",
                                      @"&apos;": @"'"
                                      };
    for (NSString *key in char_dictionary.allKeys) {
        NSString *value = [char_dictionary objectForKey:key];
        newString = [newString stringByReplacingOccurrencesOfString:key withString:value options:NSRegularExpressionSearch range:NSMakeRange(0, newString.length)];
    }
    return newString;
}

@end
