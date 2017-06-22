//
//  XFTopCalenderViewModel.h
//  collectionViewTest
//
//  Created by mr.zhou on 2017/5/6.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFTopCalenderViewModel : NSObject

@property (nonatomic,copy) NSString *date;

@property (nonatomic,strong) NSArray *monthDays;

+(NSArray *)modelsWithDate:(NSDate *)date;
+(NSArray *)weekModelsWithDate:(NSDate *)date;


@end
