//
//  XFAlertView.m
//  buBo
//
//  Created by mr.zhou on 2017/6/8.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAlertView.h"
#import "XFAlertViewTableViewCell.h"

#define kHeight  360
#define kWidth 250

#define kAlertViewCellIdentifier @"AlertViewCell"

@implementation XFAlertView

-(instancetype)init {

    if (self = [super init]) {
    
    
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    
        
    
    }
    return self;
}
-(instancetype)initWithBeginTime:(NSDate *)beginTime AndEndTime:(NSDate *)endTime {
    
    if (self = [super init]) {
        

        self.backgroundColor = [UIColor colorWithRed:0.840 green:0.845 blue:0.845 alpha:1.000];
        
        _beginTime = beginTime;
        
        _endTime = endTime;
        
        _shadowView = [[UIView alloc] init];
        
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.516];
        
        _shadowView.alpha = 0;
        
        _shadowView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenWidth);

        
        _topView = [[UIView alloc] init];
        
        _topView.backgroundColor = kNavigationBarColor;
        [self addSubview:_topView];
        
        _timeView = [[UIView alloc] init];
        
        _timeView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_timeView];
        
        _goalSelectLabel = [[UILabel alloc] init];
        
        _goalSelectLabel.text = @"添加到哪个目标";
        
        _goalSelectLabel.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:_goalSelectLabel];
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    
        [self addSubview:_tableView];
        
        _otherThingsView = [[UIView alloc] init];
        
        _otherThingsView.backgroundColor = self.backgroundColor;
//        [self addSubview:_otherThingsView];
        
        _doneButton = [[UIButton alloc] init];
        
        [_doneButton setTitle:@"确定" forState:(UIControlStateNormal)];
        
        [_doneButton setBackgroundColor:[UIColor blueColor]];
        
        [self addSubview:_doneButton];
        
        _throwButton = [[UIButton alloc] init];
        
        [_throwButton setTitle:@"丢弃这个番茄" forState:(UIControlStateNormal)];

        [_throwButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_throwButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [_throwButton setTitleColor:[UIColor colorWithWhite:0.800 alpha:1.000] forState:(UIControlStateFocused)];

        
       [_throwButton setBackgroundColor:[UIColor whiteColor]];
        
        [_throwButton addTarget:self action:@selector(clickThrowButton) forControlEvents:(UIControlEventTouchUpInside)];

        [self addSubview:_throwButton];
        
        _titleLabel = [[UILabel alloc] init];
        
        [_topView addSubview:_titleLabel];
        
        _titleLabel.text = @"获得一个新的番茄";
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
        NSDateFormatter *formatter = [NSDateFormatter tomatoDateFormatter];
        
        _beginLabel = [[XFLabel alloc] init];
        
        _beginLabel.text = @"开始时间 :";
        
        _beginLabel.backgroundColor = [UIColor blackColor];
        
        _beginLabel.textColor = [UIColor whiteColor];
        
        _beginLabel.font = [UIFont systemFontOfSize:11];
        
        [_timeView addSubview:_beginLabel];
        
        _endLabel = [[XFLabel alloc] init];
        
        _endLabel.text = @"结束时间 :";
        
        _endLabel.backgroundColor = [UIColor blackColor];
        
        _endLabel.textColor = [UIColor whiteColor];
        
        _endLabel.font = [UIFont systemFontOfSize:11];
        
        [_timeView addSubview:_endLabel];
        
        _beginTimeLabel = [[UILabel alloc] init];
        
        _beginTimeLabel.text = [formatter stringFromDate:_beginTime];
        
        _beginTimeLabel.font = [UIFont systemFontOfSize:11];
        
        [_timeView addSubview:_beginTimeLabel];
        
        _endTimeLabel = [[UILabel alloc] init];
        
        _endTimeLabel.text = [formatter stringFromDate:_endTime];
        
        _endTimeLabel.font = [UIFont systemFontOfSize:11];

        [_timeView addSubview:_endTimeLabel];
        
        _totalLabel = [[XFLabel alloc] init];
        
        _totalLabel.text = @"总时间 :";
        
        _totalLabel.font = [UIFont systemFontOfSize:11];

        _totalLabel.textColor = [UIColor whiteColor];

        _totalLabel.backgroundColor = [UIColor grayColor];
        [_timeView addSubview:_totalLabel];
        
        _totalTimeLabel = [[UILabel alloc] init];
        
        _totalTimeLabel.text = [NSString stringWithFormat:@"%zds",(NSInteger)[_endTime timeIntervalSinceDate:_beginTime]];
        
        _totalTimeLabel.font = [UIFont systemFontOfSize:13];
        
        [_timeView addSubview:_totalTimeLabel];
        
        _otherThingLabel = [[UILabel alloc] init];
        
        _otherThingLabel.text = @"不在任务列表";
        
        _otherThingLabel.font = [UIFont systemFontOfSize:13];
        
        [_otherThingsView addSubview:_otherThingLabel];
        
        _ohterThingTextField = [[UITextField alloc] init];
        
        _ohterThingTextField.placeholder = @"这段时间做了什么?";
        
        _ohterThingTextField.font = [UIFont systemFontOfSize:11];
        _ohterThingTextField.backgroundColor = [UIColor whiteColor];
        
        UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 8, 0))];
        
        leftView.backgroundColor = [UIColor whiteColor];
        
        _ohterThingTextField.leftView = leftView;
        
        _ohterThingTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [_otherThingsView addSubview:_ohterThingTextField];
        
        _tipsLabel = [[UILabel alloc] init];
        
        _tipsLabel.text = @"tips:这里输入内容,点击确定就可以直接添加到番茄收集箱";
        
        _tipsLabel.font = [UIFont systemFontOfSize:9];
        
        [_otherThingsView addSubview:_tipsLabel];
        
        
        // 初始化alertView
        
        [[UIApplication sharedApplication].keyWindow addSubview:_shadowView];
        
        CGFloat width = 250;
        
        CGFloat height = 360;
        
        self.frame = CGRectMake((kScreenWidth-width)/2,-height, width, height);
        
        UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer*maskLayer=[[CAShapeLayer alloc] init];
        
        maskLayer.frame=self.bounds;
        
        maskLayer.path=maskPath.CGPath;
        
        self.layer.mask=maskLayer;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints {

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(40);
        
    }];

    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(73);
        
    }];
    
    [self.goalSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeView.mas_bottom).mas_offset(8);
        make.left.mas_offset(8);
        make.right.mas_offset(0);
        make.height.mas_equalTo(21);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.goalSelectLabel.mas_bottom).offset(8);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(160);
        
    }];
    
