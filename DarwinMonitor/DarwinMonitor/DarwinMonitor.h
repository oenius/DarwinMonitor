//
//  DarwinMonitor.h
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/8.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, DMMonitorOptions) {
  DMCPUActivityMonitor = (1UL << 0),
  DMRAMActivityMonitor = (1UL << 1),
  DMFPSActivityMonitor = (1UL << 2),
  
  DMBatteryActivityMonitor = (1UL << 5),
  DMNetworkActivityMonitor = (1UL << 6),
  DMRunloopActivityMonitor = (1UL << 7),
  
  DMAllActivitiesMonitor = 0x0FFFFFFFU
};

@interface DarwinMonitor : NSObject

@property(nonatomic, assign)DMMonitorOptions options;

+ (instancetype)monitor;

- (void)start;

@end
