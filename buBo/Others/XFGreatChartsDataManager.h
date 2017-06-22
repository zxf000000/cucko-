//
//  XFGreatChartsDataManager.h
//  buBo
//
//  Created by mr.zhou on 2017/4/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goal+CoreDataClass.h"

@interface XFGreatChartsDataManager : NSObject
+(instancetype)shareManager ;

+(NSInteger)getIndexsOfXAxisWithData:(NSDate *)date;

+(NSArray *)getWeekWithWeekday:(NSInteger)weekday;

+(NSArray *)getHoursOfWeek:(NSArray *)week withGoalName:(NSString *)name;

@property (nonatomic,strong) NSArray *monthArr;

@property (nonatomic,strong) Goal *goal;

-(NSArray *)getMonthDataWithDate:(NSDate *)date  Goal:(Goal *)goal;


@end
