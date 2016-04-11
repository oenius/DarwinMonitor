//
//  MAFPSMonitor.m
//  YiJieDai
//
//  Created by YURI_JOU on 15/11/2.
//  Copyright © 2015年 oenius. All rights reserved.
//

#import "MAFPSMonitor.h"
#import <UIKit/UIKit.h>

@interface MAFPSMonitor()

@property (nonatomic, strong)CADisplayLink *displayLink;

@property (nonatomic, assign)NSTimeInterval lastTimeStamp;
@property (nonatomic, assign)NSTimeInterval totalTimeStamp;
@property (nonatomic, assign)NSTimeInterval totalFrames;

@end

@implementation MAFPSMonitor

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleFPS)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.displayLink setPaused:NO];
  }
  return self;
}

- (void)handleFPS
{
  if (!self.lastTimeStamp)
  {
    self.lastTimeStamp = self.displayLink.timestamp;
  }
  NSTimeInterval interval = self.displayLink.timestamp - self.lastTimeStamp;
  self.totalTimeStamp += interval;
  ++self.totalFrames;
  
//  realtime calc
//  CGFloat fps = round(1.f / (CGFloat)interval) ;
  
  if (self.totalTimeStamp > 1)
  {
    self.fpsBlock(self.totalFrames);
    self.totalFrames = 0;
    self.totalTimeStamp = 0;
  }

  self.lastTimeStamp = self.displayLink.timestamp;
}

@end
