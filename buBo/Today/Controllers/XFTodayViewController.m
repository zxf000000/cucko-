//
//  XFTodayViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFTodayViewController.h"
#import "TodayMenus.h"
#import "TodayTableViewCell.h"
#import "manageGoalMenu.h"
#import "manageGoalTableViewCell.h"
#import "XFAddGoalViewController.h"
#import "XFLookAtRecodeViewController.h"
#import "XFLookAtViewController.h"
//震动
#import <AudioToolbox/AudioToolbox.h>
#import "XFCoreDataManager.h"

#import <RTRootNavigationController.h>

#import <Masonry.h>
#import "XFActionSheet.h"
#import "XFCrossRotateButton.h"

@interface XFTodayViewController () <UITableViewDelegate,UITableViewDataSource,ManageGoalButtonDelegate,TodayTableViewCellDelegate,XFActionSheetDelegate>

@property (nonatomic,weak) UIView *topView;

@property (nonatomic,weak) UILabel *todayTime;

@property (nonatomic,weak) UIView *investTimeView;

@property (nonatomic,weak) UIView *wasteTimeView;

@property (nonatomic,weak) UILabel *investTimeLabel;

@property (nonatomic,weak) UILabel *wasteTimeLabel;

@property (nonatomic,weak) UITableView *TableView;

// 两个按钮
@property (nonatomic,weak) UIButton *leftButton;
// 目标管理tableView
@property (nonatomic,weak) UITableView *manageGoalTableView;

@property (nonatomic,strong) NSMutableArray *manageGoalNemus;

@property (nonatomic,weak) manageGoalTableViewCell *manageGoalCell;

@property (nonatomic,assign) BOOL isRightButtonIsClicked;

// navigationBar 中间的选择器
@property (nonatomic,weak) UISegmentedControl *segmentedControl;

// 开始计时的cell
@property (nonatomic,strong) TodayTableViewCell *startedCell;

@property (nonatomic,assign) float invasterHours;

// 更多功能加号按钮
@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic,assign) CGRect navigationRightButtonFrame;

@property (nonatomic,strong) XFCrossRotateButton *rightButton;
@end

@implementation XFTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    [self initManageMenuData];
    
    [self setupTopView];
    [self setupTableView];
    
    [self setupTwoButton];
    
    [self autoLayout];

    [self setupNavigationBar];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.TableView reloadData];


}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    self.menus = nil;
    
    
}


