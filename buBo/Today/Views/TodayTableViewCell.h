//
//  TodayTableViewCell.h
//  buBo
//
//  Created by mr.zhou on 2017/4/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayMenus.h"
@class TodayTableViewCell;

@protocol TodayTableViewCellDelegate <NSObject>

-(void)todayCellDelegateWithCell:(TodayTableViewCell *)cell;

-(void)stopTimerDelegateWithCell:(TodayTableViewCell *)cell;

@end

@interface TodayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconBackView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *encourageLabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (nonatomic,assign) NSTimer *timer;

@property (nonatomic,strong) Goal *menu;

@property (nonatomic,assign) BOOL isStart;

@property (nonatomic,strong) id <TodayTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)changeToStop;

@end
