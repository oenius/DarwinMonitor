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

      if(percent > 99.99f)
      {
        [weakSelf dump];
      }
    }];
    
    [self.cpuMonitor start];
    
     self.runloopMonitor = [[DMRunloopMonitor alloc]init];
    [self.runloopMonitor start];
    
    [[NSRunLoop currentRunLoop] run];
  }
}

- (void)dump
{
  NSLog(@"%@",[NSThread callStackSymbols]);
}

@end