// 设置navigationBar
- (void)setupNavigationBar {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:UIBarMetricsDefault ];
    
    self.title = @"目标清单";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置左边按钮
    UIButton *menuButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:(UIControlStateNormal)];
    
    [menuButton addTarget:self action:@selector(clickLeftButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 设置右边按钮
    
    self.rightButton = [[XFCrossRotateButton alloc] initWithFrame:(CGRectMake(0, 0, 25, 25))];
    
    [self.rightButton setImage:[UIImage imageNamed:@"today_more"] forState:(UIControlStateNormal)];
    
    [self.rightButton addTarget:self action:@selector(clickAddGoalButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationRightButtonFrame = self.navigationItem.rightBarButtonItem.customView.frame;

}
// 添加目标
-(void)clickAddGoalButton:(XFCrossRotateButton *)sender {
//
    [sender rotate];
    
    XFActionSheet *actionSheet = [[XFActionSheet alloc] initWithRightButtonFrame:self.navigationRightButtonFrame];
    
    [actionSheet show];
    
    actionSheet.delegate = self;
    
    
}

#pragma mark - actionSheetDelegate
-(void)buttonRotateBackDelegte {

    [self.rightButton rotate];

}

-(void)actionSheetDelegateWithNumber:(NSInteger)num ActionSheet:(XFActionSheet *)actionSheet{

    switch (num) {
        case 0:
        {
            
            [actionSheet tapShadowView];
            
            XFAddGoalViewController *addVC = [[UIStoryboard storyboardWithName:@"XFAddGoalViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"XFAddGoalViewController"];
            
            [self.rt_navigationController pushViewController:addVC animated:YES complete:^(BOOL finished) {
            
                    
            }];
            
        }
            break;
        case 1:
        {
            [actionSheet tapShadowView];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"XFAddGoalViewController" bundle:nil];
            
            UIViewController *manageGoalVC = [sb instantiateViewControllerWithIdentifier:@"XFManageGoalViewController"];
            
            [self.rt_navigationController pushViewController:manageGoalVC animated:YES];
            
            
        }
            
            break;
        case 2:
        {
            [actionSheet tapShadowView];

        
        }
            
            break;
        case 3:
        {
            [actionSheet tapShadowView];

        
        }
            
            break;
        default:
            break;
    }


}

-(void)clickLeftButton {

    if ([self.delegate respondsToSelector:@selector(goalListSlideViewDelegate)]) {
    
        [self.delegate goalListSlideViewDelegate];
    
    }

}



// 时间轴按钮点击事件
-(void)onClickClockButton {


//    
//    [self.rt_navigationController pushViewController:lookRVC animated:YES complete:^(BOOL finished) {
//        
//        
//        
//    }];
    
}

// cell开始计时的代理事件
- (void)todayCellDelegateWithCell:(TodayTableViewCell *)cell {
    // 吧开始计时的cell的indexPath存到数组中去,
    // 如何获取indexPath
    // 停止之前的cell的计时
    if (self.startedCell) {
    
        [self.startedCell changeToStop];
    }
    
    
    
    self.startedCell = cell;

    
}
// cell停止计时的代理
-(void)stopTimerDelegateWithCell:(TodayTableViewCell *)cell {

    self.startedCell = nil;

    // 获取时间数据
    XFCoreDataManager *manager = [XFCoreDataManager shareManager];
    
    self.invasterHours = [manager getIndexTimeViewData];
    // 重新布局
    
    [self.investTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.todayTime.mas_bottom).with.offset(5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-20)*self.invasterHours/24.f);
        
    }];
    
    [self.wasteTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.investTimeView.mas_bottom).with.offset(5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-20)*(24-self.invasterHours)/24.f);
        
    }];
    
    _investTimeLabel.text = [NSString stringWithFormat:@"%.1fh %.1f%@投资",self.invasterHours,self.invasterHours/24.f*100,@"%"];
    
    _wasteTimeLabel.text = [NSString stringWithFormat:@"%.1fh %.1f%@浪费",(24-self.invasterHours),(100 - self.invasterHours/24.f*100),@"%"];
    
    [self.TableView reloadData];


}

// segment的点击事件
- (void)onSelectedSegement {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
    
        case 0: {
        
        
        }
            break;
        case 1: {
        
        
        }
            break;
        default:
            
            break;
    
    }
    

}

// 目标编辑
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"XFTodayStoryboard" bundle:nil];
    
    XFLookAtViewController *lookVC = (XFLookAtViewController *)[sb instantiateViewControllerWithIdentifier:@"XFLookAtViewController"];
    
    Goal *menu = self.menus[indexPath.row];
    
    lookVC.goal = menu;
    
    [self.rt_navigationController pushViewController:lookVC animated:YES complete:^(BOOL finished) {
        

        
    }];

}
// 管理目标的tableView
- (void)setupManageGoalTableView {
    
    self.isRightButtonIsClicked = YES;
    
    UITableView *manageGoalTableView = [[UITableView alloc] init];
    
    self.manageGoalTableView = manageGoalTableView;
    
    
    [self.view addSubview:self.manageGoalTableView];
    
    [self.view bringSubviewToFront:self.manageGoalTableView];
    
    self.manageGoalTableView.dataSource = self;
    
    self.manageGoalTableView.delegate = self;
    // 根据rightButton设置frame
    CGRect rightButtonFrame = self.rightButton.frame;
    
    CGFloat x = rightButtonFrame.origin.x;
    CGFloat y = rightButtonFrame.origin.y;
    
    self.manageGoalTableView.frame = CGRectMake(x - 170, y - 200, 200, 160);
    
    self.manageGoalTableView.backgroundColor = [UIColor clearColor];

    
}

