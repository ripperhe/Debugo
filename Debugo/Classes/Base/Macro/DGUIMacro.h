//
//  DGUIMacro.h
//  Pods
//
//  Created by ripper on 2018/9/30.
//

#import <UIKit/UIKit.h>
#import "DGDevice.h"

#define kDGScreenW ([UIScreen mainScreen].bounds.size.width)
#define kDGScreenH ([UIScreen mainScreen].bounds.size.height)

#define kDGScreenMin MIN(kDGScreenW, kDGScreenH)
#define kDGScreenMax MAX(kDGScreenW, kDGScreenH)

#define kDGStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kDGBottomSafeMargin (([DGDevice currentDevice].isNotchUI) ? 34.0 : 0.0)

#define kDGHighlightColor [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0]

#define kDGImpactFeedback \
if (@available(iOS 10.0, *)) { \
UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium]; \
[feedBackGenertor impactOccurred]; \
}
