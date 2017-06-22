//
//  HallViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "HallViewController.h"
#import "XFMineViewController.h"
#import "XFTodayViewController.h"
#import "XFCountViewController.h"
#import "XFEverydayViewController.h"
#import "XFMenuTableViewController.h"
#import "XFLookAtRecodeViewController.h"
#import "XFPotatoViewController.h"
#import "XFAddGoalViewController.h"
#import "XFAboutViewController.h"

@interface HallViewController () <XFSlideDelegate,XFClickMenuCellDelegate,UIGestureRecognizerDelegate,XFCountSlideDelegate,XFGoalListSlideDelegate,XFTimeLineSlideDelegate>
/**
 *  子控制器
 */
@property (nonatomic,strong) NSArray *childViews;
/**
 *  遮罩层
 */
@property (nonatomic,strong) UIView *shadowView;
/**
 *  拖拽手势--用于实现抽屉效果
 */
@property (nonatomic,strong) UIPanGestureRecognizer *pan;

@property (nonatomic,assign) BOOL menuIsOut;

@property (nonatomic,strong) RTRootNavigationController *selectedVC;

@end

@implementation HallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuIsOut = NO;
    
    [self setupSubViews];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesBegin)];
    
    [self.view addGestureRecognizer:self.pan];
    
    self.pan.delegate = self;
    // 监听pan手势的状态
    [self.pan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew  context:@"context"];

}

-(void)dealloc {

    [self.pan removeObserver:self forKeyPath:@"state"];

}
// kvo回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (self.pan.state == UIGestureRecognizerStateEnded) {
        // 同步滑动,所以取出一个
        RTRootNavigationController *nav = self.childViews[1];
        CGFloat x = nav.view.frame.origin.x;
        CGFloat distance = kScreenWidth * 0.8;
            // 判断位置
            if (x>= distance/2) {
            
                [self slideViews];
            
            
            } else {
                
                for (NSInteger i = 1 ; i < self.childViews.count ; i++) {
                    
                    RTRootNavigationController *navVC = self.childViews[i];
                    
                    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                    
                    animation.toValue = [NSValue valueWithCGRect:(CGRectMake(0, 0, kScreenWidth, kScreenHeight))];
                    
                    animation.springBounciness = 10;
                    
                    [navVC.view pop_addAnimation:animation forKey:@""];
                }
                
                POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                
                animation.toValue = [NSValue valueWithCGRect:(CGRectMake(0, 0, kScreenWidth, kScreenHeight))];
                
                animation.springBounciness = 10;
                
                [self.shadowView pop_addAnimation:animation forKey:@""];

                self.menuIsOut = NO;
            }
        
    
    }
    

}

// 拖拽手势
-(void)panGesBegin {
    
    if (self.menuIsOut) {
    
        if (self.pan.state == UIGestureRecognizerStateBegan) {
            
            self.shadowView.alpha = 0;
        }
    
    }
    

    
    // 这两种状态的时候可以开始滑动
    if (self.pan.state == UIGestureRecognizerStateBegan | self.pan.state == UIGestureRecognizerStateChanged) {
    
        CGPoint trans = [self.pan translationInView:self.view];
        
        CGFloat distance = kScreenWidth * 0.8;
        
        float xTranslation = 0.0;
        
        if (!self.menuIsOut) {
        
            if (trans.x > distance) {
                
                xTranslation = distance;
                
            } else if (trans.x < 0){
                
                xTranslation = 0;
                
            } else {
                
                xTranslation = trans.x;
            }
            
            CGFloat progress = xTranslation/(distance);
            
            // 滑动
            for ( NSInteger i = 1; i<self.childViews.count; i++) {
                
                RTRootNavigationController *nav = self.childViews[i];
                
                CGRect frame = nav.view.frame;
                
                frame.origin.x = distance * progress;
                
                nav.view.frame = frame;
            }

            
        
        } else {
            // 向左滑动
            if (trans.x < -distance) {
            
                xTranslation = -distance;
            
            } else if (trans.x > 0) {
                
                xTranslation = 0;
            
            } else {
            
                xTranslation = trans.x;
            }
        
            CGFloat progress = xTranslation/(distance);
            
            // 滑动
            for ( NSInteger i = 1; i<self.childViews.count; i++) {
                
                RTRootNavigationController *nav = self.childViews[i];
                
                CGRect frame = nav.view.frame;
                
                frame.origin.x = distance + distance * progress;
                
                nav.view.frame = frame;
            }
            
        }
        
        
    
    }
    
}
/**
 *  判断拖拽手势开始条件
 *
 *  @param gestureRecognizer 拖拽手势
 *
 *  @return 是否开始
 */
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    CGPoint vel = [self.pan velocityInView:self.view];
    
    if (!self.menuIsOut) {
        
        return vel.x > 0;
    
    } else {
    
        return vel.x < 0;

    }

}


