//
//  XFBestTimeCollectionViewCell.h
//  buBo
//
//  Created by mr.zhou on 2017/6/2.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFBestTimeDataModel.h"

@interface XFBestTimeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (strong,nonatomic) XFBestTimeDataModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewHeightContraint;

@end
