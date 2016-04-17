//
//  DMRunloopMonitor.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/11.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMRunloopMonitor.h"

static NSTimeInterval interval;

@interface DMRunloopMonitor()

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL runloopBegin;

@end

@implementation DMRunloopMonitor

- (instancetype)init
{
  self = [super init];
  if(self)
  {
    static CFAbsoluteTime startTime;
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, (kCFRunLoopAllActivities), YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity)
                                                                       {
                                                                         if(activity & kCFRunLoopBeforeWaiting)
                                                                         {
                                                                           _runloopBegin = NO;
                                                                         }
                                                                         
                                                                         if(activity & kCFRunLoopAfterWaiting)
                                                                         {
                                                                           _runloopBegin = YES;
                                                                         }
                                                                         
                                                                         if(activity & kCFRunLoopExit)
                                                                         {
                                                                           _runloopBegin = NO;
                                                                         }
                                                                         
                                                                       });
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
  }
  return self;
}

- (void)start
{
  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleCheckInterval) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)handleCheckInterval
{
  if(_runloopBegin)
  {
    interval = interval + .1;
    
    if(interval > 2)
    {
      NSLog(@"bad bad happed");
      if(self.handleBadHappened) self.handleBadHappened();
      _runloopBegin = NO;
    }
    
  }
}

@end