-(void)slideViews {

    [self.selectedVC.view addSubview:self.shadowView];
    
//    
//    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    
//    animation.toValue = [NSValue valueWithCGRect:(CGRectMake(kScreenWidth * 0.8, 0, kScreenWidth, kScreenHeight))];
//    
//    animation.springBounciness = 10;
//    
//    [self.shadowView pop_addAnimation:animation forKey:@""];
//    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.shadowView.alpha = 0.6;

    }];
//
    for (NSInteger i = 1 ; i < self.childViews.count ; i++) {
    
        RTRootNavigationController *navVC = self.childViews[i];
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        animation.toValue = [NSValue valueWithCGRect:(CGRectMake(kScreenWidth*0.8, 0, kScreenWidth, kScreenHeight))];
        
        animation.springBounciness = 10;

        [navVC.view pop_addAnimation:animation forKey:@""];
        

        
    }
    
    self.menuIsOut = YES;
    
}
// 点击遮罩
-(void)tapShadowView {

    [UIView animateWithDuration:0.15 animations:^{
        
        self.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        for (NSInteger i = 1 ; i < self.childViews.count ; i++) {
            
            RTRootNavigationController *navVC = self.childViews[i];
            
            POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            
            animation.toValue = [NSValue valueWithCGRect:(CGRectMake(0, 0, kScreenWidth, kScreenHeight))];
            
            animation.springBounciness = 10;
            
            [navVC.view pop_addAnimation:animation forKey:@""];
        }
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        animation.toValue = [NSValue valueWithCGRect:(CGRectMake(0, 0, kScreenWidth, kScreenHeight))];
        
        animation.springBounciness = 10;
        
        [self.shadowView pop_addAnimation:animation forKey:@""];
        
    }];
    
    self.menuIsOut = NO;

}
// 选择menu代理
-(void)clickMenuCellDelegateWith:(NSInteger)row {

    if (row == self.childViews.count - 1) {
        
        XFAboutViewController *aboutVC = [[XFAboutViewController alloc] init];
        
        [self presentViewController:aboutVC animated:YES completion:^{
           
            
            
        }];
    
    } else  {
    
        for (NSInteger i = 1; i < self.childViews.count ;i ++) {
            
            RTRootNavigationController *nav = self.childViews[i];
            
            if (row == self.childViews.count-1) {
                
                //            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"XFAddGoalViewController" bundle:nil];
                //
                //            XFAddGoalViewController *addGoalVC = [sb instantiateViewControllerWithIdentifier:@"XFAddGoalViewController"];
                //
                //            [self presentViewController:addGoalVC animated:YES completion:^{
                //
                //
                //            }];
                
            } else {
                
                if (i != row) {
                    
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        nav.view.alpha = 0;
                    }];
                    
                } else if (i == row ){
                    
                    self.shadowView.alpha = 0.7;
                    
                    [nav.view addSubview:self.shadowView];
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        nav.view.alpha = 1;
                    }];
                    
                    self.selectedVC = nav;
                    
                }
                
                
            }

    
        }

    }
}

// 滑动代理
-(void)slideViewDelegate {

    [self slideViews];

}
-(void)countSlideViewDelegate {

    [self slideViews];

}

-(void)timeLineSlideViewDelegate {

    [self slideViews];


}

-(void)goalListSlideViewDelegate {

    [self slideViews];

}

