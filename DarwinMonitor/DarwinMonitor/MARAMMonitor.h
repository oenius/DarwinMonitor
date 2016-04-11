//
//  MARAMMonitor.h
//  YiJieDai
//
//  Created by YURI_JOU on 15/11/4.
//  Copyright © 2015年 oenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MARAMMonitor : NSObject
#define B_TO_KB(a)      ((a) / 1024.0)
#define B_TO_MB(a)      (B_TO_KB(a) / 1024.0)
#define B_TO_GB(a)      (B_TO_MB(a) / 1024.0)
#define B_TO_TB(a)      (B_TO_GB(a) / 1024.0)
#define KB_TO_B(a)      ((a) * 1024.0)
#define MB_TO_B(a)      (KB_TO_B(a) * 1024.0)
#define GB_TO_B(a)      (MB_TO_B(a) * 1024.0)
#define TB_TO_B(a)      (GB_TO_B(a) * 1024.0)

@property (nonatomic, copy) void(^ramBlock)(NSInteger,NSString *);

- (void)start;
- (void)stop;

+ (NSString*)nearestMetric:(uint64_t)value;

@end