//    [self.otherThingsView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.top.mas_equalTo(self.tableView.mas_bottom).offset(0);
//        make.left.mas_offset(0);
//        make.right.mas_offset(0);
//        make.height.mas_equalTo(60);
//        
//    }];

//    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(self.otherThingsView.mas_bottom);
//        make.left.mas_offset(0);
//        make.bottom.mas_offset(0);
//    }];
   
    [self.throwButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-10);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        
    }];
    
    [self.beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.left.offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(70);
        
    }];
    
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginLabel.mas_bottom).offset(1);
        make.left.offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(70);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.endLabel.mas_bottom).offset(1);
        make.left.offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(60);
        
    }];
    
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.right.offset(-8);
        make.height.mas_equalTo(25);
        
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginTimeLabel.mas_bottom).offset(1);
        make.right.offset(-8);
        make.height.mas_equalTo(21);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.endTimeLabel.mas_bottom).offset(1);
        make.right.offset(-8);
        make.height.mas_equalTo(21);
        
    }];
    
    [self.otherThingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(8);
        make.height.mas_equalTo(21);
    }];

    [self.ohterThingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.otherThingLabel.mas_bottom).offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_offset(21);
        
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.ohterThingTextField.mas_bottom).offset(0);
        make.left.mas_offset(8);
        make.right.mas_offset(8);
        make.bottom.mas_offset(0);
    }];
    
    [super updateConstraints];
}

-(void)clickThrowButton {
    
    [self hideAlertView];

    [self.delegate throwTomatoDelegate];

}

-(void)hideAlertView {

    [UIView animateWithDuration:0.4 animations:^{
       
        self.shadowView.alpha = 0;
        
        self.alpha = 0;

        
    } completion:^(BOOL finished) {
        
        CGRect shadowViewFrame = self.shadowView.frame;
        
        shadowViewFrame.origin.y = -kScreenHeight;
        
        self.shadowView.frame = shadowViewFrame;
        
        self.frame = CGRectMake((kScreenWidth-kWidth)/2,-kHeight, kWidth, kHeight);
        
    }];
    

    


}

-(void)show {

//    [[UIApplication sharedApplication].keyWindow addSubview:self.shadowView];
//    
//    CGFloat width = 250;
//    
//    CGFloat height = 360;
////
//    self.frame = CGRectMake((kScreenWidth-width)/2,-height, width, height);
//
//    UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
//    CAShapeLayer*maskLayer=[[CAShapeLayer alloc] init];
//    
//    maskLayer.frame=self.bounds;
//    
//    maskLayer.path=maskPath.CGPath;
//    
//    self.layer.mask=maskLayer;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    
//    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.shadowView.alpha = 1;
        
    }];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.toValue = [NSValue valueWithCGRect:CGRectMake((kScreenWidth-kWidth)/2,(kScreenHeight-kHeight)/2, kWidth, kHeight)];
    
    [self pop_addAnimation:animation forKey:@""];
    
}



#pragma mark tableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self hideAlertView];
    
    [self.delegate addTomatoToGoalWithName:self.goalNames[indexPath.row]];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goalNames.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFAlertViewTableViewCell *cell = (XFAlertViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kAlertViewCellIdentifier];
    
    if (cell == nil) {
    
        cell = (XFAlertViewTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"XFAlertViewTableViewCell" owner:nil options:nil] lastObject];
        
        cell.nameLabel.text = self.goalNames[indexPath.row];
    }
    
    
    return  cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

-(NSArray *)goalNames {

    if (_goalNames == nil) {
        
        
        XFCoreDataManager *manager = [XFCoreDataManager shareManager];
        
        NSArray *allGoals = [manager allGoals];
        
        NSMutableArray *allNames = [NSMutableArray array];
        
        for (Goal *goal in allGoals) {
            NSString *name = goal.name;
            
            [allNames addObject:name];
            
        }
        _goalNames = allNames.copy;
    
    }
    return _goalNames;
}

@end
