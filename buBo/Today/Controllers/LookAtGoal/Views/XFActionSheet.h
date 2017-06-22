//
//  XFActionSheet.h
//  buBo
//
//  Created by mr.zhou on 2017/6/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFActionSheet;

@protocol XFActionSheetDelegate <NSObject>

-(void)actionSheetDelegateWithNumber:(NSInteger)num ActionSheet:(XFActionSheet *)actionSheet;

-(void)buttonRotateBackDelegte;

@end

@interface XFActionSheet : UIView <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) id<XFActionSheetDelegate> delegate;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) CGPoint *topPoint;


-(instancetype)initWithRightButtonFrame:(CGRect)frame;

@property (nonatomic,assign) CGRect buttonFrame;

-(void)show;

@property (nonatomic,strong) NSArray *models;

-(void)tapShadowView;

@end
