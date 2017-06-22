//
//  XFColorPickerView.m
//  SHadowVIew
//
//  Created by mr.zhou on 2017/4/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFColorPickerView.h"
#import "XFIconPickerCollectionViewCell.h"
#import <Masonry.h>
#import <POP.h>

#import "XFLBigGoalSelectTableViewCell.h"

#define  kShowIconViewHeight 250

@interface XFColorPickerView ()

@property (nonatomic,weak) UIView *seperateView;

@property (nonatomic,weak) UILabel *titleLabel;
// 子目标所属大目标选择器
@property (nonatomic,weak) UITableView *bigGoalSelectView;
@property (nonatomic,strong) NSArray *bigGoals;

@property (nonatomic,strong) NSArray *bigGoalTypes;
@property (nonatomic,strong) NSArray *littleGoalTypes;

// datePicker
@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,strong) UIButton *doButton;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIView *tabbarView;

@end


@implementation XFColorPickerView
-(instancetype)init {
    
    if (self = [super init]) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        _keyWindow = keyWindow;
        
        self.frame = CGRectMake((kScreenWidth - kAlertViewWidth)/2, -kShowIconViewHeight, kAlertViewWidth, kShowIconViewHeight);
        
        
        [self setupDatepicker];
        
        [self setupShadowView];
        
        [self setupIconPickerView];

        [self setupCollectionView];

        [self setupTitleView];
        
        [self setupBigGoalSelectView];
     
        
        [_keyWindow addSubview:self];

        
        self.layer.cornerRadius = 10;
        
        self.layer.masksToBounds = YES;

    }
    return self;
}

// 设置datepicker
-(void)setupDatepicker {
    
    _tabbarView = [[UIView alloc] init];
    
    _doButton = [[UIButton alloc] init];
    
    [_tabbarView addSubview:_doButton];
    
    _cancelButton = [[UIButton alloc] init];
    
    [_tabbarView addSubview:_cancelButton];
    
    _datePicker = [[UIDatePicker alloc] init];
    
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    [_tabbarView addSubview:_datePicker];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.tabbarView.frame = CGRectMake(0, height - 200, width, 200);
    _tabbarView.backgroundColor = [UIColor whiteColor];
    _datePicker.frame = CGRectMake(0, 40, width, 140);
    
    _doButton.frame = CGRectMake(5, 5, 50, 30);
    
    _cancelButton.frame = CGRectMake(width - 55, 5, 50, 30);
    
    [_doButton setTitle:@"取消" forState:(UIControlStateNormal)];
    
    [_doButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [_cancelButton setTitle:@"确定" forState:(UIControlStateNormal)];
    
    [_cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [_doButton addTarget:self action:@selector(doPickDate) forControlEvents:(UIControlEventTouchUpInside)];
    [_cancelButton addTarget:self action:@selector(cancelPickDate) forControlEvents:(UIControlEventTouchUpInside)];
    
    _tabbarView.layer.shadowColor = ([UIColor blackColor].CGColor);
    
    _tabbarView.layer.shadowOffset = CGSizeMake(-5, -5);

    _tabbarView.layer.shadowOpacity = 0.7;
    
}

// 点击取消
- (void)doPickDate {
    [self.delegate dateCancelDelegate];

    [_tabbarView removeFromSuperview];
    


}
// 点击确定
- (void)cancelPickDate {
    
    [self.delegate datepickerDeledate:[self.datePicker date]];

    
    [_tabbarView removeFromSuperview];
}

// 显示datePickerView
- (void)showDatePicker {
    
    [_keyWindow addSubview:self.tabbarView];
    
}

// 设置父目标选择列表
-(void)setupBigGoalSelectView {
    
    UITableView *selectView = [[UITableView alloc] init];
    
    self.bigGoalSelectView = selectView;
    
    self.bigGoalSelectView.delegate = self;
    
    self.bigGoalSelectView.dataSource = self;
    
    [self addSubview:self.bigGoalSelectView];


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if ([self.tableViewType  isEqual: @"goalType"]){
        
        return self.bigGoals.count;
        
    } else if ([self.tableViewType  isEqual: @"goalLevel"]){
        

        return self.bigGoalTypes.count;
        
    } else if ([self.tableViewType  isEqual: @"littleGoalLevel"]){
        
        return self.littleGoalTypes.count;
        
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XFLBigGoalSelectTableViewCell *cell = (XFLBigGoalSelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"bigGoalCell"];
    
    if (cell == nil) {
    
        cell = [[XFLBigGoalSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bigGoalCell"];
        
    }
    cell.titleLabel.font = [UIFont fontWithName:@"Courier" size:16];

    
    if ([self.tableViewType  isEqual: @"goalType"]){
        
        cell.titleLabel.text = self.bigGoals[indexPath.row];
        
    } else if ([self.tableViewType  isEqual: @"goalLevel"]){
        
        
        cell.titleLabel.text = self.bigGoalTypes[indexPath.row];
        
    } else if ([self.tableViewType  isEqual: @"littleGoalLevel"]){
        
        cell.titleLabel.text = self.littleGoalTypes[indexPath.row];
        
    }
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.tableViewType  isEqual: @"goalType"]){
        
        
        [self.delegate bigGoalSelectDelegate:self.bigGoals[indexPath.row]];
    } else if ([self.tableViewType  isEqual: @"goalLevel"]){
        
        
        [self.delegate bigGoalSelectDelegate:self.bigGoalTypes[indexPath.row]];
        
    } else if ([self.tableViewType  isEqual: @"littleGoalLevel"]){
        
        [self.delegate bigGoalSelectDelegate:self.littleGoalTypes[indexPath.row]];
        
    }

    
    [self.shadowView removeFromSuperview];
    
    [self removeFromSuperview];

}

// 显示目标选择器
-(void)showGoalSelectView {

    if ([self.tableViewType  isEqual: @"goalType"]){
    
        self.titleLabel.text = @"选择大目标";

    } else if ([self.tableViewType  isEqual: @"goalLevel"]){
        
        self.titleLabel.text = @"选择级别";

    
    } else if ([self.tableViewType  isEqual: @"littleGoalLevel"]){
        
        self.titleLabel.text = @"选择级别";
    
    }
    
//    
//    [_keyWindow addSubview:_shadowView];
//    
//    self.frame = CGRectMake(0, 0, kAlertViewWidth, 220);
//    
//    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
//    
//    self.backgroundColor = [UIColor whiteColor];
//    
//    
//    [self addSubview:self.bigGoalSelectView];
//    
//    [_keyWindow addSubview:self];
    
    self.bigGoalSelectView.frame = CGRectMake(0, 40, kAlertViewWidth, kShowIconViewHeight - 40);

    [self addSubview:self.bigGoalSelectView];
    
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.shadowView.alpha = 1;
        
    }];
    
    [self addSubview:self.bigGoalSelectView];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.springBounciness = 10;
    
    animation.toValue = [NSValue valueWithCGRect:CGRectMake((kScreenWidth - kAlertViewWidth)/2, (kScreenHeight - kShowIconViewHeight)/2, kAlertViewWidth, kShowIconViewHeight)];
    
    [self pop_addAnimation:animation forKey:@""];
    

    
}


// 提示view
- (void)setupTitleView {

    UIView *topView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kAlertViewWidth, 40))];
    
    topView.backgroundColor = kNavigationBarColor;
    
    [self addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    self.titleLabel = titleLabel;
    
    self.titleLabel.font = [UIFont fontWithName:@"Thonburi" size:14];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [topView addSubview:self.titleLabel];
    
    UIView *seperateView = [[UIView alloc] init];
    
    self.seperateView = seperateView;
    
    self.seperateView.backgroundColor = [UIColor greenColor];
    
    [self setNeedsUpdateConstraints];
    

}
// 布局titleView
-(void)updateConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_offset(0);

    }];
    
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(54);
        make.left.mas_offset(0);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(6);
    }];

    [super updateConstraints];
}

