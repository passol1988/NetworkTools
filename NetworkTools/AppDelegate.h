//
//  AppDelegate.h
//  NetworkTools
//
//  Created by passol on 15/9/7.
//  Copyright (c) 2015年 passol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) Reachability *reachability;

@end

