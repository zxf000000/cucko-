//
//  XFDayDataModel.h
//  buBo
//
//  Created by mr.zhou on 2017/5/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Goal;

@interface XFDayDataModel : NSObject

@property (nonatomic,strong) Goal *goal;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSDictionary *beginAndEndTime;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,copy) NSString *totalTime;

+(NSArray *)modelsWithDate:(NSString *)date;
@end
