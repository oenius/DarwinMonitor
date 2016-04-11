//
//  DMDumper.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/11.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMDumper.h"

@implementation DMDumper

+ (instancetype)dumper
{
  static DMDumper *dumper;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dumper = [[self.class alloc]init];
  });
  return dumper;
}

@end