// 图标选择器
-(void)setupIconPickerView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(40, 40);
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UICollectionView *iconPickerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, kAlertViewWidth, kShowIconViewHeight - 40) collectionViewLayout:layout];
    
    _iconPickView = iconPickerView;
    
    _iconPickView.delegate = self;
    
    _iconPickView.dataSource = self;
    
    [_iconPickView registerClass:[XFIconPickerCollectionViewCell class] forCellWithReuseIdentifier:@"iconpickerCell"];
    
    _iconPickView.backgroundColor = [UIColor whiteColor];
        
    _iconPickView.showsVerticalScrollIndicator = NO;
    
    
}

-(void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(40, 40);
    
    layout.minimumLineSpacing = 10;
    
    layout.minimumInteritemSpacing = 10;
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    
    _collectionView = collectionView;
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"colorCell"];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == _collectionView) {
    
        return 12;

    
    } else if (collectionView == _iconPickView) {
    
        return 20;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (collectionView == _collectionView) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
        
        cell.contentView.backgroundColor = self.colors[indexPath.item];
        
        cell.layer.cornerRadius = 3;
        
        cell.layer.masksToBounds = YES;
        return cell;

        
    } else if (collectionView == _iconPickView) {
        
        XFIconPickerCollectionViewCell *cell = (XFIconPickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"iconpickerCell" forIndexPath:indexPath];
        
        cell.iconView.image = self.icons[indexPath.item];
        
        return cell;
    }
    

    return nil;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView == _collectionView) {
        
        self.cellColor = self.colors[indexPath.item];
        
        [self.delegate colorPickerDelegateWithColor:self.cellColor];
        
        [self removeFromSuperview];
        
        [_shadowView removeFromSuperview];
        
    } else if (collectionView == _iconPickView) {
        
        [self.delegate iconPickerDelegateWithIcon:self.icons[indexPath.item]];
        
        [UIView animateWithDuration:0.3 animations:^{
           
            self.alpha = 0;
            
            self.shadowView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            
            [self removeFromSuperview];
            
            [_shadowView removeFromSuperview];
        }];

        
    }
    


}


