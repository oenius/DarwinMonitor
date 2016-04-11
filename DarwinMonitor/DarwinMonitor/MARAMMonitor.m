//
//  MARAMMonitor.m
//  YiJieDai
//
//  Created by YURI_JOU on 15/11/4.
//  Copyright © 2015年 oenius. All rights reserved.
//
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <UIKit/UIKit.h>

#import "MARAMMonitor.h"

@interface MARAMMonitor()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation MARAMMonitor

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    [self start];
  }
  return self;
}

- (void)start
{
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(handleRAM) userInfo:nil repeats:YES];
}

- (void)stop
{
  [self.timer invalidate];
  self.timer = nil;
}

- (void)handleRAM
{
  mach_port_t             port = mach_host_self();
  mach_msg_type_number_t  size = HOST_VM_INFO64_COUNT;
  vm_size_t               page = 4096;
  vm_statistics64_data_t  stat;
  
  if (host_statistics64(port, HOST_VM_INFO64, (host_info64_t)&stat, &size) != KERN_SUCCESS)
  {
    return;
  }
  
  NSInteger total =  (stat.active_count + stat.inactive_count + stat.wire_count) * page;
  if (self.ramBlock)
  {
    unsigned long long memory = [NSProcessInfo processInfo].physicalMemory;
    
    NSString *desc = [NSString stringWithFormat:@"%@ %.f %@",[self.class nearestMetric:total], (double)B_TO_MB(total)/B_TO_MB(memory) * 100,@"%"];
    self.ramBlock((CGFloat)total/memory * 100.f, desc);
  }
}

+ (NSString*)nearestMetric:(uint64_t)value
{
  static const uint64_t  B  = 0;
  static const uint64_t KB  = 1024;
  static const uint64_t MB  = KB * 1024;
  static const uint64_t GB  = MB * 1024;
  static const uint64_t TB  = GB * 1024;
  
  uint64_t absValue = llabs((long long)value);
  double metricValue;
  NSInteger fraction = 1;
  NSString *specifier = [NSString stringWithFormat:@"%%0.%ldf", (long)fraction];
  NSString *format;
  
  if (absValue >= B && absValue < KB)
  {
    metricValue = value;
    format = [NSString stringWithFormat:@"%@ B", specifier];
  }
  else if (absValue >= KB && absValue < MB)
  {
    metricValue = B_TO_KB(value);
    format = [NSString stringWithFormat:@"%@ KB", specifier];
  }
  else if (absValue >= MB && absValue < GB)
  {
    metricValue = B_TO_MB(value);
    format = [NSString stringWithFormat:@"%@ MB", specifier];
  }
  else if (absValue >= GB && absValue < TB)
  {
    metricValue = B_TO_GB(value);
    format = [NSString stringWithFormat:@"%@ GB", specifier];
  }
  else
  {
    metricValue = B_TO_TB(value);
    format = [NSString stringWithFormat:@"%@ TB", specifier];
  }
  
  return [NSString stringWithFormat:format, metricValue];
}

@end
