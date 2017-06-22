//
//  XFPotatoViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/5/24.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPotatoViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <POP.h>
#import <Masonry.h>
#import "XFCoreDataManager.h"
#import "NSUserDefaults+SaveKillAppTimeTool.h"
#import "XFAlertView.h"
#import "XFGoalTimeIntervalManager.h"
#import "XFRestView.h"

#define kGoalSelectViewIdentifier @"selectGoalViewCell"
#define kAlertViewHeight 250.f
@interface XFPotatoViewController () <UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource,XFAlertViewDelegate>

@property (nonatomic,strong) NSArray *numberPaths;

@property (nonatomic,strong) UIView *timeView;

@property (nonatomic,strong) NSArray *timeLayers;


@property (nonatomic,strong) UIImageView *circleView;

@property (nonatomic,strong) UIView *clockView;
@property (nonatomic,strong) UIButton *beginButton;

@property (nonatomic,strong) UIButton *musicButton;
@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *adjustTomatoTimeLabel;
@property (nonatomic,strong) UILabel *tomatoTimeLabel;

@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIButton *minusButton;

@property (nonatomic,assign) NSInteger timerSeconds;

@property (nonatomic,strong) NSTimer *timer;
/**
 *  添加音乐选项的按钮
 */
@property (nonatomic,strong) UIView *musicButtonView;
@property (nonatomic,strong) UICollectionView *musicSelectView;

@property (nonatomic,assign) BOOL selecteViewIsOpen;

@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,strong) NSArray *musicBackImages;

@property (nonatomic,strong) NSArray *bgMusicURLs;
/**
 *  选择目标的按钮
 */
@property (nonatomic,strong) UIButton *selectGoalButton;

@property (nonatomic,strong) UITableView *selectGoalView;

@property (nonatomic,strong) NSArray *allGoals;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UIView *selectGoalHeaderView;

@property (nonatomic,strong) UIButton *headerViewCancelButton;

@property (nonatomic,strong) NSUserDefaults *userDefaults;

@property (nonatomic,assign) NSInteger seconds;
/**
 *  调整番茄时钟后的时间
 */
@property (nonatomic,assign) NSInteger tomatoTimeSecond;
/**
 *  退出前是否正在计时
 */
@property (nonatomic,assign) BOOL isBeginBeforeKilled;

@property (nonatomic,assign) NSInteger timeIntervalSinceKilledTime;
/**
 *  番茄开始的时间和结束的时间
 */
@property (nonatomic,strong) NSDate *beginTime;
@property (nonatomic,strong) NSDate *endTime;

@property (nonatomic,assign) BOOL isPromptDealTomato;

/**
 *  有没有未处理的番茄
 */

@property (nonatomic,assign) BOOL haveUnDoneTomato;
/**
 *  静音按钮
 */
@property (nonatomic,strong) UIButton *soundsOffButton;

@end

@implementation XFPotatoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkIsBegin];
    
    self.selecteViewIsOpen = NO;
    
    [self setupNavigationBar];
    
    [self setupTimerView];

    [self setupClock];
    
    [self setupAVPlayer];
    
    [self setupSelectGoalButton];
    
    [self.view setNeedsUpdateConstraints];
    // 给计时的label添加监听
    [self addObserver:self forKeyPath:@"timerSeconds" options:(NSKeyValueObservingOptionNew) context:@"timeLabel"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBeKill) name:UIApplicationWillTerminateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self pushAlertView];
}

- (void)setupLocalNotification {



}

-(void)pushAlertView {

    if (self.haveUnDoneTomato) {
    
        // 已经是提示状态,不操作
        self.isPromptDealTomato = YES;
        // button状态要回复
        // 偏好设置中的开始状态要清除
        [self.userDefaults setStatusWithKey:kBeginStatusKey AndStatus:NO];
        
        // 时钟复位
        
        NSInteger minute = [self.tomatoTimeLabel.text integerValue];
        
        self.timeLabel.text = minute>9?[NSString stringWithFormat:@"%zd:00",minute]:[NSString stringWithFormat:@"0%zd:00",minute];
        // 恢复按钮状态
        self.beginButton.selected = NO;
        // 停止音乐
        [self.player stop];
        // 停止自动计时
        [self.timer invalidate];
        self.timer = nil;
        // 提示处理番茄
        XFAlertView *alertView = [[XFAlertView alloc] initWithBeginTime:[self.userDefaults objectForKey:kTomatoBeginTimeKey] AndEndTime:[[self.userDefaults objectForKey:kTomatoBeginTimeKey] dateByAddingTimeInterval:minute*60]];
        
        alertView.delegate = self;
        
        [alertView show];
        
        // 添加结束时间到本地村塾
        [self.userDefaults saveEndTimeWithTime:[[self.userDefaults objectForKey:kTomatoBeginTimeKey] dateByAddingTimeInterval:minute*60]];
        
    }

}

-(void)dealloc {

    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    [self.timeLabel removeObserver:self forKeyPath:@"text"context:@"timeLabel"];

}
// App进入前台
-(void)appWillBecomeActive {


}
/**
 *  app将要被杀死的通知
 */
