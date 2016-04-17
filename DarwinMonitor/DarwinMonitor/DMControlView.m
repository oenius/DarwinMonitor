//
//  DMControlView.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/13.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMControlView.h"

@implementation DMControlView

- (void)setControlsHidden:(BOOL)hidden
{
  for(UIButton *button in self.colletions)
  {
    [button setHidden:hidden];
  }
}

- (IBAction)onClicked:(UIButton *)button
{
  if(self.handleMenu) self.handleMenu(0);
}

@end
