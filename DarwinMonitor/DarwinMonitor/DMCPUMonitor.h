//
//  MACPUMonitor.h
//  YiJieDai
//
//  Created by YURI_JOU on 15/11/3.
//  Copyright © 2015年 oenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMCPUMonitor : NSObject

@property (nonatomic, copy) void(^cpuBlock)(CGFloat);

- (void)start;
- (void)stop;

@end