-(void)appWillBeKill {

    [self.userDefaults saveAppKillTimeWithSeconds:self.timerSeconds];


}
// time改变的监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    if (self.isPromptDealTomato == NO) {
        
        if (self.timerSeconds == 0 && self.beginButton.selected ) {
            
            // 已经是提示状态,不操作
            self.isPromptDealTomato = YES;
            // button状态要回复
            // 偏好设置中的开始状态要清除
            [self.userDefaults setStatusWithKey:kBeginStatusKey AndStatus:NO];
            
            // 时钟复位
            
            NSInteger minute = [self.tomatoTimeLabel.text integerValue];
            
            self.timerSeconds = minute * 60;
            
//            self.timeLabel.text = minute>9?[NSString stringWithFormat:@"%zd:00",minute]:[NSString stringWithFormat:@"0%zd:00",minute];
            
            [self numberAnimationWithSeconds:self.timerSeconds];
            
            // 恢复按钮状态
            self.beginButton.selected = NO;
            // 停止音乐
            [self.player stop];
            // 停止自动计时
            [self.timer invalidate];
            self.timer = nil;
            // 提示处理番茄
            XFAlertView *alertView = [[XFAlertView alloc] initWithBeginTime:[self.userDefaults objectForKey:kTomatoBeginTimeKey] AndEndTime:[NSDate date]];
            
            alertView.delegate = self;
            
            [alertView show];
            
            // 添加结束时间到本地村塾
            [self.userDefaults saveEndTimeWithTime:[NSDate date]];
            
        }

    }
}

-(void)setupTimerView {

    self.timeView = [[UIView alloc] init];
    
    self.timeView.backgroundColor = [UIColor colorWithWhite:0.400 alpha:0.718];
    
    [self.view addSubview:self.timeView];
    
    CGFloat kWidth = 60;
    
    CGFloat height = 100;
    
    CGFloat padding = 5;
    
    UIView *view1 = [[UIView alloc] initWithFrame:(CGRectMake(padding, padding, kWidth, height))];
    
    view1.backgroundColor = [UIColor colorWithWhite:0.702 alpha:0.969];
    
    [self.timeView addSubview:view1];

    UIView *view2 = [[UIView alloc] initWithFrame:(CGRectMake(padding + (padding + kWidth), padding, kWidth, height))];
    
    view2.backgroundColor = [UIColor colorWithWhite:0.702 alpha:0.969];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 20, 70))];
    
    label.center = CGPointMake(275/2.f, 100/2.f);
    
    label.text = @":";
    
    label.textAlignment = UITextAlignmentCenter;
    
    label.textColor = [UIColor whiteColor];
    
    label.font = [UIFont systemFontOfSize:80];
    
    [self.timeView addSubview:label];
    
    [self.timeView addSubview:view2];
    UIView *view3 = [[UIView alloc] initWithFrame:(CGRectMake(padding + (padding + kWidth)*2+10, padding, kWidth, height))];
    
    view3.backgroundColor = [UIColor colorWithWhite:0.702 alpha:0.969];
    
    [self.timeView addSubview:view3];
    UIView *view4 = [[UIView alloc] initWithFrame:(CGRectMake(padding+ (padding + kWidth)*3+10, padding, kWidth, height))];
    
    view4.backgroundColor = [UIColor colorWithWhite:0.702 alpha:0.969];
    
    [self.timeView addSubview:view4];
    

    NSArray *views = [NSArray arrayWithObjects:view1,view2,view3,view4, nil];
//    [view1.layer addSublayer:layer];
    
    for (NSInteger i = 0 ; i < 4 ;i ++) {
        
        UIView *testView = [[UIView alloc] init];
        
        testView.backgroundColor = [UIColor whiteColor];
        // 设置显示效果
        
        CAShapeLayer *shapeLayer = self.timeLayers[i];
        
        UIBezierPath *path1 = self.numberPaths[0];
        
        shapeLayer.path = path1.CGPath;
        shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        shapeLayer.lineWidth = 7;
        
        shapeLayer.lineJoin = @"round";
        shapeLayer.lineCap = @"round";
        
        testView.frame = CGRectMake(0, 0, kWidth, height);
        
        testView.layer.mask = shapeLayer;
        
        [views[i] addSubview:testView];
    
    }
    

}
/**
 *  数字动画
 *
 *  @param seconds 当前计时秒数
 */