// 添加两个按钮
- (void)setupTwoButton{
    
//    UIButton *left = [[UIButton alloc] init];
//    left.layer.cornerRadius = 15;
//    
//    self.leftButton = left;
//    
//    UIButton *right = [[UIButton alloc] init];
//    right.layer.cornerRadius = 15;
//
//    self.rightButton = right;
//    self.rightButton.layer.shadowOffset = CGSizeMake(20, 20);
//    self.rightButton.layer.shadowColor = [UIColor grayColor].CGColor;
//    [self.rightButton setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:self.leftButton];
//    [self.view addSubview:self.rightButton];
//    
//    [self.view bringSubviewToFront:self.leftButton];
//    [self.view bringSubviewToFront:self.rightButton];
//    
//    self.leftButton.titleLabel.text = @"left";
//    self.rightButton.titleLabel.text = @"right";
//    
//    [self.rightButton setImage:[UIImage imageNamed:@"add"] forState:(UIControlStateNormal)];
//    self.leftButton.backgroundColor = [UIColor blueColor];
//    
//    [self.leftButton addTarget:self action:@selector(onClickLeftButton) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    [self.rightButton addTarget:self action:@selector(onClickRightButton) forControlEvents:(UIControlEventTouchUpInside)];
//    

}

// 点击左边按钮
- (void)onClickLeftButton{

    
    


}
// 点击右边按钮
- (void)onClickRightButton{
    
    if (self.isRightButtonIsClicked == NO) {
        
        [self setupManageGoalTableView];
        
    } else {
    
        [self.manageGoalTableView removeFromSuperview];
        
        self.isRightButtonIsClicked = NO;
        

    }
    

}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 50;
//}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 4;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    TodayTableViewCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"TodayTableViewCell" owner:nil options:nil] lastObject];
//
//    cell.menu = self.menus[section];
//    
//    return cell;
//
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.TableView) {
        
        TodayTableViewCell *cell = (TodayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    

        
        if (cell == nil) {
            
         cell = [[[NSBundle mainBundle] loadNibNamed:@"TodayTableViewCell" owner:nil options:nil] lastObject];

        }
        Goal *menu = self.menus[indexPath.row];
        
        cell.menu = menu;
        
        cell.delegate = self;
        
        if (indexPath == self.startedCell.indexPath) {
            
            cell = self.startedCell;
        }
        
        cell.indexPath = indexPath;

        
        return cell;
        
    } else {
        
        manageGoalTableViewCell *cell = (manageGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"manageCell"];
        
        if (cell == nil) {
            
            cell = [[manageGoalTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"manageCell"];
            
        }
        
        manageGoalMenu *menu = self.manageGoalNemus[indexPath.row];
        
        cell.menu = menu;
        
        cell.delegate = self;
        
        cell.imageButton.tag = indexPath.row;
        
        cell.backgroundColor = [UIColor clearColor];

        return cell;
    }
}

-(void)manageGoalButtonDelegate:(UIButton *)button {
    
    switch (button.tag) {
    
        case 0:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"XFAddGoalViewController" bundle:nil];
            
            UIViewController *manageGoalVC = [sb instantiateViewControllerWithIdentifier:@"XFManageGoalViewController"];
            
            [self.rt_navigationController pushViewController:manageGoalVC animated:YES];
        
        }
            
            break;
        case 1:
            
        {
            XFAddGoalViewController *addGoalVC = [[UIStoryboard storyboardWithName:@"XFAddGoalViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"XFAddGoalViewController"];
            
            self.menus = nil;
            
            [self.rt_navigationController pushViewController:addGoalVC animated:YES];
        
        }
            
            break;
            
        case 2:
            break;
            
        case 3:
            break;
            
        default:
            
            break;
    }


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.TableView) {
        
        return self.menus.count;
    }else {
    
        return 4;
    }
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.TableView) {

        return 50;
    } else {
    
        return 40;
    }
}

// 禁止向上滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.manageGoalTableView) {
    
        CGFloat off_y = scrollView.contentOffset.y;
        
        if (off_y != 0) {
            
            self.TableView.contentOffset = (CGPointMake(0, 0));
        }
    
    }
    


}


