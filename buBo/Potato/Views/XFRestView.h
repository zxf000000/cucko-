//
//  XFRestView.h
//  buBo
//
//  Created by mr.zhou on 2017/6/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFRestView : UIView

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UIImageView *backView;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIButton *restButton;

@property (nonatomic,strong) UIButton *cancelButton;

-(void)show;

@end
