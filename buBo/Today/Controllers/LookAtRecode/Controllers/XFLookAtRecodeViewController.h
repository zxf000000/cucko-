//
//  XFLookAtRecodeViewController.h
//  buBo
//
//  Created by mr.zhou on 2017/4/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XFTimeLineSlideDelegate <NSObject>

-(void)timeLineSlideViewDelegate;

@end
@interface XFLookAtRecodeViewController : UIViewController

@property (nonatomic,strong) void (^testBlock)();
@property (nonatomic,strong) id<XFTimeLineSlideDelegate> delegate;

@end
