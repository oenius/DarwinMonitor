//
//  DMInterface.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/13.
//  Copyright © 2016年 oenius. All rights reserved.
//



#import <UIKit/UIKit.h>

#import "DMInterface.h"
#import "DMInterfaceController.h"

@interface DMInterface()

@property (nonatomic, strong)UIWindow *window;


@end

@implementation DMInterface

- (instancetype)init
{
  self = [super init];
  if(self)
  {
    [self.window makeKeyAndVisible];
  }
  return self;
}

- (UIWindow *)window
{
  if(!_window)
  {
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor blackColor];
    window.rootViewController = [[DMInterfaceController alloc]init];
    _window = window;
  }
  return _window;
}


@end
