//
//  TodayMenus.m
//  buBo
//
//  Created by mr.zhou on 2017/4/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "TodayMenus.h"
#import "XFCoreDataManager.h"

@interface TodayMenus ()



@end

@implementation TodayMenus

-(instancetype)initWithGoal:(Goal *)goal {
    
    if ( self = [super init]) {
        
        if (goal.showInIndex == YES) {
            _textBig = goal.name;
            _textLittle = goal.encourage;
            _image = (UIImage *)goal.pic;
            _color = (UIColor *)goal.color;
            _bigGoalName = goal.bigGoalName;
        }
    }
    return  self;
}

+(instancetype)goalWithGoal:(Goal *)goal {
    
    return [[self alloc] initWithGoal:goal];
    
}

+(NSArray *)goals {
    
    XFCoreDataManager *manager = [XFCoreDataManager shareManager];
    
    [manager fetchData];
    
    NSMutableArray *modelArr = [NSMutableArray array];
    
    NSMutableArray *finalArr = [NSMutableArray array];
    
    for (int i = 0 ; i < manager.goals.count ; i++) {
        
        Goal *goal = manager.goals[i];
        
        if (goal.bigGoalName.length == 0 && goal.state == kGoalStatusDoing) {
            
            [modelArr addObject:goal];
            
        }

    }
    // 重新排序数组,将固定的三个cell固定下来
    for (int i = 0 ; i < modelArr.count ; i++) {
        
        if (i < modelArr.count - 3) {
            
            Goal *menu = modelArr[i+3];

            [finalArr addObject:menu];
            
        } else {
        
            Goal *menu = modelArr[modelArr.count - 1 - i];

            [finalArr addObject:menu];
        
        }
        
    }
    
    return finalArr;
}

+(NSArray *)subGoals {
    
    XFCoreDataManager *manager = [XFCoreDataManager shareManager];
    
    [manager fetchData];
    
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (int i = 0 ; i < manager.goals.count ; i++) {
        
        Goal *goal = manager.goals[i];
        
        if (goal.bigGoalName.length != 0) {
            
            TodayMenus *menu = [TodayMenus goalWithGoal:manager.goals[i]];
            
            [modelArr addObject:menu];
        }
    }
    return modelArr;
}

@end
