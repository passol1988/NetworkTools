//
//  ReachViewController.h
//  NetworkTools
//
//  Created by passol on 15/9/7.
//  Copyright (c) 2015年 passol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class AppDelegate;
@interface ReachViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *lb_builder;
@property (nonatomic, weak) IBOutlet UILabel *lb_network;
@property (nonatomic, weak) IBOutlet UILabel *lb_ip;

@end
