//
//  XFColorPickerView.h
//  SHadowVIew
//
//  Created by mr.zhou on 2017/4/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XFColorPickerDelegate <NSObject>

-(void)colorPickerDelegateWithColor:(UIColor*)color;

-(void)iconPickerDelegateWithIcon:(UIImage *)icon;

-(void)bigGoalSelectDelegate:(NSString *)title;

-(void)datepickerDeledate:(NSDate *)date;

-(void)dateCancelDelegate;

@end

@interface XFColorPickerView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

// tableView的类型
@property (nonatomic,copy) NSString *tableViewType;

@property (nonatomic,weak) UIWindow *keyWindow;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,weak) UICollectionView *iconPickView;

@property (nonatomic,weak) UICollectionViewFlowLayout *layout;

@property (nonatomic,assign) UIColor *cellColor;

@property (nonatomic,strong) NSArray *colors;

@property (nonatomic,strong) NSArray *icons;

@property (nonatomic,strong) id<XFColorPickerDelegate> delegate;



-(void)show;

-(void)showIcon;

-(void)showGoalSelectView;

-(void)showDatePicker;

@end