-(void)numberAnimationWithSeconds:(NSInteger)seconds {

    NSInteger second = self.timerSeconds%60;
    
    NSInteger minute = self.timerSeconds/60;
    
    
    NSString *secondStr = second > 9?[NSString stringWithFormat:@"%zd",second]:[NSString stringWithFormat:@"0%zd",second];
    
    NSString *minuteStr = minute>9?[NSString stringWithFormat:@"%zd",minute]:[NSString stringWithFormat:@"0%zd",minute];
    
    NSString *timeText = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];

    NSInteger num1 = [[timeText substringWithRange:(NSMakeRange(0, 1))] integerValue];
    
    NSInteger num2 = [[timeText substringWithRange:(NSMakeRange(1, 1))] integerValue];

    NSInteger num3 = [[timeText substringWithRange:(NSMakeRange(3, 1))] integerValue];
    
    NSInteger num4 = [[timeText substringWithRange:(NSMakeRange(4, 1))] integerValue];


    CASpringAnimation *animation1 = [CASpringAnimation animationWithKeyPath:@"path"];

    
    animation1.fillMode = kCAFillModeForwards;
    animation1.removedOnCompletion = NO;
    
    animation1.toValue = (__bridge id _Nullable)([self.numberPaths[num1] CGPath]);
    
    [self.timeLayers[0] addAnimation:animation1 forKey:@""];
    
    CASpringAnimation *animation2 = [CASpringAnimation animationWithKeyPath:@"path"];
    
    animation2.toValue = (__bridge id _Nullable)([self.numberPaths[num2] CGPath]);
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [self.timeLayers[1] addAnimation:animation2 forKey:@""];
    
    CASpringAnimation *animation3 = [CASpringAnimation animationWithKeyPath:@"path"];
    
    animation3.toValue = (__bridge id _Nullable)([self.numberPaths[num3] CGPath]);
    animation3.fillMode = kCAFillModeForwards;
    animation3.removedOnCompletion = NO;
    [self.timeLayers[2] addAnimation:animation3 forKey:@""];
    
    CASpringAnimation *animation4 = [CASpringAnimation animationWithKeyPath:@"path"];
    
    animation4.fillMode = kCAFillModeForwards;
    animation4.removedOnCompletion = NO;
    animation4.toValue = (__bridge id _Nullable)([self.numberPaths[num4] CGPath]);
    
    [self.timeLayers[3] addAnimation:animation4 forKey:@""];
    
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self setupGoalSelectView];
    // 判断kill前是否正在计时,如果是,那么开始计时

    if (self.isBeginBeforeKilled) {
        // 判断番茄时间是否用完
        if (self.timerSeconds <= 0) {
            
            // 用完的话,提示是否要加入目标中
            
        
        
        } else {
            // 没有用完的话,继续番茄计时
            [self clickBeginButton];

        
        }
        
    }
    

}
/**
 *  查看是否有未完成的计时
 */
-(void)checkIsBegin {
    
    self.isBeginBeforeKilled = [self.userDefaults boolForKey:@"tomatoIsBegin"];
    
    
}
/**
 * 初始化选择目标的button
 */
-(void)setupSelectGoalButton {
    
    self.selectGoalButton = [[UIButton alloc] init];
    
    [self.view addSubview:self.selectGoalButton];
    
    [self.selectGoalButton setTitle:@"选择目标" forState:(UIControlStateNormal)];
    
    UIImage *image = [UIImage imageNamed:@"selectGoal"];
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    
    [self.selectGoalButton setBackgroundImage:image forState:(UIControlStateNormal)];
    
    [self.selectGoalButton addTarget:self action:@selector(clickSelectGoalButton) forControlEvents:(UIControlEventTouchUpInside)];
}
/**
 *  点击选择目标的button
 */
-(void)clickSelectGoalButton {
    
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    [UIView animateWithDuration:0.2 animations:^{
        
        self.shadowView.backgroundColor = [UIColor colorWithWhite:0.098 alpha:0.55];
        
    }];
    
    POPSpringAnimation *frontAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    CGRect frame = self.selectGoalView.frame;
    
    frame.origin.y = (kScreenHeight - kAlertViewHeight)/2;
    
    frontAnimation.toValue = [NSValue valueWithCGRect:frame];
    
    frontAnimation.springBounciness = 6;
    
    [self.selectGoalView pop_addAnimation:frontAnimation forKey:@""];
    
    
    
}
/**
 *  设置goal选择View
 */
-(void)setupGoalSelectView {
    
    self.shadowView = [[UIView alloc] initWithFrame:(CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight))];
    
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.098 alpha:0];
    
    self.selectGoalView = [[UITableView alloc] initWithFrame:(CGRectMake((kScreenWidth - kAlertViewWidth)/2.f, -kAlertViewHeight, kAlertViewWidth, kAlertViewHeight))];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.selectGoalView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:(CGSizeMake(10, 10))];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.selectGoalView.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.selectGoalView.layer.mask = maskLayer;
    
    self.selectGoalView.bounces = NO;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.shadowView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectGoalView];
    
    self.selectGoalView.backgroundColor = [UIColor whiteColor];
    
    self.selectGoalView.delegate = self;
    self.selectGoalView.dataSource = self;

    self.selectGoalView.tableFooterView = [[UIView alloc] init];

}
/**
 *  设置tableVieww的SectionHeader,实现悬浮效果(只有一个section)
 
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

     self.selectGoalHeaderView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth,kAlertViewTopHeight))];
    
    self.selectGoalHeaderView.backgroundColor = kNavigationBarColor;
    
    self.headerViewCancelButton = [[UIButton alloc] initWithFrame:(CGRectMake(10, 10, 20, 20))];
    
    [self.headerViewCancelButton setImage:[UIImage imageNamed:@"tomato_X"] forState:(UIControlStateNormal)];
    
    [self.selectGoalHeaderView addSubview:self.headerViewCancelButton];
    
    [self.headerViewCancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    

    return self.selectGoalHeaderView;

}
/**
 *  tableViewCell被选择
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self cancelButtonClick];
    
    [self.selectGoalButton setTitle:self.allGoals[indexPath.row] forState:(UIControlStateNormal)];

}

// 取消选择goal按钮
-(void)cancelButtonClick {

    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        self.shadowView.backgroundColor = [UIColor colorWithWhite:0.098 alpha:0];
        
    } completion:^(BOOL finished) {
        
        self.shadowView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);

    }];
    
    [UIView animateWithDuration:0.15 animations:^{
       
        self.selectGoalView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.selectGoalView.frame = CGRectMake((kScreenWidth - kAlertViewWidth)/2, -kAlertViewHeight, kAlertViewWidth, kAlertViewHeight);
        
        self.selectGoalView.alpha = 1;
        
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == self.selectGoalView) {
    
        if (self.selectGoalView.contentOffset.y<0) {
        
            self.selectGoalView.contentOffset = CGPointMake(0, 0);
        }
    
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allGoals.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoalSelectViewIdentifier];
    
    if (cell == nil) {
    
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kGoalSelectViewIdentifier];
        
        cell.textLabel.text = self.allGoals[indexPath.row];
    
    }
    return cell;
}

// 初始化音乐播放器
-(void)setupAVPlayer {
    
    NSString *string = [[NSBundle mainBundle] pathForResource:@"细雨" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    
    // 初始化
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.player.delegate = self;
    
    //播放次数(一直循环)
    self.player.numberOfLoops = -1;

    
}

/**
 *  设置番茄时钟指示器
 */
