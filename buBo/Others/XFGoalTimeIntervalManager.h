//
//  XFGoalTimeIntervalManager.h
//  buBo
//
//  Created by mr.zhou on 2017/5/4.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Goal;

@interface XFGoalTimeIntervalManager : NSObject
+(void)addBeginTimeWithGoal:(Goal *)goal time:(NSDate *)time ;

+(void)addEndTimeWithGoal:(Goal *)goal time:(NSDate *)time ;
@end
