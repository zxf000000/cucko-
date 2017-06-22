//
//  XFPotatoViewController.h
//  buBo
//
//  Created by mr.zhou on 2017/5/24.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XFSlideDelegate <NSObject>

-(void)slideViewDelegate;

@end


@interface XFPotatoViewController : UIViewController

@property (nonatomic,strong) id<XFSlideDelegate> delegate;

@end