-(void)setupClock {
    
    self.timeLabel = [[UILabel alloc] init];
    
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:100];
    // 判断退出程序前是否正在计时
    // 如果正在计时,计算时间差,相减
    if ([self.userDefaults boolForKey:kBeginStatusKey]) {
        
        self.seconds = [self.userDefaults integerForKey:kSecondBeforeKilledKey];
            
        NSDate *dateBeforeKilled = [self.userDefaults objectForKey:kDateForKilledKey];
            
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:dateBeforeKilled];
        
        
        if (self.seconds-(NSInteger)timeInterval >= 0) {
        
            self.timerSeconds = self.seconds-(NSInteger)timeInterval;
        
        } else {
        
            self.timerSeconds = 0;
            
            // 这里要提示
            self.haveUnDoneTomato = YES;
        }
        
//        NSString *minute = self.timerSeconds/60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds/60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds/60];
//        
//        NSString *second = self.timerSeconds%60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds%60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds%60];
        
        
//        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
        
        [self numberAnimationWithSeconds:self.timerSeconds];
    
    } else {
        // 如果不是正在计时,初始化
        self.timeLabel.text = @"25:00";

        self.timerSeconds = 25*60;
        [self numberAnimationWithSeconds:self.timerSeconds];
//
//        NSString *minute = self.timerSeconds/60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds/60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds/60];
//        
//        NSString *second = self.timerSeconds%60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds%60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds%60];
//        
//        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
    }
    
    [self.view addSubview:self.timeLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(30, 30);
    
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    self.musicSelectView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    
    self.musicButtonView  = [[UIView alloc] init];
    
    [self.view addSubview:self.musicButtonView];
    
    self.musicSelectView.delegate = self;
    self.musicSelectView.dataSource = self;
    [self.musicButtonView addSubview:self.musicSelectView];
    
    [self.musicSelectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"musicSelectView"];
    
    self.musicSelectView.backgroundColor = [UIColor clearColor];
    self.musicSelectView.layer.cornerRadius = 17.5;
    
    self.clockView = [[UIView alloc] init];
    
    self.clockView.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:0.66];
    
    [self.view addSubview:self.clockView];

    self.circleView = [[UIImageView alloc] init];
    
    self.circleView.image = [UIImage imageNamed:@"tomato_circle"];
    
    self.circleView.userInteractionEnabled = YES;
    
    [self.clockView addSubview:self.circleView];
    
    self.beginButton = [[UIButton alloc] init];
    
    [self.beginButton setImage:[UIImage imageNamed:@"tomato_begin"] forState:(UIControlStateNormal)];
    
    [self.beginButton setImage:[UIImage imageNamed:@"tomato_pause"] forState:(UIControlStateSelected)];

    [self.beginButton addTarget:self action:@selector(clickBeginButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.circleView addSubview:self.beginButton];
    
    self.soundsOffButton = [[UIButton alloc] init];
    
    [self.soundsOffButton setImage:[UIImage imageNamed:@"tomato_soundsOn"] forState:(UIControlStateNormal)];
    
    [self.soundsOffButton setImage:[UIImage imageNamed:@"tomato_soundsOff"] forState:(UIControlStateSelected)];

    
    [self.soundsOffButton addTarget:self action:@selector(clickSoundsOffButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:self.soundsOffButton];
    
    self.adjustTomatoTimeLabel = [[UILabel alloc] init];
    self.adjustTomatoTimeLabel.textColor = [UIColor whiteColor];
    self.adjustTomatoTimeLabel.text = @"调整番茄时间";
    
    [self.clockView addSubview:self.adjustTomatoTimeLabel];
    
    self.tomatoTimeLabel = [[UILabel alloc] init];
    self.tomatoTimeLabel.textColor = [UIColor whiteColor];
    // 判断推出前是否正在计时,如果是的话,要更新UI
    if (self.isBeginBeforeKilled) {
        
        self.tomatoTimeSecond = [self.userDefaults integerForKey:kTomatoTimeSecondKey];
        
        self.tomatoTimeLabel.text = [NSString stringWithFormat:@"%zdm",self.tomatoTimeSecond/60];
        
    } else {
        // 如果不是的话,初始化
        self.tomatoTimeLabel.text = @"25m";
        self.tomatoTimeSecond = 25*60;
        // 保存到本地
        [self.userDefaults setInteger:25*60 forKey:kTomatoTimeSecondKey];
        [self.userDefaults synchronize];
    
    }

    [self.clockView addSubview:self.tomatoTimeLabel];
    
    self.addButton = [[UIButton alloc] init];
    
    [self.clockView addSubview:self.addButton];
    
    self.minusButton = [[UIButton alloc] init];
    
    [self.clockView addSubview:self.minusButton];
    
    self.addButton = [[UIButton alloc] init];
    
    [self.addButton setImage:[UIImage imageNamed:@"tomato_add"] forState:(UIControlStateNormal)];
    
    [self.addButton addTarget:self action:@selector(clickAddButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.clockView addSubview:self.addButton];
    
    self.minusButton = [[UIButton alloc] init];
    
    [self.minusButton setImage:[UIImage imageNamed:@"tomato_minus"] forState:(UIControlStateNormal)];
    
    [self.clockView addSubview:self.minusButton];
    
    [self.minusButton addTarget:self action:@selector(clickMinusButton) forControlEvents:(UIControlEventTouchUpInside)];

}

//点击音乐按钮
-(void)clickMusicButton {
    
    if (!self.selecteViewIsOpen) {
        
        self.selecteViewIsOpen = YES;
        
        CGRect frame = self.musicSelectView.frame;
        
        CGFloat height = 30*self.musicBackImages.count + 20 + (self.musicBackImages.count - 1)*10 ;
        
        frame.size = CGSizeMake(40, height);
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        animation.toValue = [NSValue valueWithCGRect:frame];
        
        animation.springBounciness = 5;
        
        [self.musicSelectView pop_addAnimation:animation forKey:@""];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.musicSelectView.backgroundColor = [UIColor colorWithWhite:0.098 alpha:0.513];
            
        }];

        
    } else {
    
        self.selecteViewIsOpen = NO;
        
        CGRect frame = self.musicSelectView.frame;
        
        CGFloat height = 50;
        
        frame.size = CGSizeMake(40, height);
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        animation.toValue = [NSValue valueWithCGRect:frame];
        
        animation.springBounciness = 5;
        
        [self.musicSelectView pop_addAnimation:animation forKey:@""];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.musicSelectView.backgroundColor = [UIColor clearColor];
            
        }];

    
    }


}
// 点击更多按钮
-(void)clickSoundsOffButton {

    self.soundsOffButton.selected = !self.soundsOffButton.isSelected;
    
    if (self.soundsOffButton.isSelected) {
    
        self.player.volume = 0;
    
    } else {
    
        self.player.volume = 12;
    
    }
    
}

