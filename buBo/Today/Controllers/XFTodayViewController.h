//
//  XFTodayViewController.h
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XFGoalListSlideDelegate <NSObject>

-(void)goalListSlideViewDelegate;

@end
@interface XFTodayViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *menus;


@property (nonatomic,strong) id<XFGoalListSlideDelegate> delegate;

@end
