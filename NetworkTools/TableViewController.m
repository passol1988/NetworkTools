//
//  TableViewController.m
//  NetworkTools
//
//  Created by passol on 15/9/7.
//  Copyright (c) 2015年 passol. All rights reserved.
//

#import "TableViewController.h"
#import "ReachViewController.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end


@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"网络工具";
    self.array = [@[@"reach", @"ping", @"detect"] mutableCopy];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:self.array[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
