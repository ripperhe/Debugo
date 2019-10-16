//
//  DGDevice.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGDevice.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>

/**
 Reference:
 
 # 型号
 https://support.apple.com/en-us/HT201296
 https://www.theiphonewiki.com/wiki/Models
 https://ipsw.me/device-finder
 
 # 代码
 https://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk/1561920#1561920
 https://gist.github.com/Jaybles/1323251
 https://github.com/InderKumarRathore/DeviceUtil
 
 # 分辨率
 https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
 https://kangzubin.com/iphone-resolutions/
 
 */

static NSString * const kDGNameKey = @"kDGNameKey";
static NSString * const kDGTypeKey = @"kDGTypeKey";
static NSString * const kDGInchKey = @"kDGInchKey";

@implementation DGDevice

static DGDevice *_instance;
+ (instancetype)currentDevice {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
        // Default value
        _instance->_identifier = @"unknown";
        _instance->_name = @"unknown";
        _instance->_screenInch = @"unknown";
        _instance->_type = DGDeviceTypeUnknown;
        
        _instance->_simulatorIdentifier = @"unknown";
        _instance->_simulatorName = @"unknown";
        _instance->_simulatorScreenInch = @"unknown";
        _instance->_simulatorType = DGDeviceTypeUnknown;
        
        // Gets a string with the device model
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
        
        // Setup info
        if (platform.length) {
            NSDictionary *deviceModelDic = [self deviceModelDic];
            
            // iPhone
            _instance->_identifier = platform;
            NSDictionary *infoDic = [deviceModelDic objectForKey:platform];
            if (infoDic) {
                if ([infoDic objectForKey:kDGNameKey]) {
                    _instance->_name = [infoDic objectForKey:kDGNameKey];
                }
                if ([infoDic objectForKey:kDGTypeKey]) {
                    _instance->_type = [[infoDic objectForKey:kDGTypeKey] integerValue];
                }
                if ([infoDic objectForKey:kDGInchKey]) {
                    _instance->_screenInch = [infoDic objectForKey:kDGInchKey];
                }
            }
            
            // simulator
            if (_instance.type == DGDeviceTypeSimulator) {
                NSString *simulatorIdentifier = [NSProcessInfo processInfo].environment[@"SIMULATOR_MODEL_IDENTIFIER"];
                if (simulatorIdentifier.length) {
                    _instance->_simulatorIdentifier = simulatorIdentifier;
                    NSDictionary *simulatorInfoDic = [deviceModelDic objectForKey:simulatorIdentifier];
                    if (simulatorInfoDic) {
                        if ([simulatorInfoDic objectForKey:kDGNameKey]) {
                            _instance->_simulatorName = [simulatorInfoDic objectForKey:kDGNameKey];
                        }
                        if ([simulatorInfoDic objectForKey:kDGTypeKey]) {
                            _instance->_simulatorType = [[simulatorInfoDic objectForKey:kDGTypeKey] integerValue];
                        }
                        if ([simulatorInfoDic objectForKey:kDGInchKey]) {
                            _instance->_simulatorScreenInch = [simulatorInfoDic objectForKey:kDGInchKey];
                        }
                    }
                }
            }
        }
    });
    return _instance;
}

