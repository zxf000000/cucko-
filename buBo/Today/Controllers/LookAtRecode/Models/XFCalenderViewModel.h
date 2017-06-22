//
//  XFCalenderViewModel.h
//  buBo
//
//  Created by mr.zhou on 2017/5/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFCalendarCalculater.h"

@interface XFCalenderViewModel : NSObject

@property (nonatomic,strong) XFCalendarCalculater *calculator;

@property (nonatomic,strong) NSDateFormatter *formatter;

-(instancetype)initWithDate:(NSDate *)date;

// 获取按照周分组的数组
+(NSArray *)weekModels ;

// 获取按照月分组的数组
+(NSArray *)monthModels;

+(NSArray *)modelsWithDate:(NSDate *)date;
// 按照周分组的组头
-(NSArray *)weekSectionHeaderArray;
// 获取按照月分组的组头
-(NSArray *)monthSectionHeaderArray;


@end
