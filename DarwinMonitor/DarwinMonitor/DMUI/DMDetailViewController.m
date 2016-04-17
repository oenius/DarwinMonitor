//
//  DMDetailViewController.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/15.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMDetailViewController.h"

@interface DMDetailViewController ()

@property (nonatomic, weak)IBOutlet UILabel *detailLabel;
@property (nonatomic, weak)IBOutlet UILabel *detailLabel2222;

@end

@implementation DMDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
 
}

- (void)setDetail:(NSString *)detail
{

  self.detailLabel.text = detail;
  _detail = detail;
}

@end
