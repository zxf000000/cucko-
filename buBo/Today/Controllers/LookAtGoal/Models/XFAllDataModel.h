//
//  XFAllDataModel.h
//  buBo
//
//  Created by mr.zhou on 2017/5/3.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goal+CoreDataClass.h"

@interface XFAllDataModel : NSObject

@property (nonatomic,copy) NSString *day;

@property (nonatomic,copy) NSString *time;

+(NSArray *)modelsWithDate:(NSDate *)date Goal:(Goal *)goal;

@end