-(void)setupSubViews {
    // 创建‘我的’控制器
    XFMineViewController *minVC = [[XFMineViewController alloc] init];
    // 创建'统计'控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"XFCountViewController" bundle:nil];
    XFCountViewController *countVC = [sb instantiateViewControllerWithIdentifier:@"XFCountViewController"];
    // 创建'今天'控制器
    XFTodayViewController *todayVC = [[XFTodayViewController alloc] init];
    
    XFMenuTableViewController *menuVC = [[UIStoryboard storyboardWithName:@"Menu" bundle:nil] instantiateViewControllerWithIdentifier:@"XFMenuTableViewController"];
    // 时间轴控制器
    UIStoryboard *sbLookAt = [UIStoryboard storyboardWithName:@"XFTodayStoryboard" bundle:nil];
    
    XFLookAtRecodeViewController *lookRVC = [sbLookAt instantiateViewControllerWithIdentifier:@"XFLookAtRecodeViewController"];
    
    
    // 番茄控制器
    XFPotatoViewController *ptVC = [[UIStoryboard storyboardWithName:@"XFTodayStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"XFPotatoViewController"];
    

    //创建导航控制器
    RTRootNavigationController *navToday = [[RTRootNavigationController alloc] initWithRootViewController:todayVC];
    
    RTRootNavigationController *navMine = [[RTRootNavigationController alloc] initWithRootViewController:minVC];
    
    RTRootNavigationController *navCount = [[RTRootNavigationController alloc] initWithRootViewController:countVC];
    
    RTRootNavigationController *navTimeLine = [[RTRootNavigationController alloc] initWithRootViewController:lookRVC];
    RTRootNavigationController *navPotato = [[RTRootNavigationController alloc] initWithRootViewController:ptVC];

    // 设置阴影
//    navToday.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    navToday.view.layer.shadowOffset = CGSizeMake(-5, 0);
//    navToday.view.layer.shadowOpacity = 0.8;
//    
//    navMine.view.layer.shadowColor = [UIColor grayColor].CGColor;
//    navMine.view.layer.shadowOffset = CGSizeMake(-10, 0);
//    navMine.view.layer.shadowOpacity = 0.8;
//    
//    navCount.view.layer.shadowColor = [UIColor grayColor].CGColor;
//    navCount.view.layer.shadowOffset = CGSizeMake(-10, 0);
//    navCount.view.layer.shadowOpacity = 0.8;
//    
//    navTimeLine.view.layer.shadowColor = [UIColor grayColor].CGColor;
//    navTimeLine.view.layer.shadowOffset = CGSizeMake(-10, 0);
//    navTimeLine.view.layer.shadowOpacity = 0.8;
//    
//    navPotato.view.layer.shadowColor = [UIColor whiteColor].CGColor;
//    navPotato.view.layer.shadowOffset = CGSizeMake(-5, 0);
//    navPotato.view.layer.shadowOpacity = 0.5;
    // 添加的时候根据顺序添加
    // menu控制器
    [self addChildViewController:menuVC];
    [self.view addSubview:menuVC.view];
    // 番茄
    [self addChildViewController:navPotato];
    [self.view addSubview:navPotato.view];
    // 目标清单控制器
    [self addChildViewController:navToday];
    [self.view addSubview:navToday.view];
    // 时间轴控制器
    [self addChildViewController:navTimeLine];
    [self.view addSubview:navTimeLine.view];
    // 统计控制器
    [self addChildViewController:navCount];
    [self.view addSubview:navCount.view];
    // 设置控制器
    [self addChildViewController:navMine];
    [self.view addSubview:navMine.view];

    
    // 设置透明度
    navMine.view.alpha = 0;
    navTimeLine.view.alpha = 0;
    navCount.view.alpha = 0;
    navToday.view.alpha = 0;
    
    ptVC.delegate = self;
    
    menuVC.delegate = self;
    
    todayVC.delegate = self;
    
    countVC.delegate = self;
    
    lookRVC.delegate = self;
    self.selectedVC = navPotato;
}
// 懒加载
-(NSArray *)childViews {
    
    if (_childViews == nil) {
    
        _childViews = self.childViewControllers;

        
    }
    return _childViews;
}

-(UIView *)shadowView {

    if (_shadowView == nil) {
    
        _shadowView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight))];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadowView)];
        
        [_shadowView addGestureRecognizer:tap];
        
        _shadowView.alpha = 0;
        
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.609];
        
    }
    return _shadowView;
}

@end
