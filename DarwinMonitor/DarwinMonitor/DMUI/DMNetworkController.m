//
//  DMNetworkController.m
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/14.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "DMNetworkController.h"
#import "DarwinMonitor.h"
#import "DMNetworkMonitor.h"
#import "NSDate+DMExtra.h"
#import "DMDetailViewController.h"

@interface DMNetworkModel : NSObject

@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *statusInfo;

@end

@implementation DMNetworkModel

- (BOOL)isEqual:(DMNetworkModel *)object
{
  if([self.url isEqual:object.url] && [self.statusInfo isEqual:object.statusInfo])
  {
    return YES;
  }
  return NO;
}

@end

@interface DMNetworkController()
<
DMPrintableDelegate
>

@property (nonatomic, strong) NSMutableArray *networkTimeLine;
@property (nonatomic, strong) NSMutableDictionary *networkTimeLineMappings;

@end

@implementation DMNetworkController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.tableFooterView = [[UIView alloc]init];
  [DMNetworkMonitor monitor].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
  id task = [[NSURLSession sharedSession]dataTaskWithURL:url];
  [task resume];
}

- (NSMutableArray *)networkTimeLine
{
  if(!_networkTimeLine)
  {
    _networkTimeLine = [@[] mutableCopy];
  }
  
  return _networkTimeLine;
}

- (NSMutableDictionary *)networkTimeLineMappings
{
  if(!_networkTimeLineMappings)
  {
    _networkTimeLineMappings = [@{} mutableCopy];
  }
  return _networkTimeLineMappings;
}

- (void)monitor:(id)monitor write:(NSString *)url info:(NSString *)statusInfo atTime:(NSDate *)time
{
  DMNetworkModel *model = [[DMNetworkModel alloc]init];
  model.url = url;
  model.statusInfo = statusInfo;
  
  if(![self.networkTimeLine containsObject:time]) [self.networkTimeLine addObject:time];
  self.networkTimeLineMappings[time] = model;
  
  dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
  });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.networkTimeLine.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
  if(!cell)
  {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"kCell"];
  }
  cell.backgroundColor = [UIColor orangeColor];
  
  NSDate *time = self.networkTimeLine[indexPath.row];
  cell.textLabel.text = [(DMNetworkModel *)self.networkTimeLineMappings[time] url];
  cell.detailTextLabel.text = [time stringWithDateFormatString:@"HH:mm:ss"];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDate *time = self.networkTimeLine[indexPath.row];
  NSString *statusInfo = [self.networkTimeLineMappings[time] statusInfo];
  
  DMDetailViewController *detailController = [[UIStoryboard storyboardWithName:@"DarwinMonitor" bundle:nil]instantiateViewControllerWithIdentifier:@"kDetailController"];
  [detailController setDetail:statusInfo];
  [self.navigationController pushViewController:detailController animated:YES];

}

@end
