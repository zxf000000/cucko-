//
//  TestCollectionViewCell.m
//  collectionViewTest
//
//  Created by mr.zhou on 2017/5/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//
// 这个cell的数据源来源应该是每个月的第一天的日期

#import "TestCollectionViewCell.h"
#import "XFLookAtRecodeCollectionViewCell.h"
#import "XFCalenderViewModel.h"
#import "XFLookAtRecodeViewController.h"
#import "XFTopCalenderViewModel.h"


@interface TestCollectionViewCell () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *models;

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,assign) BOOL isMonth;

@property (nonatomic,strong) NSDateFormatter *formatter;

@property (nonatomic,assign) NSInteger firstdayWeekday;

@property (nonatomic,assign) NSInteger monthdayCount;

@end

@implementation TestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.formatter = [[NSDateFormatter alloc] init];
    
    self.formatter.dateFormat = @"yyyy-MM-dd";

}


-(UICollectionViewFlowLayout *)layout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(kDayCellDimeter, kDayCellDimeter);
    
    layout.minimumLineSpacing = kMonthAndWeekViewSpace;
    layout.minimumInteritemSpacing = kMonthAndWeekViewSpace;
    layout.sectionInset = UIEdgeInsetsMake(kMonthAndWeekViewInsert, kMonthAndWeekViewInsert, kMonthAndWeekViewInsert, kMonthAndWeekViewInsert);
    
    
    return layout;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.models.count;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFLookAtRecodeCollectionViewCell *cell = (XFLookAtRecodeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"XFLookAtRecodeCollectionViewCell" forIndexPath:indexPath];
    
    
    cell.dateStr = self.models[indexPath.item];
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.438 green:0.468 blue:0.917 alpha:1.000];

    cell.selectedBackgroundView.layer.cornerRadius = 17.5;
    
    if ([cell.dateStr isEqualToString:[self.formatter stringFromDate:[NSDate date]]]) {
    
        cell.dotView.image = [UIImage imageNamed:@"dot"];
        
    } else {
    
        cell.dotView.image = [UIImage imageNamed:@"clearPic"];
    }
    
    if (self.isMonth) {
    
        if (indexPath.item < self.firstdayWeekday-1 | indexPath.item>=(self.firstdayWeekday + self.monthdayCount-1)) {
            
            cell.numberLabel.textColor = [UIColor lightGrayColor];
        }else {
            
            cell.numberLabel.textColor = [UIColor blackColor];
        }
    
    }
    

    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    // 这里通过代理将数值传到上一层控制器
    
    if ([self.delegate respondsToSelector:@selector(calendarCellDidSelectedDelegateWithDate: AndIndex:)]) {
            
        [self.delegate calendarCellDidSelectedDelegateWithDate:self.models[indexPath.item] AndIndex:indexPath.item];
        
    }
    

    XFLookAtRecodeCollectionViewCell *cell = (XFLookAtRecodeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell) {
        [UIView animateWithDuration:0.1 animations:^{
            cell.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }
    
}

// week
-(void)setWeekDate:(NSDate *)weekDate {

    _weekDate = weekDate;
    
    _isMonth = NO;
    
    _models = [XFTopCalenderViewModel weekModelsWithDate:_weekDate];
    
    self.collectionView.allowsMultipleSelection = NO;
    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"XFLookAtRecodeCollectionViewCell" bundle:nil];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"XFLookAtRecodeCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    layout.itemSize = CGSizeMake(kDayCellDimeter, kDayCellDimeter);
    
    layout.minimumLineSpacing = kMonthAndWeekViewSpace;
    layout.minimumInteritemSpacing = kMonthAndWeekViewSpace;
    layout.sectionInset = UIEdgeInsetsMake(kMonthAndWeekViewInsert,kMonthAndWeekViewInsert, kMonthAndWeekViewInsert, kMonthAndWeekViewInsert);
    
    
    [self.collectionView reloadData];

}

// 这里只需要获取当月的数据

-(void)setDate:(NSDate *)date {
    
    _date = date;
    
    
    XFCalendarCalculater *calculator = [[XFCalendarCalculater alloc] init];
    
    NSInteger weekday = [calculator getWeekdayForDate:self.date];
    
    _firstdayWeekday = weekday;
    
    NSInteger monthdatCount = [calculator getDaysCountOfMonthWithDate:self.date];
    
    _monthdayCount = monthdatCount;
    
    _isMonth = YES;
    
    NSArray *array = [XFTopCalenderViewModel modelsWithDate:_date];
    
    _models = array;
    
    _layout = [self layout];
    
    _isMonth = YES;
    
    self.collectionView.allowsMultipleSelection = NO;
    
    self.collectionView.collectionViewLayout = self.layout ;
        
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    
    self.collectionView.bounces = NO;
    
    UINib *nib = [UINib nibWithNibName:@"XFLookAtRecodeCollectionViewCell" bundle:nil];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"XFLookAtRecodeCollectionViewCell"];
    
    [self.collectionView reloadData];


}




@end
