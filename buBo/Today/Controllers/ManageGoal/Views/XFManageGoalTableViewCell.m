//
//  XFManageGoalTableViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/4/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFManageGoalTableViewCell.h"

@implementation XFManageGoalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    
}

-(void)setGoal:(Goal *)goal {

    _goal = goal;
    
    _iconBackView.image  = [UIImage imageNamed:@"icon_backGround"];

    _iconView.image = (UIImage *)goal.pic;
    
    _iconBackView.backgroundColor = (UIColor *)goal.color;
    _nameLabel.text = goal.name;
    
    _encourageLabel.text = goal.encourage;
    
    _creatTimeLabel.text = goal.creatTime;
    
    _deadlineLabel.text = goal.deadtime;
    
    NSDictionary *timesDic = [NSJSONSerialization JSONObjectWithData:goal.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
    
    __block NSInteger allSeconds = 0;
    
    [timesDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSDate *beginTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
        
        NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:obj];
        
        NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:beginTime];
        
        allSeconds += (NSInteger)timeInterval;
        
    }];

    NSString *acturlyTime = @"";
    
    if (allSeconds <= 60) {
    
        acturlyTime = [NSString stringWithFormat:@"%zd秒",allSeconds];
        
    
    } else if (allSeconds > 60 && allSeconds <= 3600) {
        
        acturlyTime = [NSString stringWithFormat:@"%.1f分钟",allSeconds/60.f];

        
    } else if (allSeconds > 3600 ) {
        
        acturlyTime = [NSString stringWithFormat:@"%.1f小时",allSeconds/3600.f];

        
    }
    
    
    _usedTimeLabel.text = [NSString stringWithFormat:@"%@/%@",acturlyTime,goal.needs];
    
    if ([goal.name isEqualToString:@"浪费"] || [goal.name isEqualToString:@"睡眠"] || [goal.name isEqualToString:@"固定"] ) {
    
        _usedTimeLabel.text = [NSString stringWithFormat:@"%@/0小时",acturlyTime];

    
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickChangeSwitch:(id)sender {
}
@end