+ (NSDictionary *)deviceModelDic {
    return @{
             @"i386":@{ kDGNameKey:@"Simulator",   kDGTypeKey:@(DGDeviceTypeSimulator) },
             @"x86_64":@{ kDGNameKey:@"Simulator", kDGTypeKey:@(DGDeviceTypeSimulator) },
             
             @"iPhone1,1":@{ kDGNameKey:@"iPhone 2G" },
             @"iPhone1,2":@{ kDGNameKey:@"iPhone 3G" },
             @"iPhone2,1":@{ kDGNameKey:@"iPhone 3GS" },
             @"iPhone3,1":@{ kDGNameKey:@"iPhone 4 (GSM)",          kDGTypeKey:@(DGDeviceType_iPhone_4),       kDGInchKey:@"3.5",},
             @"iPhone3,2":@{ kDGNameKey:@"iPhone 4 (GSM/2012)",     kDGTypeKey:@(DGDeviceType_iPhone_4),       kDGInchKey:@"3.5" },
             @"iPhone3,3":@{ kDGNameKey:@"iPhone 4 (CDMA)",         kDGTypeKey:@(DGDeviceType_iPhone_4),       kDGInchKey:@"3.5" },
             @"iPhone4,1":@{ kDGNameKey:@"iPhone 4S",               kDGTypeKey:@(DGDeviceType_iPhone_4S),      kDGInchKey:@"3.5" },
             @"iPhone5,1":@{ kDGNameKey:@"iPhone 5 (GSM)",          kDGTypeKey:@(DGDeviceType_iPhone_5),       kDGInchKey:@"4.0" },
             @"iPhone5,2":@{ kDGNameKey:@"iPhone 5 (Global)",       kDGTypeKey:@(DGDeviceType_iPhone_5),       kDGInchKey:@"4.0" },
             @"iPhone5,3":@{ kDGNameKey:@"iPhone 5c (GSM)",         kDGTypeKey:@(DGDeviceType_iPhone_5c),      kDGInchKey:@"4.0" },
             @"iPhone5,4":@{ kDGNameKey:@"iPhone 5c (Global)",      kDGTypeKey:@(DGDeviceType_iPhone_5c),      kDGInchKey:@"4.0" },
             @"iPhone6,1":@{ kDGNameKey:@"iPhone 5s (GSM)",         kDGTypeKey:@(DGDeviceType_iPhone_5s),      kDGInchKey:@"4.0" },
             @"iPhone6,2":@{ kDGNameKey:@"iPhone 5s (Global)",      kDGTypeKey:@(DGDeviceType_iPhone_5s),      kDGInchKey:@"4.0" },
             @"iPhone7,2":@{ kDGNameKey:@"iPhone 6",                kDGTypeKey:@(DGDeviceType_iPhone_6),       kDGInchKey:@"4.7" },
             @"iPhone7,1":@{ kDGNameKey:@"iPhone 6 Plus",           kDGTypeKey:@(DGDeviceType_iPhone_6_Plus),  kDGInchKey:@"5.5" },
             @"iPhone8,1":@{ kDGNameKey:@"iPhone 6s",               kDGTypeKey:@(DGDeviceType_iPhone_6s),      kDGInchKey:@"4.7" },
             @"iPhone8,2":@{ kDGNameKey:@"iPhone 6s Plus",          kDGTypeKey:@(DGDeviceType_iPhone_6s_Plus), kDGInchKey:@"5.5" },
             @"iPhone8,4":@{ kDGNameKey:@"iPhone SE",               kDGTypeKey:@(DGDeviceType_iPhone_SE),      kDGInchKey:@"4.0" },
             @"iPhone9,1":@{ kDGNameKey:@"iPhone 7 (Global)",       kDGTypeKey:@(DGDeviceType_iPhone_7),       kDGInchKey:@"4.7" },
             @"iPhone9,3":@{ kDGNameKey:@"iPhone 7 (GSM)",          kDGTypeKey:@(DGDeviceType_iPhone_7),       kDGInchKey:@"4.7" },
             @"iPhone9,2":@{ kDGNameKey:@"iPhone 7 Plus (Global)",  kDGTypeKey:@(DGDeviceType_iPhone_7_Plus),  kDGInchKey:@"5.5" },
             @"iPhone9,4":@{ kDGNameKey:@"iPhone 7 Plus (GSM)",     kDGTypeKey:@(DGDeviceType_iPhone_7_Plus),  kDGInchKey:@"5.5" },
             @"iPhone10,1":@{ kDGNameKey:@"iPhone 8 (Global)",      kDGTypeKey:@(DGDeviceType_iPhone_8),       kDGInchKey:@"4.7" },
             @"iPhone10,4":@{ kDGNameKey:@"iPhone 8 (GSM)",         kDGTypeKey:@(DGDeviceType_iPhone_8),       kDGInchKey:@"4.7" },
             @"iPhone10,2":@{ kDGNameKey:@"iPhone 8 Plus (Global)", kDGTypeKey:@(DGDeviceType_iPhone_8_Plus),  kDGInchKey:@"5.5" },
             @"iPhone10,5":@{ kDGNameKey:@"iPhone 8 Plus (GSM)",    kDGTypeKey:@(DGDeviceType_iPhone_8_Plus),  kDGInchKey:@"5.5" },
             @"iPhone10,3":@{ kDGNameKey:@"iPhone X (Global)",      kDGTypeKey:@(DGDeviceType_iPhone_X),       kDGInchKey:@"5.8" },
             @"iPhone10,6":@{ kDGNameKey:@"iPhone X (GSM)",         kDGTypeKey:@(DGDeviceType_iPhone_X),       kDGInchKey:@"5.8" },
             @"iPhone11,8":@{ kDGNameKey:@"iPhone XR",              kDGTypeKey:@(DGDeviceType_iPhone_XR),      kDGInchKey:@"6.1" },
             @"iPhone11,2":@{ kDGNameKey:@"iPhone XS",              kDGTypeKey:@(DGDeviceType_iPhone_XS),      kDGInchKey:@"5.8" },
             @"iPhone11,4":@{ kDGNameKey:@"iPhone XS Max",          kDGTypeKey:@(DGDeviceType_iPhone_XS_Max),  kDGInchKey:@"6.5" },
             @"iPhone11,6":@{ kDGNameKey:@"iPhone XS Max (China)",  kDGTypeKey:@(DGDeviceType_iPhone_XS_Max),  kDGInchKey:@"6.5" },
             };
}

- (BOOL)isSimulator {
    return self.type == DGDeviceTypeSimulator;
}

- (BOOL)isNotch {
    DGDeviceType type = DGDeviceTypeUnknown;
    if ([self isSimulator]) {
        type = self.simulatorType;
    }else{
        type = self.type;
    }
    switch (type) {
        case DGDeviceType_iPhone_X:
        case DGDeviceType_iPhone_XR:
        case DGDeviceType_iPhone_XS:
        case DGDeviceType_iPhone_XS_Max:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)isNotchUI {
    // iPhone X/XS:     375pt * 812pt (@3x)
    // iPhone XS Max:   414pt * 896pt (@3x)
    // iPhone XR:       414pt * 896pt (@2x)
    CGFloat h = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (h == 812.0f || h == 896.0f) {
        return YES;
    }
    return NO;
}

@end
