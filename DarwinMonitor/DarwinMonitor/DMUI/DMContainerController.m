//
//  DMContainerController.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/14.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMContainerController.h"

@interface DMContainerController()

@property (nonatomic, weak)IBOutlet UIView *contentainerView;
@property (nonatomic, weak)IBOutlet UIView *bottomMenu;

@property (nonatomic, strong)NSArray *constraintsV;

@property (nonatomic, strong)UIViewController *contentController;
@property (nonatomic, assign)BOOL expended;

@end

@implementation DMContainerController

- (void)setContentController:(UIViewController *)contentController
{
  [self.contentController removeFromParentViewController];
  [self.contentController.view removeFromSuperview];
  
  UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:contentController];
  [navigationController setNavigationBarHidden:YES];
  
  [self.contentainerView addSubview:navigationController.view];
  [self addChildViewController:navigationController];
  
  UIView *view = navigationController.view;
  UIView *menu = self.bottomMenu;
  
  NSDictionary *viewsDictionary = @{@"view":view,@"menu":menu};
  
  NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-[menu(45)]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewsDictionary];
  
  NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewsDictionary];
  self.constraintsV = constraint_V;
  [self.view addConstraints:constraint_H];
  [self.view addConstraints:constraint_V];
  
  _contentController = contentController;
}

- (IBAction)handleExpended:(id)sender
{
  if(self.handleExpended)
  {
      _expended = !_expended;
    self.handleExpended(_expended);
  }
}


@end
