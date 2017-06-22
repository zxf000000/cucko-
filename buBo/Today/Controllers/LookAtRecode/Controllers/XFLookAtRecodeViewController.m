//
//  XFLookAtRecodeViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

// 关于日期跳转计算的问题还没有很精确---------**//

#import "XFLookAtRecodeViewController.h"

#import "TestCollectionViewCell.h"
#import "XFCalenderViewModel.h"

#import "XFTopViewCellModel.h"

#import "XFLookAtRecodeCollectionViewCell.h"
#import "XFDayDataModel.h"

#import "XFDayDataTableViewCell.h"

#define kTableViewY  (weekViewHeight + kWeekdayViewHeight)
#define kTableViewHeight  (kScreenHeight - kTableViewY-20)
#define kMonthViewY (kWeekdayViewHeight)


@interface XFLookAtRecodeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,XFCalendarCellDidSelectedDelegate>

@property (strong, nonatomic)  UICollectionView *calendarView;



@property (strong,nonatomic) UICollectionView *weekCollectionView;

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIView *weekdayView;

@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
// tableView的数据源
@property (nonatomic,strong) NSArray *tableViewModels;
@property (nonatomic,assign) BOOL isMonth;
// date用于获取当月的天数,第一天周几
@property (nonatomic,strong) NSDate *date;

@property (nonatomic,assign) CGFloat screenWidth;
// 两个数据源
@property (nonatomic,strong) NSArray *dates;
@property (nonatomic,strong) NSArray *allWeeks;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIPanGestureRecognizer *pan;

@property (nonatomic,assign) CGFloat oldProgress;
// 被选择的日期所在的行数
@property (nonatomic,assign) NSInteger selectedItemTravel;
// 被选择的日期
@property (nonatomic,copy) NSString *selectedDate;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;
// 计算器
@property (nonatomic,strong) XFCalendarCalculater *calCulator;
// 选中的item位于month视图的位置
@property (nonatomic,assign) NSInteger sectionInMonthView;
// 选中的item位于week视图的位置
@property (nonatomic,assign) NSInteger sectionInWeekView;
// 选中的index位于weekView的index
@property (nonatomic,assign) NSInteger indexInWeekView;
// 选中的index位于monthView的index
@property (nonatomic,assign) NSInteger indexInMonthView;
// 被选中的weekCell
@property (nonatomic,strong) XFLookAtRecodeCollectionViewCell *selectedWeekCell;
// 被选中的monthCell
@property (nonatomic,strong) XFLookAtRecodeCollectionViewCell *selectedMonthCell;
// 上一个monthCell
@property (nonatomic,strong) NSIndexPath *lastMonthCellIndex;
// 上一个weekCell
@property (nonatomic,strong) NSIndexPath *lastWeekCellIndex;

// calendarView的上一个contentOffset
@property (nonatomic,assign) CGPoint weekViewLastOffset;
@property (nonatomic,assign) CGPoint monthViewLastOffset;
// 周一到周日的集合
@property (nonatomic,strong) NSArray *weekdayArr;
// 没有数据时候的view
@property (nonatomic,strong) UIView *tableViewNoneDataView;

@end

