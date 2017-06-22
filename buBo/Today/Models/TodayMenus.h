//
//  TodayMenus.h
//  buBo
//
//  Created by mr.zhou on 2017/4/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Goal+CoreDataClass.h"

@interface TodayMenus : NSObject

@property (nonatomic,strong) NSArray *goals;
@property (nonatomic,copy) NSString *textBig;

@property (nonatomic,copy) NSString *textLittle;

@property (nonatomic,weak) UIImage *image;

@property (nonatomic,weak) UIColor *color;

@property (nonatomic,strong) NSArray *subGoals;

@property (nonatomic,copy) NSString *bigGoalName;

-(instancetype)initWithGoal:(Goal *)goal;

+(instancetype)goalWithGoal:(Goal *)goal;

+(NSArray *)goals;

+(NSArray *)subGoals;

@end

