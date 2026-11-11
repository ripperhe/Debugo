//
//  DGLogBackViewController.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGLogBackViewController : UIViewController

/**安全边距，主要是针对有Navbar 以及 tabbar的*/
@property (nonatomic, assign) UIEdgeInsets safeInsets;

- (void)refreshHeight:(CGFloat)height;

- (void)dismissWithAnimation:(void (^)(void))completion;

@end
