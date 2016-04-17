//
//  DMContainerController.h
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/14.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMContainerController : UIViewController

@property (nonatomic, assign, readonly)BOOL expended;

@property (nonatomic, copy)void(^handleExpended)(BOOL);
@property (nonatomic, copy)void(^handleBack)();

- (void)setContentController:(UIViewController *)contentController;

@end