// 点击增加按钮
-(void)clickAddButton {

    if (self.beginButton.selected) {

        self.beginButton.selected = NO;
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    if (self.timerSeconds + 5*60 <= 60*60) {
    
        self.timerSeconds += 5*60;
        // 设置时间显示label的数据

//        NSString *minute = self.timerSeconds/60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds/60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds/60];
//        
//        NSString *second = self.timerSeconds%60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds%60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds%60];
        
//        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
        
        [self numberAnimationWithSeconds:self.timerSeconds];
        // 设置调整时间的数据
        NSInteger tomatoTime = [self.tomatoTimeLabel.text integerValue];
        
        tomatoTime += 5;

        NSString *timeStr = tomatoTime > 60?[NSString stringWithFormat:@"%zd",60]:[NSString stringWithFormat:@"%zd",tomatoTime];
        
        self.tomatoTimeLabel.text = [NSString stringWithFormat:@"%@m",timeStr];
        
        self.tomatoTimeSecond = tomatoTime*60;
        
        [self.userDefaults setInteger:self.tomatoTimeSecond forKey:kTomatoTimeSecondKey];
        
        [self.userDefaults synchronize];
        
//        NSLog(@"%zd",[self.userDefaults integerForKey:kTomatoTimeSecondKey]);
        
    }

    
}

// 点击减少按钮
-(void)clickMinusButton {

    if (self.beginButton.selected) {
        
        self.beginButton.selected = NO;
        
        [self.timer invalidate];
        
        self.timer = nil;
        
    }
    
    if (self.timerSeconds - 5*60 >= 5*60) {
        
        self.timerSeconds -= 5*60;
        // 设置时间显示label的数据
        NSString *minute = self.timerSeconds/60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds/60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds/60];
        
        NSString *second = self.timerSeconds%60>9?[NSString stringWithFormat:@"%zd",self.timerSeconds%60]:[NSString stringWithFormat:@"0%zd",self.timerSeconds%60];
        
//        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
        
        [self numberAnimationWithSeconds:self.timerSeconds];
        // 设置调整时间的label的数据
        NSInteger tomatoTime = [self.tomatoTimeLabel.text integerValue];
        
        tomatoTime -= 5;
        
        NSString *timeStr = tomatoTime < 0?[NSString stringWithFormat:@"%zd",0]:[NSString stringWithFormat:@"%zd",tomatoTime];
        self.tomatoTimeLabel.text = [NSString stringWithFormat:@"%@m",timeStr];
        
        self.tomatoTimeSecond = tomatoTime*60;

        // 吧这个时间保存到本地
        [self.userDefaults setInteger:self.tomatoTimeSecond forKey:kTomatoTimeSecondKey];
        
        [self.userDefaults synchronize];

    }

}

