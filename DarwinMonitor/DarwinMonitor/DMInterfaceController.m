//
//  DMInterfaceController.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/13.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMInterfaceController.h"
#import "DMContainerController.h"

#import "UIView+DMExtra.h"
#import "DMControlView.h"

#import "DMNetworkController.h"

#define DM_TOUCH_WIDTH   60

@interface DMInterfaceController ()

@property (nonatomic, strong)UIImageView *assistantTouch;
@property (nonatomic, strong)DMControlView *assistantView;
@property (nonatomic, strong)DMContainerController *containerController;
@property (nonatomic, assign)CGPoint lastAssistantPoint;

@property (nonatomic, assign)BOOL assistantExpended;

@end

@implementation DMInterfaceController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor redColor];
 
  self.containerController.view.backgroundColor = [UIColor blackColor];

  [self.view addSubview:self.containerController.view];
  [self addChildViewController:self.containerController];
   NSArray *constraintsV = [self layoutContainerView];
  
  [self.containerController setHandleExpended:^(BOOL expended) {
    [self.view removeConstraints:constraintsV];
    
    UIView *view = self.containerController.view;
    NSDictionary *viewsDictionary = @{@"view":view,};
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    [self.view addConstraints:constraint_V];
    [UIView animateWithDuration:0.25 animations:^{
      [self.view layoutIfNeeded];
    }];
    
  }];
  
  self.assistantView.frame = CGRectMake(100, 50, DM_TOUCH_WIDTH, DM_TOUCH_WIDTH);
  [self.view addSubview:self.assistantView];
  
  [self.assistantView setControlsHidden:YES];
  __weak typeof(self) weakSelf = self;
  [self.assistantView setHandleMenu:^(NSInteger pos) {
    DMNetworkController *controller = [[DMNetworkController alloc]init];
    [weakSelf.containerController setContentController:controller];
  }];
}

- (NSArray *)layoutContainerView
{
  UIView *view = self.containerController.view;
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  
  NSDictionary *viewsDictionary = @{@"view":view,};
  
  NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(300)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewsDictionary];
  
  NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewsDictionary];
  
  [self.view addConstraints:constraint_H];
  [self.view addConstraints:constraint_V];
  [UIView animateWithDuration:0.25 animations:^{
    [self.view layoutIfNeeded];
  }];
  return constraint_V;
}

- (DMContainerController *)containerController
{
  if(!_containerController)
  {
    DMContainerController *controller = [[UIStoryboard storyboardWithName:@"DarwinMonitor" bundle:nil]instantiateViewControllerWithIdentifier:@"kContainerController"];
    
    _containerController = controller;
  }
  return _containerController;
}

- (DMControlView *)assistantView
{
  if(!_assistantView)
  {
    DMControlView *view = [UIView loadClass:[DMControlView class] from:@"DarwinMonitor"];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.67];
    view.layer.cornerRadius = 14.0f;
    view.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"icon_assistant_touch.png"]];
    imageView.contentMode = UIViewContentModeScaleToFill;

    imageView.frame = CGRectMake(8, 8, 44, 44);
    self.assistantTouch = imageView;
    
    [view addSubview:imageView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:tap];
    
    _assistantView = view;
  }
  return _assistantView;
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
  if(!self.assistantExpended)
  {
    self.assistantTouch.hidden = YES;
    [self.assistantView setControlsHidden:NO];
    [UIView animateWithDuration:0.25 animations:^{
      self.lastAssistantPoint = self.assistantView.center;
      CGFloat width = CGRectGetWidth(self.view.frame) - 120;
      [self.assistantView setWidth:width];
      [self.assistantView setHeight:width];
      
      self.assistantView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
      self.assistantExpended = YES;
    }];
  }
  else
  {
    [self.assistantView setControlsHidden:YES];
    [UIView animateWithDuration:0.25 animations:^{
      [self.assistantView setWidth:DM_TOUCH_WIDTH];
      [self.assistantView setHeight:DM_TOUCH_WIDTH];
      self.assistantView.center = self.lastAssistantPoint;
      self.assistantExpended = NO;
    } completion:^(BOOL finished) {
      if(finished) self.assistantTouch.hidden = NO;
    }];
    
  }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
  if(self.assistantExpended) return;
  CGPoint point = [pan locationInView:self.view];
  self.assistantView.center = point;
  
  if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled)
  {
    [self positionAssistantView:point];
  }
}

- (void)positionAssistantView:(CGPoint)point
{
  BOOL positioned = NO;
  if(point.y < DM_TOUCH_WIDTH)
  {
    [UIView animateWithDuration:0.2 animations:^{
      [self.assistantView setY:0];
    }];
    positioned = YES;
  }
  
  if(point.y > CGRectGetHeight(self.view.frame) - DM_TOUCH_WIDTH)
  {
    [UIView animateWithDuration:0.2 animations:^{
      [self.assistantView setY:CGRectGetHeight(self.view.frame) - DM_TOUCH_WIDTH];
    }];
    positioned = YES;
  }
  
  if(!positioned)
  {
    if(point.x < CGRectGetWidth(self.view.frame) / 2.f)
    {
      [UIView animateWithDuration:0.2 animations:^{
        [self.assistantView setX:0];
      }];
    }
    else
    {
      [UIView animateWithDuration:0.2 animations:^{
        [self.assistantView setX:(CGRectGetWidth(self.view.frame) - DM_TOUCH_WIDTH)];
      }];
    }
  }
}

@end
