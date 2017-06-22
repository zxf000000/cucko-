//
//  XFManageGoalTableViewCell.h
//  buBo
//
//  Created by mr.zhou on 2017/4/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFManageGoalTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *iconBackView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *encourageLabel;

@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedTimeLabel;

@property (nonatomic,strong) Goal *goal;
- (IBAction)clickChangeSwitch:(id)sender;

@end