// 点击开始按钮
-(void)clickBeginButton {

#pragma mark 测试
    // 这个判断条件不对,测试用
    if (self.allGoals == nil || self.allGoals.count == 0) {
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.detailsLabel.text = @"请先选择一个目标";
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hideAnimated:YES afterDelay:1];
        HUD.detailsLabel.font = [UIFont systemFontOfSize:14];

    } else {
#pragma mark 缺少代码
        // 这里要添加开始时间到选择的目标
        if (self.beginButton.selected) {
            
            if (self.timerSeconds <= 0) {
                // 提示处理番茄
                
                
            
            } else {
            
                // 提示是否要丢弃番茄
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"要丢弃这个番茄吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.userDefaults setStatusWithKey:kBeginStatusKey AndStatus:NO];
                    
                    self.beginButton.selected = NO;
                    
                    [self.timer invalidate];
                    
                    self.timer = nil;
                    
                    [self.player pause];
                    
                    // userDEfault中的开始时间清除
                    [self.userDefaults saveBeginTimeWithTime:nil];
                    
                    // 时钟复位
                    
                    NSInteger minute = [self.tomatoTimeLabel.text integerValue];

                    
//                    self.timeLabel.text = minute > 9?[NSString stringWithFormat:@"%zd:00",minute]:[NSString stringWithFormat:@"0%zd:00",minute];
                    self.timerSeconds = minute * 60;
                    
                    [self numberAnimationWithSeconds:self.timerSeconds];

                    
                }];
                
                UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"不要" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                
                [alertController addAction:actionNO];
                [alertController addAction:actionDone];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            
        } else {
            
            // 保存开始时间
            [self.userDefaults saveBeginTimeWithTime:[NSDate date]];
            
            [self.userDefaults setStatusWithKey:kBeginStatusKey AndStatus:YES];
            
            [self.player play];
            
            self.beginButton.selected = YES;
            
            self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                
                
                self.timerSeconds -= 1;
                
                NSInteger second = self.timerSeconds%60;
                
                NSInteger minute = self.timerSeconds/60;
                
                
//                NSString *secondStr = second > 9?[NSString stringWithFormat:@"%zd",second]:[NSString stringWithFormat:@"0%zd",second];
//                
//                NSString *minuteStr = minute>9?[NSString stringWithFormat:@"%zd",minute]:[NSString stringWithFormat:@"0%zd",minute];
                
//                self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
                
                [self numberAnimationWithSeconds:self.timerSeconds];
                
            }];

            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:(NSRunLoopCommonModes)];
            
        }

    
    }
    
    

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.item) {
    
        case 0:
            [self clickMusicButton];
            break;
        case 1:
        {
            [self clickMusicButton];
            [self setPlayerWithNumber:0];

        }
            break;
        case 2:
        {
            [self clickMusicButton];
            [self setPlayerWithNumber:1];

        }
            break;
        case 3:
        {
            [self clickMusicButton];
            [self setPlayerWithNumber:2];

        }
            break;
        case 4:
        {
            [self clickMusicButton];
            [self setPlayerWithNumber:3];

        }
            break;
        case 5:
        {
            [self clickMusicButton];
            [self setPlayerWithNumber:4];

        }
            break;
        case 6:
        {
            [self clickMusicButton];
            [self setPlayerWithNumber:5];

        }
            break;
        
        default:
            
            break;
    
    }

}

-(void)setPlayerWithNumber:(NSInteger)number {

    if (self.player.isPlaying) {
    
        [self.player stop];
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.bgMusicURLs[number] error:nil];
        
        //播放次数(一直循环)
        self.player.numberOfLoops = -1;
        
        [self.player play];
    
    } else {
    
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.bgMusicURLs[number] error:nil];

        //播放次数(一直循环)
        self.player.numberOfLoops = -1;
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.musicBackImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"musicSelectView" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.musicBackImages[indexPath.item]];
    
    imageView.userInteractionEnabled = YES;
    
    cell.backgroundView = imageView;
    
    return cell;

}