@implementation XFLookAtRecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupNoneDataView];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    self.calCulator = [[XFCalendarCalculater alloc] init];
    
    self.isMonth = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化星期显示的view
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 25))];
    
    view.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger i = 0 ; i < 7 ; i ++) {
    
        UILabel *label  = [[UILabel alloc] init];
        
        label.frame = CGRectMake(kScreenWidth/7*i, 0, kScreenWidth/7, 25);
        
        label.textAlignment = UITextAlignmentCenter;
        
        label.text = self.weekdayArr[i];
        
        label.font = [UIFont systemFontOfSize:14];
        
        switch (i) {
            case 0:
                
                label.textColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
                break;
            case 6:
                label.textColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
                break;
            default:
                
                label.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];

                break;
        }
        [view addSubview:label];
    }
    
    [self setupMonthView];
    
    [self setupWeekView];
    
    [self setupScrollView];
    
    [self.view insertSubview:view aboveSubview:self.calendarView];


    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesBegin:)];
    
    [self.view addGestureRecognizer:self.pan];
    
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
//
    [self.calendarView.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
    
    [self.weekCollectionView.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
    
    self.pan.delegate = self;
    
    [self.pan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew  context:@"context"];
    
}

//初始化没有数据的view
-(void)setupNoneDataView {

    self.tableViewNoneDataView = [[UIView alloc] initWithFrame:(CGRectMake(0, kTableViewY, kScreenWidth, kTableViewHeight))];
    
    self.tableViewNoneDataView.backgroundColor = [UIColor greenColor];

}

// 设置导航栏
-(void)setupNavigationBar {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:UIBarMetricsDefault ];
    
    self.title = @"时间轴";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置左边按钮
    UIButton *menuButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:(UIControlStateNormal)];
    
    [menuButton addTarget:self action:@selector(clickLeftButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;

}
// 菜单按钮点击
-(void)clickLeftButton {
    
    if ([self.delegate respondsToSelector:@selector(timeLineSlideViewDelegate)]) {
    
        [self.delegate timeLineSlideViewDelegate];
    }

}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    // 每次进入视图的时候应该停留在今天的位置
    self.selectedDate = [self.dateFormatter stringFromDate:[NSDate date]];
    
    // 获取今天的index
    // 周几
    
//    NSInteger weekday = [self.calCulator getWeekdayForDate:[NSDate date]];
    
    NSInteger index = [self.calCulator getIndexInMonthWithDate:[NSDate date]];
    
    [self calendarCellDidSelectedDelegateWithDate:self.selectedDate AndIndex:index];
    
    [self.weekCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.sectionInWeekView inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
    
    [self.calendarView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.sectionInMonthView inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    
    
    [self setOffset];
   

}

// 保存两个calendarView的offset
-(void)setOffset {

    self.weekViewLastOffset = self.weekCollectionView.contentOffset;
    self.monthViewLastOffset = self.calendarView.contentOffset;


}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    

    if (scrollView == self.calendarView | scrollView == self.weekCollectionView) {
    
        if (self.isMonth && self.calendarView.contentOffset.x == self.monthViewLastOffset.x) {
            
            return ;
        
        
        }
        
        if (!self.isMonth && self.weekCollectionView.contentOffset.x == self.weekViewLastOffset.x) {
            
            return;
        
        }
        
        
        // 在这里获取上一个cell和下一个cell
        // 获取contentOffset
        CGPoint calendarViewOffset = self.calendarView.contentOffset;
        
        CGPoint weekViewOffset = self.weekCollectionView.contentOffset;
        

        //
        TestCollectionViewCell *calendarCell = nil;
        // month视图的操作
        if (self.isMonth) {
            
            for (id cell in self.calendarView.subviews) {
                
                if([cell isKindOfClass:[TestCollectionViewCell class]]) {
                    
                    calendarCell = (TestCollectionViewCell *)cell;
                    
                    if (calendarCell.frame.origin.x != calendarViewOffset.x) {
                        
                        [calendarCell.collectionView reloadData];
                        
                    } else {
                        
                        [calendarCell.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
                        // 选中这一天之后还要传值给控制器
                        
                        XFLookAtRecodeCollectionViewCell *subCell = (XFLookAtRecodeCollectionViewCell *)[calendarCell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

                        
                        [self calendarCellDidSelectedDelegateWithDate:subCell.dateStr AndIndex:0];
                        
                    }
                    
                }
                
            }
            
        }
        
        // week视图的操作
        if (self.isMonth == NO) {
            
            
            for (id cell in self.weekCollectionView.subviews) {
                
                if([cell isKindOfClass:[TestCollectionViewCell class]]) {
                    
                    calendarCell = (TestCollectionViewCell *)cell;
                    
                    if (calendarCell.frame.origin.x != weekViewOffset.x) {
                        
                        [calendarCell.collectionView reloadData];
                        
                    } else {
                        
                        [calendarCell.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
                        // 选中这一天之后还要传值给控制器
                        XFLookAtRecodeCollectionViewCell *subCell = (XFLookAtRecodeCollectionViewCell *)[calendarCell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                        
                        [self calendarCellDidSelectedDelegateWithDate:subCell.dateStr AndIndex:[self.calCulator getIndexInMonthWithDate:[[NSDateFormatter dayDateFormatter] dateFromString:subCell.dateStr]]-1];
                        
                    }
                    
                }
                
            }
            
        }
    
    } else {
    
        
    
    }

}

-(void)dealloc {
    
    [self.pan removeObserver:self forKeyPath:@"state" context:@"context"];
}
// cell的代理方法---chuan被选中的date
-(void)calendarCellDidSelectedDelegateWithDate:(NSString *)date AndIndex:(NSInteger)index{
    // 赋值
    self.selectedDate = date;
    
    // 计算选中的日期是多少组(week视图)--多少组和行(month视图)
    
        // month视图中的section
    self.sectionInMonthView = [self.calCulator getNumberOfMonthSectionWithDate:[self.dateFormatter dateFromString:self.selectedDate]];
    // week视图中的section
    self.sectionInWeekView = [self.calCulator getNumberOfWeekSectionWithDate:[self.dateFormatter  dateFromString:self.selectedDate]];
    
    
    // 在月视图中的第几行
    // 这个要通过日期来算,不能通过这个index算
    // 根据date计算位于多少位置
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    formatter.dateFormat = @"yyyy-MM-dd";
    // index从0开始
    // indexInMonth从1开始
    NSInteger indexInMonth = [self.calCulator getIndexInMonthWithDate:[formatter dateFromString:date]];
    // 获取今天周几
    NSInteger weekday = [self.calCulator getWeekdayForDate:[self.dateFormatter dateFromString:date]];
    
    self.indexInWeekView = weekday - 1;
    
    self.indexInMonthView = indexInMonth;

    if (self.isMonth) {
        
        self.indexInMonthView = index;
        
        self.selectedItemTravel = (index + 1)%7==0?(index+1)/7:(index+1)/7+1;
        
        
        [self.weekCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.sectionInWeekView inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
        
        [self setOffset];

        
    }
    
    if (self.isMonth == NO) {
        
        self.selectedItemTravel = (indexInMonth+1)%7==0?(indexInMonth+1)/7:(indexInMonth+1)/7+1;
        
        // 这个跳转还需要更精确一下
        [self.calendarView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.sectionInMonthView inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
        
        [self setOffset];

        
    
    }
    
}


// kvo的回调方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    //    这里需要判断tableView的位置
    // tableView 位于底部和顶部的时候要更改isMonth的状态
    // tableView 位于中间的时候要自动动画到指定位置
    
    // tableView的Y值
    CGFloat tableViewY = self.tableView.frame.origin.y;
    // 中间点位置
    CGFloat middleY = kWeekdayViewHeight + weekViewHeight + (monthViewHeight - weekViewHeight)/2.f;
    
    if (self.pan.state == UIGestureRecognizerStateBegan) {
    
        if (!self.isMonth) {
            
            
            
            TestCollectionViewCell *cell = (TestCollectionViewCell *)[self.calendarView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.sectionInMonthView inSection:0]];
//
            [cell.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.indexInMonthView inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
            
            
            

            
        }
        
    }
    
    if (self.pan.state == UIGestureRecognizerStateEnded) {
        // 在下面的时候
        if (tableViewY > middleY) {
        
            [UIView animateWithDuration:0.2 animations:^{
                
                self.tableView.frame = CGRectMake(0, kMonthViewY + monthViewHeight, kScreenWidth, kTableViewHeight);
                
                self.calendarView.frame = CGRectMake(0, kMonthViewY, kScreenWidth, monthViewHeight);

            } completion:^(BOOL finished) {
                
                self.isMonth = YES;

            }];
            
            
            
            return;
            
        } else if (tableViewY <= middleY){
        
            
            // 在上面的时候
            [UIView animateWithDuration:0.2 animations:^{
                
                self.tableView.frame = CGRectMake(0, kTableViewY, kScreenWidth, kTableViewHeight);

                self.calendarView.frame = CGRectMake(0, kWeekdayViewHeight-((kMonthAndWeekViewSpace+kDayCellDimeter)*(self.selectedItemTravel-1)), kScreenWidth, monthViewHeight);
                

                
            } completion:^(BOOL finished) {
                
                self.calendarView.alpha = 0;

                self.weekCollectionView.alpha = 1;
//
                // 获取当前选择的cell
                TestCollectionViewCell *cell = (TestCollectionViewCell *)[self.weekCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.sectionInWeekView inSection:0]];
                
//                // 获取cell中的item
                
                [cell.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.indexInWeekView inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
                
                self.isMonth = NO;
                
            }];
        }

    }
    
}


// pan的代理方法
-(void)panGesBegin:(UIPanGestureRecognizer *)pan {
    
    // 必须是这两种状态才可以,拖拽完毕的状态会有kvo检测,与这个方法互相影响
    if (pan.state == UIGestureRecognizerStateChanged | pan.state ==UIGestureRecognizerStateBegan) {
    
        if (self.isMonth) {
        
            CGPoint translation = [pan translationInView:self.view];
            
            float yTranslation = 0.0;
            
            if (fabs(translation.y) > (monthViewHeight - weekViewHeight)) {
                
                yTranslation = -(monthViewHeight - weekViewHeight);
                
            } else if (translation.y > 0){
                
                yTranslation = 0;
            } else {
                
                yTranslation = translation.y;
            }
            
            CGFloat progress = yTranslation/(monthViewHeight - weekViewHeight);
            
            CGRect frame = self.tableView.frame;
            
            frame.origin.y = (monthViewHeight - weekViewHeight)*progress + (kWeekdayViewHeight + monthViewHeight);
            
            self.tableView.frame = frame;
            // 这里需要更改calenderView的frame,使其与tableView联动
            // 与被选择的日期的行数关联
            
            // 总需要移动的距离
            CGFloat calenderTransY = (kDayCellDimeter+kMonthAndWeekViewSpace) * (self.selectedItemTravel - 1);
            
            CGRect calenderFrame = self.calendarView.frame;
            // 根据百分比来移动
            
            calenderFrame.origin.y = progress*calenderTransY + kWeekdayViewHeight;
            
            self.calendarView.frame = calenderFrame;
            
            [self.view layoutIfNeeded];
            
        } else if (!self.isMonth) {
            
                
                    self.calendarView.alpha = 1;
                    self.weekCollectionView.alpha = 0;
            
            
            CGPoint translation = [pan translationInView:self.view];
            
            float yTranslation = 0.0;
            
            if (translation.y > (monthViewHeight - weekViewHeight)) {
                
                yTranslation = monthViewHeight - weekViewHeight;
                
            } else if (translation.y < 0){
                
                yTranslation = 0;
                
            } else {
                
                yTranslation = translation.y;
            }
            
            CGFloat progress = yTranslation/(monthViewHeight - weekViewHeight);
            
            CGRect frame = self.tableView.frame;
            
            frame.origin.y = (monthViewHeight - weekViewHeight)*progress + ( kWeekdayViewHeight + weekViewHeight);
            
            self.tableView.frame = frame;
            // 这里需要更改calenderView的frame,使其与tableView联动
            // 与被选择的日期的行数关联
            
            // 总需要移动的距离
            CGFloat calenderTransY = (kDayCellDimeter+kMonthAndWeekViewSpace) * (self.selectedItemTravel - 1);
            
            CGRect calenderFrame = self.calendarView.frame;
            // 根据百分比来移动
            
            calenderFrame.origin.y = progress*calenderTransY - ((kDayCellDimeter+kMonthAndWeekViewSpace)*(self.selectedItemTravel-1)) + kWeekdayViewHeight;
            
            
            self.calendarView.frame = calenderFrame;
            
            [self.view layoutIfNeeded];
            
        }

    
    }
    
    
}



-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.pan velocityInView:self.view];
        
        if (self.isMonth) {
        
            return velocity.y < 0;
        
        } else if (!self.isMonth) {
            
            return velocity.y > 0;
            
            
        
        }
        
    }
    return shouldBegin;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {



}

// 初始化month视图
-(void)setupMonthView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.calendarView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,kWeekdayViewHeight, kScreenWidth, monthViewHeight) collectionViewLayout:layout];
    
    layout.itemSize = CGSizeMake(kScreenWidth, monthViewHeight);
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UINib *nib = [UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil];
    
    [self.calendarView registerNib:nib forCellWithReuseIdentifier:@"calendarView"];
    
    self.calendarView.delegate = self;
    
    self.calendarView.dataSource = self;
    
    self.calendarView.pagingEnabled = YES;
    
    [self.view addSubview:self.calendarView];
    
    
    self.calendarView.alpha = 0.5;
    
    if (self.isMonth) {
    
        self.calendarView.alpha = 1;
    } else {
    
        self.calendarView.alpha = 0;
    }
    
}
// 初始化week视图
-(void)setupWeekView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(kScreenWidth, weekViewHeight);
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.weekCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0,kWeekdayViewHeight, kScreenWidth, weekViewHeight)) collectionViewLayout:layout];
    
    [self.view addSubview:self.weekCollectionView];
    
    self.weekCollectionView.alpha = 0;
    
    
    self.weekCollectionView.delegate = self;
    self.weekCollectionView.dataSource = self;
    
    self.weekCollectionView.pagingEnabled = YES;
    
    UINib *nib = [UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil];
    
    [self.weekCollectionView registerNib:nib forCellWithReuseIdentifier:@"calendarView"];
    
    
    self.weekCollectionView.alpha = self.isMonth?0:1;
    

}
#pragma mark 初始化tableView
-(void)setupScrollView {
    
    
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableViewY, kScreenWidth, kTableViewHeight)];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.bounces = NO;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tableViewModels.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XFDayDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFDayDataTableViewCell"];
    
    if (cell == nil) {
    
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFDayDataTableViewCell" owner:nil options:0] lastObject];
    
    }
    
    cell.model = self.tableViewModels[indexPath.row];
    
    return cell;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.calendarView) {
        
        return  self.dates.count;
        
    } else if (collectionView == self.weekCollectionView){
        
        return self.allWeeks.count;
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.calendarView) {
        TestCollectionViewCell *cell = (TestCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"calendarView" forIndexPath:indexPath];
        
        cell.date = self.dates[indexPath.item];
        
        cell.delegate = self;
        
        return cell;
        
        
    } else if (collectionView == self.weekCollectionView){
        TestCollectionViewCell *cell = (TestCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"calendarView" forIndexPath:indexPath];
        
        cell.weekDate = self.allWeeks[indexPath.item];
        
        cell.delegate = self;
                
        return cell;
    }
    
    return nil;
}

-(NSArray *)dates {
    
    if (_dates == nil) {
        
        _dates = [XFTopViewCellModel dates];
    }
    return _dates;
    
}

-(NSArray *)allWeeks {
    
    if (_allWeeks == nil) {
        
        _allWeeks = [XFTopViewCellModel weekFirstDays];
        
    }
    return _allWeeks;
}

-(NSArray *)tableViewModels {
    
    return [XFDayDataModel modelsWithDate:self.selectedDate].copy;

}

-(void)setSelectedDate:(NSString *)selectedDate {

    _selectedDate = selectedDate;
    
    [self.tableView reloadData];

}

-(NSArray *)weekdayArr {

    if (_weekdayArr == nil) {
    
        NSMutableArray *arr = [NSMutableArray array];
        
        [arr addObject:@"周日"];
        [arr addObject:@"周一"];
        [arr addObject:@"周二"];
        [arr addObject:@"周三"];
        [arr addObject:@"周四"];
        [arr addObject:@"周五"];
        [arr addObject:@"周六"];

        _weekdayArr = arr.copy;
    
    }
    return  _weekdayArr;
}

@end
