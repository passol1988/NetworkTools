//
//  ReachViewController.m
//  NetworkTools
//
//  Created by passol on 15/9/7.
//  Copyright (c) 2015年 passol. All rights reserved.
//

#import "ReachViewController.h"
#import "AppDelegate.h"

@interface ReachViewController ()

@end

@implementation ReachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReachability)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateReachability];
}

- (void)updateReachability
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NetworkStatus status = [appDelegate.reachability currentReachabilityStatus];
    
    if (status == NotReachable) {
        _lb_network.text = @"无网络";
    }else if (status == ReachableViaWiFi){
        _lb_network.text = @"wifi连接";
    }else{
        _lb_network.text = @"蜂窝网络";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
