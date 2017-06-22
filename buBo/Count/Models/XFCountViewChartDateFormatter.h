//
//  XFCountViewChartDateFormatter.h
//  buBo
//
//  Created by mr.zhou on 2017/5/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "buBo-Bridging-Header.h"
#import "buBo-Swift.h"
@interface XFCountViewChartDateFormatter : NSObject <IChartAxisValueFormatter>


@property (nonatomic,strong) NSArray *weekArray;

@property (nonatomic,strong) NSArray *monthArray;
@property (nonatomic,strong) NSArray *dayArray;
// 类型
@property (nonatomic,assign) NSInteger type;

-(instancetype)initWithWeekArray:(NSArray *)weekArray;
-(instancetype)initWithMonthArray:(NSArray *)monthArray;
-(instancetype)initWithDayArray:(NSArray *)dayArray;

@end
