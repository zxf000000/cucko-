//
//  XFBestTimeDataModel.h
//  buBo
//
//  Created by mr.zhou on 2017/6/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFBestTimeDataModel : NSObject

@property (nonatomic,assign) CGFloat percent;

@property (nonatomic,copy) NSString *weekday;


+(NSArray *)allData ;


@end
