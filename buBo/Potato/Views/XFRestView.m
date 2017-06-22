//
//  XFRestView.m
//  buBo
//
//  Created by mr.zhou on 2017/6/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFRestView.h"

#define kRestViewHeight 210

@interface XFRestView  ()

@property (nonatomic,assign) NSInteger seconds;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation XFRestView

-(instancetype)init {

    if (self = [super init]) {
        
        _shadowView = [[UIView alloc] init];
        
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.599];
        
        _shadowView.alpha = 0;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_shadowView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        self.frame = CGRectMake((kScreenWidth - kAlertViewWidth)/2, -kRestViewHeight, kAlertViewWidth, kRestViewHeight);
        
        self.layer.cornerRadius = 10;
        
        self.layer.masksToBounds = YES;
        
        _backView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, kAlertViewWidth, kRestViewHeight))];
        
        _backView.image = [UIImage imageNamed:@"rest"];
        
        [self addSubview:_backView];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        effectView.frame = _backView.bounds;
        
        [_backView addSubview:effectView];
        
        _topView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kAlertViewWidth, 40))];
        
        _topView.backgroundColor = kNavigationBarColor;
        
        [self addSubview:_topView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, kAlertViewWidth, 40))];
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_topView addSubview:_titleLabel];
        
        _titleLabel.text = @"要休息一下吗";
        
        _titleLabel.textAlignment = UITextAlignmentCenter;
        
        _timeLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 80, kAlertViewWidth, 50))];
    
        
        _timeLabel.text = @"05:00";
        
        _timeLabel.textColor = [UIColor whiteColor];
        
        _timeLabel.textAlignment = UITextAlignmentCenter;

        _timeLabel.font = [UIFont systemFontOfSize:30];
        
        [self addSubview:_timeLabel];
        
        _restButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 180, kAlertViewWidth/2, 30))];
        
        [_restButton setTitle:@"休息一下" forState:(UIControlStateNormal)];
        
        [_restButton setBackgroundColor:[UIColor whiteColor]];

        [_restButton.titleLabel setTextColor:[UIColor blackColor]];
        
        [_restButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [_restButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
        
        [_restButton addTarget:self action:@selector(restBegin) forControlEvents:(UIControlEventTouchUpInside)];
        
        _restButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_restButton];
        
        _cancelButton = [[UIButton alloc] initWithFrame:(CGRectMake(kAlertViewWidth/2, 180, kAlertViewWidth/2, 30))];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_restButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];

        [_cancelButton setTitle:@"不需要" forState:(UIControlStateNormal)];
        [_cancelButton.titleLabel setTextColor:[UIColor blackColor]];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];

        
        [self addSubview:_cancelButton];
        
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIView *line = [[UIView alloc] initWithFrame:(CGRectMake(kAlertViewWidth/2, 180, 0.5, 30))];
        
        line.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:line];
        
        [self addObserver:self forKeyPath:@"seconds" options:(NSKeyValueObservingOptionNew) context:@""];
        
    }
    return self;
}

-(void)dealloc {

    [self removeObserver:self forKeyPath:@"seconds"];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {


    if (self.seconds == 0) {
    
        [self.timer invalidate];
        
        self.timer = nil;
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        HUD.mode = MBProgressHUDModeText;
        
        HUD.detailsLabel.text = @"休息完毕";
        
        [HUD hideAnimated:YES afterDelay:3];
        
        [self cancelButtonClick];
    }

}


-(void)show {

    self.shadowView.frame = [UIScreen mainScreen].bounds;
    
    [UIView animateWithDuration:0.3 animations:^{
        
       
        self.shadowView.alpha = 1;

        
    }];

    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.springBounciness = 10;
    
    animation.toValue = [NSValue valueWithCGRect:(CGRectMake((kScreenWidth - kAlertViewWidth)/2, (kScreenHeight - kRestViewHeight)/2, kAlertViewWidth, kRestViewHeight))];
    
    [self pop_addAnimation:animation forKey:@""];
    
}

-(void)restBegin {

    self.seconds =  5*60;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        self.seconds -= 1;
        
        NSString *minute = self.seconds/60>9?[NSString stringWithFormat:@"%zd",self.seconds/60]:[NSString stringWithFormat:@"0%zd",self.seconds/60];
        
        NSString *sec = self.seconds%60>9?[NSString stringWithFormat:@"%zd",self.seconds%60]:[NSString stringWithFormat:@"0%zd",self.seconds%60];

        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,sec];
        
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    

}

-(void)cancelButtonClick {

    [UIView animateWithDuration:0.5 animations:^{
       
        self.alpha = 0;
        
        self.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        [self.shadowView removeFromSuperview];
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
