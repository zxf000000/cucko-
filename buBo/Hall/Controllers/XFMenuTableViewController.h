//
//  XFMenuTableViewController.h
//  buBo
//
//  Created by mr.zhou on 2017/5/25.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  XFClickMenuCellDelegate <NSObject>

-(void)clickMenuCellDelegateWith:(NSInteger)row;


@end

@interface XFMenuTableViewController : UITableViewController

@property (nonatomic,strong) id<XFClickMenuCellDelegate> delegate;

@end
