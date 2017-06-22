//
//  TestCollectionViewCell.h
//  collectionViewTest
//
//  Created by mr.zhou on 2017/5/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFLookAtRecodeCollectionViewCell;

@protocol XFCalendarCellDidSelectedDelegate <NSObject>

-(void)calendarCellDidSelectedDelegateWithDate:(NSString *)date AndIndex:(NSInteger)index;

@end
@interface TestCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSDate *date;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) id<XFCalendarCellDidSelectedDelegate> delegate;

@property (nonatomic,strong) NSDate *weekDate;

@property (nonatomic,strong) NSIndexPath *selectedWeekIndexPath;

@property (nonatomic,strong) XFLookAtRecodeCollectionViewCell *selectedWeekCell;

@property (nonatomic,strong) NSIndexPath *selectedMonthIndexPath;

@property (nonatomic,strong) XFLookAtRecodeCollectionViewCell *selectedMonthCell;

@end
