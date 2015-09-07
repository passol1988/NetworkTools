//
//  PingViewController.m
//  NetworkTools
//
//  Created by passol on 15/9/7.
//  Copyright (c) 2015年 passol. All rights reserved.
//

#import "PingViewController.h"
#import <arpa/inet.h>

@interface PingViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *DNSs;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation PingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"ping&DNS";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed)];
    [self.logTV addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapPressed
{
    [self touchesBegan:nil withEvent:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.pingTF isFirstResponder]) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];

    }
    [self.view endEditing:YES];
}

/**
 *  通过域名获取到IP
 *
 */
- (NSString *)ipFromDNS:(NSString *)host {
    Boolean result;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSString *hostname = host;
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL); // pass an error instead of NULL here to find out why it failed
        if (result == TRUE) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    if (result == TRUE) {
        NSMutableArray *tempDNS = [[NSMutableArray alloc] init];
        for(int i = 0; i < CFArrayGetCount(addresses); i++){
            struct sockaddr_in* remoteAddr;
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL){
                // Extract the ip address
                //const char *strIP41 = inet_ntoa(remoteAddr->sin_addr);
                NSString *strDNS =[NSString stringWithCString:inet_ntoa(remoteAddr->sin_addr) encoding:NSASCIIStringEncoding];
                NSLog(@"RESOLVED %d:<%@>", i, strDNS);
                [tempDNS addObject:strDNS];
            }
        }
        
        if (tempDNS.count < 1) {
            return nil;
        }else{
            self.DNSs = [tempDNS copy];
        }
        // 随机取一个IP
        int randomIndex = arc4random() % tempDNS.count;
        return tempDNS[randomIndex];
    } else {
        NSLog(@"Not resolved");
    }
    self.DNSs = nil;
    return nil;
}

- (void)setDNSs:(NSArray *)DNSs
{
    if (_DNSs != DNSs) {
        _DNSs = DNSs;
    }
    
    if (DNSs.count) {
        [self.btn_choose setEnabled:YES];
    }else{
        [self.btn_choose setEnabled:NO];
    }

}

- (IBAction)action_dig:(id)sender
{
    NSString *str =  self.dnsTF.text;
    [self ipFromDNS:str];
    [self.view endEditing:YES];
}

- (IBAction)action_ping:(id)sender
{
    self.logTV.text = [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]];
    [self log:@""];
    [self log:@"-----------"];
    [self log:@"Tapped Ping"];
    [SimplePingHelper ping:self.pingTF.text target:self sel:@selector(pingResult:)];
}

- (IBAction)action_choose:(id)sender
{
    if ([self.pingTF isFirstResponder]) {
        [self.pingTF resignFirstResponder];
    }
    
    if (!self.DNSs.count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未获取到IP地址"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles: nil];
        [alert show];
    }else{
        if (!self.pickerView) {
            self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 216.0)];
            self.pickerView.delegate = self;
            self.pickerView.dataSource = self;
        }
        [self.pingTF setInputView:self.pickerView];
        [self.pingTF becomeFirstResponder];
        [self.pickerView reloadAllComponents];
    }
}

#pragma mark - Ping

- (void)log:(NSString*)str {
    self.logTV.text = [NSString stringWithFormat:@"%@%@\n", self.logTV.text, str];
    NSLog(@"%@", str);
}

- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        [self log:@"SUCCESS"];
    } else {
        [self log:@"FAILURE"];
    }
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.DNSs.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.DNSs[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.pingTF.text = self.DNSs[row];
    [self.pingTF resignFirstResponder];
    self.pingTF.inputView = nil;
}


@end