// 设置导航栏
-(void)setupNavigationBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:UIBarMetricsDefault ];
    
    self.title = @"番茄";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置左边按钮
    UIButton *menuButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:(UIControlStateNormal)];
    
    [menuButton addTarget:self action:@selector(clickLeftButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;

}

#pragma mark - alertView代理方法
-(void)throwTomatoDelegate {
    // 清空记录
    // userDEfault中的开始时间清
    [self.userDefaults saveBeginTimeWithTime:nil];
    // 初始化提示状态
    self.isPromptDealTomato = NO;
    
    self.haveUnDoneTomato = NO;
    
    // 提示是否需要休息一下
#pragma mark 是否需要休息一下
    XFRestView *restView = [[XFRestView alloc] init];
    
    [restView show];
    
}

-(void)addTomatoToGoalWithName:(NSString *)name {

    // 取出模型数据
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:appdelegate.persistentContainer.viewContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name like %@",name];
    
    request.entity = entity;
    
    NSArray *result = [appdelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    NSDate *beginTime = [self.userDefaults objectForKey:kTomatoBeginTimeKey];
    
    NSDate *endTime = [self.userDefaults objectForKey:kTomatoEndTimeKey];
    
    [XFGoalTimeIntervalManager addBeginTimeWithGoal:result[0] time:beginTime];
    
    [XFGoalTimeIntervalManager addEndTimeWithGoal:result[0] time:endTime];
    // 初始化提示状态
    self.isPromptDealTomato = NO;
    
    self.haveUnDoneTomato = NO;
    
    // 提示是否需要休息一下
    XFRestView *restView = [[XFRestView alloc] init];
    
    [restView show];
    
}

-(void)clickLeftButton {

    if ([self.delegate respondsToSelector:@selector(slideViewDelegate)]) {
    
        [self.delegate slideViewDelegate];
    
    }
    
    
}

-(void)updateViewConstraints {
    
    [self.musicButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(30);
        make.left.mas_offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30*self.musicBackImages.count + 20 + (self.musicBackImages.count - 1)*10);

        
        
    }];
    
    [self.musicSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(self.musicSelectView.mas_width);
        
    }];
    
    [self.soundsOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(40);
        make.right.mas_offset(-20);
        make.width.height.mas_equalTo(30);
        
        
    }];

    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(150);
        
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-20);
        make.top.mas_offset(20);
        make.bottom.mas_offset(-20);
        make.width.mas_equalTo(self.circleView.mas_height);

        
    }];
    
    [self.beginButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
        make.top.mas_offset(30);
        make.bottom.mas_offset(-30);
        
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_offset(-(kScreenHeight-150-64)*(0.5-0.382)-64);
        make.width.mas_equalTo(275);
        
        make.height.mas_equalTo(110);
        
    }];
    
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.centerY.mas_offset(-(kScreenHeight-150-64)*(0.5-0.382)-64);
//        
//        
//    }];
    
    [self.adjustTomatoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(30);
        make.left.mas_offset(20);
        
    }];
    
    [self.tomatoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.adjustTomatoTimeLabel.mas_bottom).offset(20);

        make.centerX.mas_equalTo(self.adjustTomatoTimeLabel.mas_centerX);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.adjustTomatoTimeLabel.mas_left);
        make.centerY.mas_equalTo(self.tomatoTimeLabel.mas_centerY);
        make.width.height.mas_equalTo(27);
        
    }];
    
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.adjustTomatoTimeLabel.mas_right);
        make.centerY.mas_equalTo(self.tomatoTimeLabel.mas_centerY);
        make.width.height.mas_equalTo(30);
        
    }];
    
//    [self.selectGoalButton mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(-20);
//        make.centerX.mas_offset(0);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(100);
//        
//    }];

    
    [super updateViewConstraints];
}

-(NSArray *)allGoals {

    if (_allGoals == nil) {
        
        XFCoreDataManager *manager = [XFCoreDataManager shareManager];
    
        NSArray *allGoals = [manager allGoals];
        
        NSMutableArray *allNames = [NSMutableArray array];
        
        for (Goal *goal in allGoals) {
            NSString *name = goal.name;
            
            [allNames addObject:name];
            
        }
        _allGoals = allNames.copy;
    }
    return _allGoals;
}

-(NSArray *)musicBackImages {
    
    if (_musicBackImages == nil) {
    
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:[UIImage imageNamed:@"tomato_music"]];
        [array addObject:[UIImage imageNamed:@"tomato_musicBird"]];
        [array addObject:[UIImage imageNamed:@"tomato_musicTree"]];
        [array addObject:[UIImage imageNamed:@"tomato_musicCoffe"]];
        [array addObject:[UIImage imageNamed:@"tomato_musicCountry"]];
        [array addObject:[UIImage imageNamed:@"tomato_musicRain"]];
        [array addObject:[UIImage imageNamed:@"tomato_musicRavier"]];
    
        _musicBackImages = array.copy;
    }

    return _musicBackImages;
}

-(NSArray *)bgMusicURLs {

    if (_bgMusicURLs == nil) {
    
        NSMutableArray *array = [NSMutableArray array];
        
        NSString *string1 = [[NSBundle mainBundle] pathForResource:@"鸟叫" ofType:@"mp3"];
        NSURL *url1 = [NSURL fileURLWithPath:string1];
        
        NSString *string2 = [[NSBundle mainBundle] pathForResource:@"细雨树叶" ofType:@"mp3"];
        NSURL *url2 = [NSURL fileURLWithPath:string2];
        
        NSString *string3 = [[NSBundle mainBundle] pathForResource:@"咖啡馆人权" ofType:@"mp3"];
        NSURL *url3 = [NSURL fileURLWithPath:string3];
        
        NSString *string4 = [[NSBundle mainBundle] pathForResource:@"乡村" ofType:@"mp3"];
        NSURL *url4 = [NSURL fileURLWithPath:string4];
        
        NSString *string5 = [[NSBundle mainBundle] pathForResource:@"细雨" ofType:@"mp3"];
        NSURL *url5 = [NSURL fileURLWithPath:string5];
        
        NSString *string6 = [[NSBundle mainBundle] pathForResource:@"河流" ofType:@"mp3"];
        NSURL *url6 = [NSURL fileURLWithPath:string6];
        
        [array addObject:url1];
        [array addObject:url2];
        [array addObject:url3];
        [array addObject:url4];
        [array addObject:url5];
        [array addObject:url6];

        _bgMusicURLs = array.copy;
    }
    return _bgMusicURLs;
}

-(NSUserDefaults *)userDefaults {


    return [NSUserDefaults standardUserDefaults];
}