// 初始化tableView
-(void) setupTableView {

    UITableView *tableView = [[UITableView alloc] init];
    
    self.TableView = tableView;
    
    self.TableView.dataSource = self;
    
    self.TableView.delegate = self;
    
    [self.view addSubview:self.TableView];
    
    self.TableView.tableFooterView = [[UIView alloc] init];
    
}

// 初始化头部View
-(void) setupTopView {
    
    // 获取时间数据
    XFCoreDataManager *manager = [XFCoreDataManager shareManager];
    
    self.invasterHours = [manager getIndexTimeViewData];
    
    UIView *topView = [[UIView alloc] init];
    
    self.topView = topView;
    
    [self.view addSubview:self.topView];
    // 今天时间Label
    UILabel *todayTime = [[UILabel alloc] init];
    
    self.todayTime = todayTime;
    
    todayTime.text = @"今天时间";
    
    [self.topView addSubview:self.todayTime];
    
    // 投资时间条状图
    UIView *investTimeView = [[UIView alloc] init];
    
    self.investTimeView = investTimeView;
    
    investTimeView.backgroundColor = [UIColor greenColor];
    
    [self.topView addSubview:self.investTimeView];
    
    // 浪费时间条状图
    UIView *wasteTimeView = [[UIView alloc] init];
    
    self.wasteTimeView = wasteTimeView;
    
    self.wasteTimeView.backgroundColor = [UIColor redColor];
    
    [self.topView addSubview:self.wasteTimeView];
    
    //投资时间Label
    UILabel *investTimeLabel = [[UILabel alloc] init];
    
    investTimeLabel.text = [NSString stringWithFormat:@"%.1fh %.1f%@投资",self.invasterHours,self.invasterHours/24.f*100,@"%"];
    
    self.investTimeLabel = investTimeLabel;
    
    [self.topView addSubview:investTimeLabel];
    //浪费时间Labe''
    UILabel *wasteTimeLabel = [[UILabel alloc] init];
    
    wasteTimeLabel.text = [NSString stringWithFormat:@"%.1fh %.1f%@浪费",(24-self.invasterHours),(100 - self.invasterHours/24.f*100),@"%"];
    
    self.wasteTimeLabel = wasteTimeLabel;
    
    [self.topView addSubview:wasteTimeLabel];
    


}
// 自动布局
-(void)autoLayout {

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(100);
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_equalTo(0);
        
    }];
    
    [self.todayTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        
    }];
    
    [self.investTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todayTime.mas_bottom).with.offset(5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-20)*self.invasterHours/24.f);
        
    }];
    
    [self.wasteTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.investTimeView.mas_bottom).with.offset(5);
        make.left.mas_offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-20)*(24-self.invasterHours)/24.f);
        
    }];
    
    [self.investTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.mas_equalTo(self.investTimeView);
        
    }];
    
    [self.wasteTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.mas_equalTo(self.wasteTimeView);
        
    }];
    
    [self.TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(-46);
    }];
    // 两个Button
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-20);
        make.bottom.mas_offset(-100);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.rightButton.mas_left).offset(-20);
        make.bottom.mas_offset(-100);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        
    }];

}

- (void)initManageMenuData {

    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    self.manageGoalNemus = array;
    
    manageGoalMenu *menu1 = [[manageGoalMenu  alloc] initWithText:@"管理目标" Image:[UIImage imageNamed:@"manage"]];
    manageGoalMenu *menu2 = [[manageGoalMenu alloc] initWithText:@"添加目标" Image:[UIImage imageNamed:@"addGoal"]];
    manageGoalMenu *menu3= [[manageGoalMenu alloc] initWithText:@"查看记录" Image:[UIImage imageNamed:@"lookAt"]];
    manageGoalMenu *menu4 = [[manageGoalMenu alloc] initWithText:@"晨音计划" Image:[UIImage imageNamed:@"morning"]];
    
    [self.manageGoalNemus addObject:menu1];
    [self.manageGoalNemus addObject:menu2];
    [self.manageGoalNemus addObject:menu3];
    [self.manageGoalNemus addObject:menu4];


}

-(NSArray *)menus {

    if (_menus == nil) {
    
        _menus = [TodayMenus goals].copy;
    
    }
    return _menus;
}



@end
