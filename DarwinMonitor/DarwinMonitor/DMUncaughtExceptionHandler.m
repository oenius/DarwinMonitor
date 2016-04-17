//
//  DMUncaughtExceptionHandler.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/12.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMUncaughtExceptionHandler.h"
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



NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;

const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;

const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation DMUncaughtExceptionHandler

+ (NSArray *)backtrace
{
  void* callstack[128];
  int frames = backtrace(callstack, 128);
  char **strs = backtrace_symbols(callstack, frames);
  int i;
  
  NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
  
  for (
       i = UncaughtExceptionHandlerSkipAddressCount;
       i < UncaughtExceptionHandlerSkipAddressCount +
       UncaughtExceptionHandlerReportAddressCount;
       i++)
    
  {
    [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
  }
  
  free(strs);
  
  return backtrace;
  
}


- (void)handleException:(NSException *)exception
{
  CFRunLoopRef runLoop = CFRunLoopGetCurrent();
  CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
  
  while (!dismissed)
  {
    for (NSString *mode in (__bridge NSArray *)allModes)
    {
      CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
    }
    
  }
  CFRelease(allModes);
  
  NSSetUncaughtExceptionHandler(NULL);
  
  signal(SIGABRT, SIG_DFL);
  signal(SIGILL, SIG_DFL);
  signal(SIGSEGV, SIG_DFL);
  signal(SIGFPE, SIG_DFL);
  signal(SIGBUS, SIG_DFL);
  signal(SIGPIPE, SIG_DFL);
  
  if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
  {
    kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
  }
  else
  {
    [exception raise];
  }
}



@end