-(NSArray *)numberPaths {
    
    if (_numberPaths == nil) {
    
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        
        [path1 moveToPoint:(CGPointMake(30, 15))];
        
        [path1 addLineToPoint:(CGPointMake(28, 85))];
        
        path1.lineCapStyle = kCGLineCapRound;
        
        path1.lineJoinStyle = kCGLineJoinRound;
        
//        self.layer = [CAShapeLayer layer];
//        
//        self.layer.strokeColor = [UIColor blueColor].CGColor;
//        
//        self.layer.lineWidth = 5;
//        
//        view1.layer.mask = self.layer;
        //
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        
        [path2 addArcWithCenter:(CGPointMake(30, 32)) radius:18 startAngle:M_PI endAngle:0.2*M_PI clockwise:YES];
        
        
        [path2 addLineToPoint:(CGPointMake(10, 85))];
        
        [path2 addLineToPoint:(CGPointMake(50, 85))];
        
        path2.lineCapStyle = kCGLineCapRound;
        
        path2.lineJoinStyle = kCGLineJoinRound;
//        self.layer.fillColor = [UIColor clearColor].CGColor;
//        
//        self.layer.path = path2.CGPath;
        
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        
        //    [path3 moveToPoint:(CGPointMake(0, 20))];
        
        [path3 addArcWithCenter:(CGPointMake(30, 65)) radius:20 startAngle:(M_PI) endAngle:M_PI*3/2 clockwise:NO];
        
        
        [path3 addArcWithCenter:(CGPointMake(30, 30)) radius:(15) startAngle:M_PI_2 endAngle:M_PI clockwise:NO];
        
        path3.lineCapStyle = kCGLineCapRound;
        
        path3.lineJoinStyle = kCGLineJoinRound;
//        self.layer.path = path3.CGPath;
        
        UIBezierPath *path4 = [UIBezierPath bezierPath];
        
        [path4 moveToPoint:(CGPointMake(40, 88))];
        
        [path4 addLineToPoint:(CGPointMake(40, 15))];
        
        [path4 addLineToPoint:(CGPointMake(10, 65))];
        
        [path4 addLineToPoint:(CGPointMake(50, 65))];
        
        path4.lineCapStyle = kCGLineCapRound;
        
        path4.lineJoinStyle = kCGLineJoinRound;
        
//        self.layer.path = path4.CGPath;
        
        UIBezierPath *path5 = [UIBezierPath bezierPath];
        
        [path5 addArcWithCenter:(CGPointMake(29, 68)) radius:20 startAngle:M_PI endAngle:M_PI*3/2 clockwise:NO];
        
        [path5 addLineToPoint:(CGPointMake(25, 48))];
        
        [path5 addLineToPoint:(CGPointMake(27, 15))];
        
        [path5 addLineToPoint:(CGPointMake(50, 15))];
        path5.lineCapStyle = kCGLineCapRound;
        
        path5.lineJoinStyle = kCGLineJoinRound;
//        self.layer.path = path5.CGPath;
        
        UIBezierPath *path6 = [UIBezierPath bezierPath];
        
        [path6 addArcWithCenter:(CGPointMake(30, 65)) radius:20 startAngle:M_PI*5/4 endAngle:M_PI*5/4-M_PI/180 clockwise:YES];
        
        [path6 addLineToPoint:(CGPointMake(35, 13))];
        path6.lineCapStyle = kCGLineCapRound;
        
        path6.lineJoinStyle = kCGLineJoinRound;
//        self.layer.path = path6.CGPath;
        
        UIBezierPath *path7 = [UIBezierPath bezierPath];
        
        [path7 moveToPoint:(CGPointMake(15, 15))];
        
        [path7 addLineToPoint:(CGPointMake(47, 15))];
        
        [path7 addLineToPoint:(CGPointMake(25, 85))];
        path7.lineCapStyle = kCGLineCapRound;
        
        path7.lineJoinStyle = kCGLineJoinRound;
//        self.layer.path = path7.CGPath;
        
        UIBezierPath *path8 = [UIBezierPath bezierPath];
        
        [path8 addArcWithCenter:(CGPointMake(30, 65)) radius:20 startAngle:(M_PI*3/2-M_PI/180.f) endAngle:M_PI*3/2 clockwise:NO];
        
        [path8 addArcWithCenter:(CGPointMake(30, 30)) radius:(15) startAngle:M_PI_2 endAngle:M_PI_2 + M_PI/180.f clockwise:NO];
        path8.lineCapStyle = kCGLineCapRound;
        
        path8.lineJoinStyle = kCGLineJoinRound;
        
//        self.layer.path = path8.CGPath;
        
        UIBezierPath *path9 = [UIBezierPath bezierPath];
        
        [path9 addArcWithCenter:(CGPointMake(30, 35)) radius:20 startAngle:M_PI_4 endAngle:M_PI_4-M_PI/180.f clockwise:YES];
        
        [path9 addLineToPoint:(CGPointMake(30, 85))];
        path9.lineCapStyle = kCGLineCapRound;
        
        path9.lineJoinStyle = kCGLineJoinRound;
//        self.layer.path = path9.CGPath;
        
        
        UIBezierPath *path0 = [UIBezierPath bezierPathWithOvalInRect:(CGRectMake(12, 13, 36, 74))];
        
        _numberPaths = [NSArray arrayWithObjects:path0,path1,path2,path3,path4,path5,path6,path7,path8,path9, nil];

        
    }
    return _numberPaths;

}

-(NSArray *)timeLayers {

    if (_timeLayers == nil) {
    
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < 4 ; i ++) {
        
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            
            [arr addObject:layer];
        
            
        }
        _timeLayers = arr.copy;
    }
    
    return _timeLayers;

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
