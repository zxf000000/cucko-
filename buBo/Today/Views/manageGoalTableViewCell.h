//
//  manageGoalTableViewCell.h
//  buBo
//
//  Created by mr.zhou on 2017/4/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "manageGoalMenu.h"

@protocol ManageGoalButtonDelegate <NSObject>

-(void)manageGoalButtonDelegate:(UIButton *)button;

@end

@interface manageGoalTableViewCell : UITableViewCell

@property (nonatomic,weak) UIButton *textButton;

@property (nonatomic,weak) UIButton *imageButton;

@property (nonatomic,assign) manageGoalMenu *menu;

@property (nonatomic,assign) id<ManageGoalButtonDelegate> delegate;

@end
