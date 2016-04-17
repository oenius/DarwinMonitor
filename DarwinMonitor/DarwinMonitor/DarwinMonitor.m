//
//  DarwinMonitor.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/8.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DarwinMonitor.h"

#import "DMCPUMonitor.h"
#import "DMRunloopMonitor.h"
#import "DMNetworkMonitor.h"
#import <stdlib.h>
#import <fcntl.h>
#import <errno.h>
#import <string.h>
#import <stdbool.h>
#include <pthread.h>
#include <mach/mach.h>
#import <dlfcn.h>

#import <sys/sysctl.h>
#import <sys/time.h>

#import <mach-o/dyld.h>
#include <execinfo.h>

#import <libkern/OSAtomic.h>

#import "ViewController.h"
#import <SVProgressHUD.h>


@interface DarwinMonitor()

@property (nonatomic, strong)NSThread *thread;
@property (nonatomic, strong)DMCPUMonitor *cpuMonitor;
@property (nonatomic, strong)DMRunloopMonitor *runloopMonitor;

@end

@implementation DarwinMonitor

+ (instancetype)monitor
{
  static DarwinMonitor *monitor;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    monitor = [[DarwinMonitor alloc]init];
  });
  return monitor;
}

- (instancetype)init
{
  self = [super init];
  if(self)
  {
    
  }
  return self;
}

- (void)start
{
  self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil];
  [self.thread start];
}

- (void)run
{
  @autoreleasepool
  {
    self.cpuMonitor = [[DMCPUMonitor alloc]init];
    
    __weak typeof(self) weakSelf = self;
    [self.cpuMonitor setCpuBlock:^(CGFloat percent) {
      if(percent > 59.f)
      {
        [weakSelf dump];
      }
    }];
    
    [self.cpuMonitor start];
    
     self.runloopMonitor = [[DMRunloopMonitor alloc]init];
    [self.runloopMonitor start];
    [self.runloopMonitor setHandleBadHappened:^{
      [weakSelf dump];
    }];
    
    [DMNetworkMonitor monitor];
    [[NSRunLoop currentRunLoop] run];
  }
}

- (void)dump
{
//   raise(SIGSEGV);
}

+ (NSArray *)backtrace
{
  void* callstack[128];
  int frames = backtrace(callstack, 128);
  char **strs = backtrace_symbols(callstack, frames);
  
  int i;
  NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
  for (i = 0;
       i < MIN(0 + 10, frames);
       ++i) {
    [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
  }
  free(strs);
  
  return backtrace;
}


- (void)setOptions:(DMMonitorOptions)options
{
  
}

@end
