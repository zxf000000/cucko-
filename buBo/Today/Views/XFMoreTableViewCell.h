//
//  XFMoreTableViewCell.h
//  buBo
//
//  Created by mr.zhou on 2017/6/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFActionSheetModel.h"

@interface XFMoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) XFActionSheetModel *model;

@end
