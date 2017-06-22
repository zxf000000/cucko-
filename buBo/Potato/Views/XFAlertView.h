//
//  XFAlertView.h
//  buBo
//
//  Created by mr.zhou on 2017/6/8.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFLabel.h"

@protocol XFAlertViewDelegate <NSObject>

-(void)throwTomatoDelegate;

-(void)addTomatoToGoalWithName:(NSString *)name;

@end

@interface XFAlertView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *goalNames;

@property (nonatomic,strong) id <XFAlertViewDelegate> delegate;
/**
 *  遮罩View
 */
@property (nonatomic,strong) UIView *shadowView;
/**
 *  开始的时间
 */
@property (nonatomic,strong) NSDate *beginTime;
/**
 *  结束的时间
 */
@property (nonatomic,strong) NSDate *endTime;
/**
 *  头部标题View
 */
@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UILabel *titleLabel;
/**
 *  时间的View
 */
@property (nonatomic,strong) UIView *timeView;

@property (nonatomic,strong) UILabel *beginTimeLabel;

@property (nonatomic,strong) XFLabel *beginLabel;

@property (nonatomic,strong) XFLabel *endLabel;
@property (nonatomic,strong) UILabel *endTimeLabel;
@property (nonatomic,strong) XFLabel *totalLabel;
@property (nonatomic,strong) UILabel *totalTimeLabel;

/**
 *  目标选择tableView
 */
@property (nonatomic,strong) UITableView *tableView;
/**
 *  选择目标的label
 */
@property (nonatomic,strong) UILabel *goalSelectLabel;
/**
 *  添加的button
 */
@property (nonatomic,strong) UIButton *doneButton;
/**
 *  丢弃的Button
 */
@property (nonatomic,strong) UIButton *throwButton;
/**
 *  自己输入的View
 */
@property (nonatomic,strong) UIView *otherThingsView;

@property (nonatomic,strong) UITextField *ohterThingTextField;

@property (nonatomic,strong) UILabel *otherThingLabel;

@property (nonatomic,strong) UILabel *tipsLabel;


-(instancetype)initWithBeginTime:(NSDate *)beginTime AndEndTime:(NSDate *)endTime;

-(void)show;

@end
