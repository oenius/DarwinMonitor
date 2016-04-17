//
//  ViewController.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/8.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <stdlib.h>
#import <fcntl.h>
#import <errno.h>
#import <string.h>
#import <stdbool.h>
#include <pthread.h>

#import <dlfcn.h>

#import <sys/sysctl.h>
#import <sys/time.h>

#import <mach-o/dyld.h>
#include <execinfo.h>

#import <libkern/OSAtomic.h>

#import "ViewController.h"
#import "DarwinMonitor.h"

#import "DMDumper.h"
#import <SVProgressHUD.h>
#import "KSSystemInfo.h"
#import "DMInterface.h"

@interface ViewController ()

@property   DMInterface *interface;


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[DarwinMonitor monitor]start];
  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
  button.backgroundColor = [UIColor redColor];
  [button setTitle:@"Click ME" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(handleClick) forControlEvents:UIControlEventTouchUpInside];
  button.center = self.view.center;
  [self.view addSubview:button];
  
  UIButton *abutton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
  abutton.backgroundColor = [UIColor blueColor];
  [abutton setTitle:@"Click ViewController" forState:UIControlStateNormal];
  [abutton addTarget:self action:@selector(handleAnthor) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:abutton];
  maint = pthread_from_mach_thread_np(pthread_main_np());
  [self threadMain];
  
  self.interface = [[DMInterface alloc]init];
  
  NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
  id task = [[NSURLSession sharedSession]dataTaskWithURL:url];
  [task resume];
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


void dump(int sig_no)
{
  NSLog(@"in handle er");
}

void signalHandler(int sig, siginfo_t* info, void* context)
{
  NSLog(@"in handle er");
}

- (void)handleClick
{

    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@",[KSSystemInfo systemInfo]]];
  
}

- (void)handleAnthor
{
  UIViewController *controller = [[UIViewController alloc]init];
  controller.view.backgroundColor = [UIColor orangeColor];
  [self presentViewController:controller animated:YES completion:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  

}

- (void)threadMain
{
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];

}

@end
//