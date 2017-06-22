//
//  XFCoreDataManager.h
//  buBo
//
//  Created by mr.zhou on 2017/4/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Goal+CoreDataClass.h"
#import "AppDelegate.h"

@interface XFCoreDataManager : NSObject

@property (nonatomic,strong) NSArray *goals;

@property (nonatomic,strong) AppDelegate *appdelegate;
// 单例创建
+(instancetype)shareManager;

-(void)fetchData;

- (void)updateDataWithPropertyName:(NSString *)propertyName Value:(CGFloat)hours ;
// 获取首页的时间条数据
-(CGFloat)getIndexTimeViewData;

-(NSArray *)allGoals;
/**
 *  计算指定目标的总时间
 *
 *  @param name 目标名称
 *
 *  @return 总时间的秒数
 */
-(NSInteger )calculatorGoalsAllTimeWithGoal:(Goal *)goal;

/**
 *  获取指定目标的最近7天数据
 *
 *  @param goal 指定目标
 *
 *  @return 数组(周日到周六)
 */
- (NSArray *)getLastSevenDaysTimesWithGoal:(Goal *)goal;
/**
 *  更改指定目标的状态
 *
 *  @param status 状态
 */
- (void)changeGoalStatusWithStatus:(NSInteger)status Goal:(Goal *)goal;

@end
