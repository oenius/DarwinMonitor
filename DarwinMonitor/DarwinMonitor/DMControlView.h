//
//  DMControlView.h
//  DarwinMonitor
//
//  Created by YURI_JOU on 16/4/13.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMControlView : UIView

@property (nonatomic, strong)IBOutletCollection(UIButton) NSArray *colletions;
@property (nonatomic, strong)void (^handleMenu)(NSInteger pos);

- (void)setControlsHidden:(BOOL)hidden;

@end