-(void)setupShadowView {
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    
    _shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.588];
    
    _shadowView.alpha = 0;
    
    [_keyWindow addSubview:_shadowView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadowClick)];
    
    [_shadowView addGestureRecognizer:tapGes];
    
}
// 点击阴影层的动作
-(void)tapShadowClick {
    
    [_shadowView removeFromSuperview];
    
    [_collectionView removeFromSuperview];
    
    [_iconPickView removeFromSuperview];
    
    [self removeFromSuperview];

}

-(void)show {
    
    self.titleLabel.text = @"请选择图标颜色";

    [_keyWindow addSubview:_shadowView];
    
    self.frame = CGRectMake(0, 0, 210, 220);
    
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    self.backgroundColor = [UIColor whiteColor];
    
    _collectionView.frame = CGRectMake(0, 60, 210, 160);
    
    [self addSubview:_collectionView];
    
    [_keyWindow addSubview:self];
    

}

-(void)showIcon {
    
    self.titleLabel.text = @"请选择图标";

    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.shadowView.alpha = 1;
        
    }];
    
    [self addSubview:_iconPickView];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.springBounciness = 10;
    
    animation.toValue = [NSValue valueWithCGRect:CGRectMake((kScreenWidth - kAlertViewWidth)/2, (kScreenHeight - kShowIconViewHeight)/2, kAlertViewWidth, kShowIconViewHeight)];
    
    [self pop_addAnimation:animation forKey:@""];
    
    
}

-(NSArray *)bigGoals {

    if (_bigGoals == nil) {
    
        NSMutableArray *arr = [NSMutableArray array];
        
        [arr addObject:@"目标1"];
        [arr addObject:@"目标2"];
        [arr addObject:@"目标3"];
        [arr addObject:@"目标4"];
        [arr addObject:@"目标5"];
        [arr addObject:@"目标6"];
        [arr addObject:@"目标7"];
        
        _bigGoals = arr.copy;
        
    }
    return _bigGoals;
}

- (NSArray *)colors {

    if (_colors == nil) {
    
        NSMutableArray *colors = [NSMutableArray array];
        
        [colors addObject:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:145/255.0 green:43/255.0 blue:240/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:70/255.0 green:91/255.0 blue:227/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:70/255.0 green:159/255.0 blue:227/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:70/255.0 green:227/255.0 blue:188/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:70/255.0 green:227/255.0 blue:81/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:177/255.0 green:227/255.0 blue:70/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:227/255.0 green:151/255.0 blue:70/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:227/255.0 green:112/255.0 blue:70/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:198/255.0 green:70/255.0 blue:150/255.0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:0 green:255/255.0 blue:0 alpha:1]];
        [colors addObject:[UIColor colorWithRed:0 green:0 blue:255/255.0 alpha:1]];
        
        _colors = colors.copy;
    }
    return _colors;
}

-(NSArray *)icons {

    if (_icons == nil) {
        
        NSMutableArray *icons = [NSMutableArray array];
        
        [icons addObject:[UIImage imageNamed:@"pickIcon_beach"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_bed"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_book"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_broom"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_car"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_headphone"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_coffe"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_count"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_desklamp"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_doctor"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_eat"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_goal"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_guitar"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_headphone"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_movie"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_shopping"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_sport"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_work"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_write"]];
        [icons addObject:[UIImage imageNamed:@"pickIcon_yoga"]];

        _icons = icons.copy;
    }
    return _icons;

}

-(NSArray *)bigGoalTypes {

    if (_bigGoalTypes == nil) {
    
        NSMutableArray *types = [NSMutableArray array];
        
        [types addObject:@"业界Top1%"];
        [types addObject:@"业界Top5%"];
        [types addObject:@"业界Top10%"];
        [types addObject:@"业界Top20%"];
        [types addObject:@"外语考试"];
        [types addObject:@"司法考试"];
        [types addObject:@"财务考试"];
        [types addObject:@"高考考研"];
        [types addObject:@"学期考试"];
        [types addObject:@"自定义"];
        
        _bigGoalTypes = types.copy;
    
    }
    return _bigGoalTypes;

}



-(NSArray *)littleGoalTypes {
    
    if (_littleGoalTypes == nil) {
        
        NSMutableArray *types = [NSMutableArray array];
        
        [types addObject:@"两月坚持"];
        [types addObject:@"一月习惯"];
        [types addObject:@"两周适应"];
        [types addObject:@"一周努力"];
        [types addObject:@"三天冲刺"];
        [types addObject:@"一天尝试"];
        [types addObject:@"自定义"];

        
        _littleGoalTypes = types.copy;
        
    }
    return _littleGoalTypes;
    
}


@end
