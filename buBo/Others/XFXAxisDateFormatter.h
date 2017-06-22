//
//  XFXAxisDateFormatter.h
//  buBo
//
//  Created by mr.zhou on 2017/5/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "buBo-Bridging-Header.h"
#import "buBo-Swift.h"


@interface XFXAxisDateFormatter : NSObject <IChartAxisValueFormatter>
- (id)initForChart:(BarChartView *)chart;

@end
