//
//  PingViewController.h
//  NetworkTools
//
//  Created by passol on 15/9/7.
//  Copyright (c) 2015年 passol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplePingHelper.h"

@interface PingViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *dnsTF;
@property (nonatomic, strong) IBOutlet UITextField *pingTF;
@property (nonatomic, strong) IBOutlet UITextView *logTV;
@property (nonatomic, strong) IBOutlet UIButton *btn_choose;


- (IBAction)action_ping:(id)sender;
- (IBAction)action_choose:(id)sender;
- (IBAction)action_dig:(id)sender;

@end
