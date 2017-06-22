//
//  TodayTableViewCell.m
//  buBo
//
//  Created by mr.zhou on 2017/4/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "TodayTableViewCell.h"
#import <Masonry.h>
#import "XFGoalTimeIntervalManager.h"
#import "XFCoreDataManager.h"
#import "NSDateFormatter+XFDateFormatter.h"
#import <AVFoundation/AVFoundation.h>
#import "NSUserDefaults+SaveKillAppTimeTool.h"

#define kBeginGoalNameKey @"beginGoalName"
#define kGoalSecondBeforeKillKey @"secondBeforeKill"

@interface TodayTableViewCell () <AVAudioPlayerDelegate>


- (IBAction)onClickStartButton:(UIButton *)sender;

@property (nonatomic,assign) __block NSInteger seconds;

@property (nonatomic,weak) UIButton *stopButton;

@property (nonatomic,strong) NSDate * backgroundTime;

@property (nonatomic,strong) NSDate *forgroundTime;

@property (nonatomic,strong) NSDate *endtime;

@property (nonatomic,assign) NSTimeInterval timeGone;

@property (nonatomic,strong) UILabel *testLabel;

@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,assign) BOOL isBegin;

@property (nonatomic,assign) NSInteger totalSeconds;

@end

@implementation TodayTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        
    
    }
    return self;
}

-(void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 初始化音乐播放器
-(void)setupAVPlayer {
    
    NSString *string = [[NSBundle mainBundle] pathForResource:@"细雨" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    
    // 初始化
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.player.delegate = self;
    
    [self.player setVolume:0];
    
    //播放次数(一直循环)
    self.player.numberOfLoops = -1;
    
    
}

-(void)setMenu:(Goal *)menu {

    _menu = menu;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillTerminateNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginActivity) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self setupCell];

    
}

-(void)beginActivity {


}


-(void)WillTerminateNotification {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kDateForKilledKey];
    [[NSUserDefaults standardUserDefaults] setInteger:self.totalSeconds forKey:kGoalSecondBeforeKillKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)willEnterForground {
    
    [self setupCell];
    
    self.timeGone = [[NSDate date] timeIntervalSinceDate:self.endtime];
    

}

- (void)setupCell {
    
    [self setupAVPlayer];
    
    _goalLabel.text = _menu.name;
    
    _encourageLabel.text = _menu.encourage;
    
    _iconView.image = (UIImage *)_menu.pic;
    
    
    if ([_menu.name isEqualToString:@"浪费"] ||[_menu.name isEqualToString:@"固定"] ||[_menu.name isEqualToString:@"睡眠"]) {
    
        _hourLabel.text = @"";
        
        _iconBackView.image = nil;

    
    } else {
        
        NSDictionary *hourDic = [NSJSONSerialization JSONObjectWithData:_menu.beginAndEnd options:NSJSONReadingMutableContainers error:nil];
        
        __block float hours = 0.f;
        
        __block NSInteger seconds = 0;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        __block NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        [hourDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            
            if ([key isEqualToString:dateStr]) {
                // 对比开始时间和结束时间的时间差
                NSDate *startTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
                NSDate *endTime = [[NSDateFormatter minuteDateFormatter] dateFromString:key];
                
                seconds += [endTime timeIntervalSinceDate:startTime];
                
            }
            
        }];
        
        hours = seconds/3600.f;
        
        _hourLabel.text = [NSString stringWithFormat:@"%.1fh/%.1fh",hours,[_menu.everyday floatValue]];

    }
    
    
    [_startButton setImage:[UIImage imageNamed:@"goal_stop"] forState:(UIControlStateSelected)];
    
    _startButton.selected = NO;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kGoalIsBeginKey]) {
    
        if ([_goalLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kBeginGoalNameKey]]) {
        
            NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:kDateForKilledKey]];

            NSInteger totalSecond = [[NSUserDefaults standardUserDefaults] integerForKey:kGoalSecondBeforeKillKey];
            
            self.totalSeconds = timeInterval + totalSecond;
            
            [self onClickStartButton:_startButton];
        }
    
    
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeToStop {
    
    [self.delegate stopTimerDelegateWithCell:self];

    self.startButton.selected = NO;
    
    self.goalLabel.text = self.menu.name;
    
    self.encourageLabel.text = self.menu.encourage;
    
    [self.timer invalidate];
    // 在这里保存数据到数据库模型    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    [[XFCoreDataManager shareManager] updateDataWithPropertyName:self.goalLabel.text Value:self.seconds/3600.0];

    
    [XFGoalTimeIntervalManager addEndTimeWithGoal:self.menu time:[NSDate date]];
}

// 更新时间条数据
- (IBAction)onClickStartButton:(UIButton *)sender {
    
    if (self.startButton.isSelected) {
        // 无声音乐停止
        [self changeToStop];
        
        [self.player stop];
        
        self.isBegin = NO;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kGoalIsBeginKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        self.isBegin = YES;
        // 添加开始信息到偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kGoalBeginTimeKey];
        [[NSUserDefaults standardUserDefaults] setObject:self.goalLabel.text forKey:kBeginGoalNameKey];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGoalIsBeginKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 添加一个无声音乐
        [self.player play];
        
        [self.delegate todayCellDelegateWithCell:self];

        self.startButton.selected = YES;
        
        self.encourageLabel.text = self.menu.name;
        
        __block NSInteger totalSecond = self.totalSeconds;
        
        __block NSInteger second = totalSecond % 60;
        
        __block NSInteger min = totalSecond / 60;
        
        __block NSInteger hour = totalSecond / 3600;
        
        __block NSString *secondString;
        
        __block NSString *minString;
        __block NSString *hourString;
        __block NSString *time;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            // 这里测试
            totalSecond += 1;
            
            self.seconds = totalSecond;
            
            second = totalSecond % 60;
            
            min = (totalSecond%3600)/60;
            
            hour = totalSecond / 3600;
            
            if (second > 9) {
                secondString = [NSString stringWithFormat:@"%zd",second];
            } else {
                
                secondString = [NSString stringWithFormat:@"0%zd",second];
                
            }
            
            
            if (min > 9) {
                minString = [NSString stringWithFormat:@"%zd",min];
            } else {
                
                minString = [NSString stringWithFormat:@"0%zd",min];
                
            }
            if (hour > 9) {
                hourString = [NSString stringWithFormat:@"%zd",hour];
            } else {
                
                hourString = [NSString stringWithFormat:@"0%zd",hour];
                
            }
            
            time = [NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secondString];
            
            self.goalLabel.text = time;

            self.totalSeconds = totalSecond;
        }];
        
        self.timer = timer;
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:(NSRunLoopCommonModes)];
        
        [XFGoalTimeIntervalManager addBeginTimeWithGoal:self.menu time:[NSDate date]];
        
    }
    
}
    
    
@end
