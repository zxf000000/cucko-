//
//  XFLineChartViewDataFormatter.h
//  buBo
//
//  Created by mr.zhou on 2017/5/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "buBo-Bridging-Header.h"
#import "buBo-Swift.h"
#import "AppDelegate.h"
#import "Goal+CoreDataClass.h"

@interface XFLineChartViewDataFormatter : NSObject <IChartAxisValueFormatter>
- (id)initForChart:(LineChartView *)chart Goal:(Goal *)goal Date:(NSDate *)date;
-(NSDictionary *)getMonthDataWithDate:(NSDate *)date ;
@property (nonatomic,strong) AppDelegate *appDelegate;

@property (nonatomic,strong) LineChartView *chartView;

@property (nonatomic,strong) Goal *goal;

@property (nonatomic,strong) NSArray *monthArr;

@property (nonatomic,strong) NSDate *date;
@end
