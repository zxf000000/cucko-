//
//  XFEverydayViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFEverydayViewController.h"

@interface XFEverydayViewController ()

@end

@implementation XFEverydayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];

    UILabel *textLabel;
    
    textLabel = [[UILabel alloc] initWithFrame:(CGRectMake(20, 100, 100, 20))];
    
    [self.view addSubview:textLabel];
    
    textLabel.text = @"每天";}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
