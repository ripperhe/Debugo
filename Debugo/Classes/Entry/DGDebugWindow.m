//
//  DGDebugWindow.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGDebugWindow.h"

@implementation DGDebugWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        DGDebugViewController *debugVC = [[DGDebugViewController alloc] init];
        _debugViewController = debugVC;
        self.name = @"Debug Window";
        self.rootViewController = debugVC;
        self.windowLevel = 1999999;
        // 防止 navigationbar 为 translucent 时，有黑色阴影
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
