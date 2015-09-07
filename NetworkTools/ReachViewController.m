//
//  ReachViewController.m
//  NetworkTools
//
//  Created by passol on 15/9/7.
//  Copyright (c) 2015年 passol. All rights reserved.
//

#import "ReachViewController.h"
#import "AppDelegate.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface ReachViewController ()

@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyInfo;


@end

@implementation ReachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"连通性";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReachability)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self.telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    [NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification *note)
     {
         NSLog(@"New Radio Access Technology: %@", self.telephonyInfo.currentRadioAccessTechnology);
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.lb_ip.numberOfLines = 0;
    [self updateReachability];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"tele %@", self.telephonyInfo);
}

- (void)updateReachability
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NetworkStatus status = [appDelegate.reachability currentReachabilityStatus];
    
    NSString* wlanNetwork = nil;
    if (floorf(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        wlanNetwork  = self.telephonyInfo.currentRadioAccessTechnology;

    }
    
    if (status == NotReachable ) {
        _lb_network.text = @"无网络";
    }else if (status == ReachableViaWiFi){
        _lb_network.text = @"wifi连接";
    }else{
        _lb_network.text = @"蜂窝网络";
        if (wlanNetwork) {
            _lb_network.text = wlanNetwork;
        }
    }
    
    if (self.telephonyInfo.subscriberCellularProvider.carrierName) {
        _lb_builder.text = self.telephonyInfo.subscriberCellularProvider.carrierName;
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


/**
 *  获取IP地址
 *
 */
- (NSString *)getIpLocation {
    NSURL *url = [NSURL URLWithString:@"http://1111.ip138.com/ic.asp"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:8.0f];
    NSHTTPURLResponse *response;
    
    //返回的是GBK编码
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (200 == [response statusCode]) {
        //        //直接转,将会产生乱码或者字符串为空    NSUTF8StringEncoding
        //        NSString *temp1 = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        //        //                               NSASCIIStringEncoding
        //        NSString *temp2 = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
        //        NSLog(@"---------temp1---%@",temp1);
        //        NSLog(@"---------temp2---%@",temp2);
        //        NSLog(@"-------------------------------------");
        
        // 一、 GBK编码 (通过CFStringCreateWithBytes转码)
        CFStringRef GBKCFstirng =CFStringCreateWithBytes(NULL,[returnData bytes], [returnData length],kCFStringEncodingGB_18030_2000,false);
        NSString *gbkNSString1 = (__bridge NSString *)GBKCFstirng;
        //        NSLog(@"--gbkNSString1---%@",gbkNSString1);
        //
        //        // 二、 GBK编码 (通过CFStringConvertEncodingToNSStringEncoding转码)
        //        NSStringEncoding nsEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //        NSString *gbkNSString2 = [[NSString alloc] initWithData:returnData encoding:nsEncoding];
        //        NSLog(@"--gbkNSString2---%@",gbkNSString2);
        //
        //        NSLog(@"-------------------------------------");
        
        //转成NSUTF8StringEncoding的字符串
        NSData *tempdata = [gbkNSString1 dataUsingEncoding:NSUTF8StringEncoding];
        NSString *UTF8_NSString = [[NSString alloc] initWithData:tempdata encoding:NSUTF8StringEncoding];
        NSLog(@"--UTF8_NSString--%@",UTF8_NSString);
        
        NSRange range1 = [UTF8_NSString rangeOfString:@"<center>"];
        NSRange range2 = [UTF8_NSString rangeOfString:@"</center>"];
        NSRange range = NSMakeRange(range1.location+8, range2.location-range1.location-8);
        NSString *ipLocation = [UTF8_NSString substringWithRange:range];
        NSLog(@"-------------------------------------");
        NSLog(@"------IP-----%@", ipLocation);
        
        return ipLocation;
    }
    return @"获取失败";
}


- (IBAction)action_collectIP:(id)sender
{
    self.lb_ip.text = [self getIpLocation];
}

@end
