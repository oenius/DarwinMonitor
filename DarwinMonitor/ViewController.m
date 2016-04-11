//
//  ViewController.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/8.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "ViewController.h"
#import "DarwinMonitor.h"

@interface ViewController ()


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
  
  [self threadMain];
}

- (void)handleClick
{
  NSInteger pos;
  
  while (YES) {
    
    ++pos;

  }
  
  
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
