//
//  XFActionSheetModel.m
//  buBo
//
//  Created by mr.zhou on 2017/6/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFActionSheetModel.h"

@implementation XFActionSheetModel

+(instancetype)model {
    
    return [[XFActionSheetModel alloc] init];

}

+(NSArray *)models {

    NSArray *titleArray = [NSArray arrayWithObjects:@"添加目标",@"所有目标",@"今天数据",@"添加时间段", nil];
    
    NSArray *imageArrray = [NSArray arrayWithObjects:[UIImage imageNamed:@"tianjia"],[UIImage imageNamed:@"allGoalList"],[UIImage imageNamed:@"todayData"],[UIImage imageNamed:@"timeSpace"], nil];
    
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 4; i ++) {
        
        XFActionSheetModel *model = [XFActionSheetModel model];
        
        model.title = titleArray[i];
        
        model.image = imageArrray[i];
        
        [models addObject:model];
    }
    
    return models.copy;
}


@end
