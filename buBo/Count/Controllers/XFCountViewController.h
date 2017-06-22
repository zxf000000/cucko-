//
//  XFCountViewController.h
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XFCountSlideDelegate <NSObject>

-(void)countSlideViewDelegate;

@end
@interface XFCountViewController : UITableViewController
@property (nonatomic,strong) id<XFCountSlideDelegate> delegate;

@end
