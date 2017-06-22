//
//  XFMineViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMineViewController.h"

@interface XFMineViewController ()

@end

@implementation XFMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UILabel *textLabel;
    
    textLabel = [[UILabel alloc] initWithFrame:(CGRectMake(20, 100, 100, 20))];
    
    [self.view addSubview:textLabel];
    
    textLabel.text = @"我的";

}


@end
