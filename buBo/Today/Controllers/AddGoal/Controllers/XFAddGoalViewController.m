//
//  XFAddGoalViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAddGoalViewController.h"
#import <CoreData/CoreData.h>
#import "Goal+CoreDataClass.h"
#import "AppDelegate.h"
#import <RTRootNavigationController.h>
#import <POP.h>

#import <MBProgressHUD.h>

#import "XFColorPickerView.h"
#import "XFTodayViewController.h"
#import "XFAddAlertView.h"

@interface XFAddGoalViewController () <UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,XFColorPickerDelegate,UITextFieldDelegate,UITextViewDelegate,XFAddAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UITextField *encourageTextField;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourPerdayLabel;
@property (weak, nonatomic) IBOutlet UIView *iconBackView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *iconMiddleView;
@property (weak, nonatomic) IBOutlet UILabel *littleGoalLabel;

@property (nonatomic,assign) BOOL idHide;

@property (nonatomic,copy) NSString *goalName;

@property (nonatomic,copy) NSString *encourage;

@property (nonatomic,assign) UIImage *image;

@property (nonatomic,copy) NSString *goalType;

@property (nonatomic,copy) NSString *totalTime;

@property (nonatomic,copy) NSString *everyDayTime;

@property (nonatomic,copy) NSString *deadTime;

@property (nonatomic,assign) UIColor *iconColor;
// 颜色/图标选择器
@property (nonatomic,strong) __block XFColorPickerView *colorPickerView;

@property (nonatomic,copy) NSString *tableviewType;

@property (nonatomic,strong) AppDelegate *appdelegate;
- (IBAction)onClickClearButton:(id)sender;
- (IBAction)onCLickLevelEditButton:(id)sender;
- (IBAction)onClickNeedsEditButton:(id)sender;
- (IBAction)onCLickDeadLineEditButton:(id)sender;
- (IBAction)onClickHourPerdayEditButton:(id)sender;

// 两种目标的时间
@property (nonatomic,strong) NSDictionary *bigGoalTimes;
@property (nonatomic,strong) NSDictionary *littleGoalsTImes;


// 时间差(天数)
@property (nonatomic,assign) CGFloat daysToDeadline;

// 是否是初次编辑
@property (nonatomic,assign) BOOL isFirstTimeEdit;

/**
 *  编辑之前的level
 */
@property (nonatomic,assign) NSString *previousLevel;

@property (nonatomic,assign) CGRect navigationRightButtonFrame;

@end

@implementation XFAddGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.backgroundColor = kNavigationBarColor;
    
    [self setupNavigationBar];
    
    [self setupViews];
    
    [self setupIconView];
    
    // 获取appdelegate
    self.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 监听textView改变的通 知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.goalTextView];
    
    self.idHide = YES;
    
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = kNavigationBarColor;
    
    self.encourageTextField.delegate = self;
    
    self.goalTextView.delegate = self;
    
    self.goalTextView.returnKeyType = UIReturnKeyDone;
        
}


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.goalTextView.text.length == 0) {
    
        self.isFirstTimeEdit = YES;
    
    } else {
    
        self.isFirstTimeEdit = NO;

    }
    
    [self.tableView reloadData];
}

#pragma mark - textField代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
    return YES;

}

#pragma mark - textView代理

- (BOOL)textView:(UITextView *)textView shouldhangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (void)setupIconView {

    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.iconMiddleView.image = [UIImage imageNamed:@"icon_backGround"];
    
    self.iconView.image = [UIImage imageNamed:@"pickIcon_book"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 10;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    
    return cell;

}

// 初始化数据
- (void)setupViews {
    
    

}
#pragma 点击cell的动作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;

    switch (indexPath.section) {
    
        case 0:
        {

            // 图标选择
            switch (indexPath.row){
                   // 加载速度很慢?
                case 2:
                {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择项目" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction *actionIcon = [UIAlertAction actionWithTitle:@"图标" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                        self.colorPickerView = [[XFColorPickerView alloc] init];
//                        self.colorPickerView.delegate = self;
//                        [self.colorPickerView showIcon];
//                        
//                    }];
//                    UIAlertAction *actionColor = [UIAlertAction actionWithTitle:@"颜色" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                    
//                        self.colorPickerView = [[XFColorPickerView alloc] init];
//                        self.colorPickerView.delegate = self;
//                        
//                        [self.colorPickerView show];
//                    }];
//                    
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
//                    
//                    [alertController addAction:actionIcon];
//                    [alertController addAction:actionColor];
//                    [alertController addAction:cancelAction];
//                    
//                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    self.colorPickerView = [[XFColorPickerView alloc] init];
                    self.colorPickerView.delegate = self;
                    [self.colorPickerView showIcon];
                    
                
                }
                    break;
                default:
                    break;
            
            }
        
        }
            
            break;
        // 点击目标类型选择
        case 1:
        {
            
            if (indexPath.row == 0) {
            
            
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择目标类型" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *bigGoalAction = [UIAlertAction actionWithTitle:@"大目标" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                    
//                    self.typeLabel.text = @"大目标";
//                    
//                    self.idHide = YES;
//                    
//                    [self.tableView reloadData];
//                }];
//                
//                UIAlertAction *littleGoalAction = [UIAlertAction actionWithTitle:@"子目标" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                    
//                    self.typeLabel.text = @"子目标";
//                    
//                    XFColorPickerView *pickView = [[XFColorPickerView alloc] init];
//                    
//                    pickView.delegate = self;
//                    
//                    pickView.tableViewType = @"goalType";
//                    
//                    self.tableviewType = @"goalType";
//                    
//                    [pickView showGoalSelectView];
//                    
//                    self.idHide = NO;
//                    
//                    [self.tableView reloadData];
//                    
//                    
//                }];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//                    
//                    
//                }];
//                
//                [alertController addAction:bigGoalAction];
//                [alertController addAction:littleGoalAction];
//                [alertController addAction:cancelAction];
//                
//                [self presentViewController:alertController animated:YES completion:nil];
                

            } else if (indexPath.row == 1) {
            
                XFColorPickerView *pickView = [[XFColorPickerView alloc] init];
                
                pickView.delegate = self;
                
                pickView.tableViewType = @"goalType";
                self.tableviewType = @"goalType";

                
                [pickView showGoalSelectView];
                
                [self.tableView reloadData];
            
            }
                    }
            break;
            
        case 2:
        {
            switch (indexPath.row){
                    
                case 0:
                {
                    if (self.idHide == YES) {
                    
                        XFColorPickerView *pickView = [[XFColorPickerView alloc] init];
                        
                        pickView.delegate = self;
                        
                        pickView.tableViewType = @"goalLevel";
                        self.tableviewType = @"goalLevel";

                        [pickView showGoalSelectView];
                        
                        [self.tableView reloadData];
                    
                    } else {
                    
                        XFColorPickerView *pickView = [[XFColorPickerView alloc] init];
                        
                        pickView.delegate = self;
                        
                        pickView.tableViewType = @"littleGoalLevel";
                        self.tableviewType = @"littleGoalLevel";

                        [pickView showGoalSelectView];
                        
                        [self.tableView reloadData];
                        
                    }
                    
                }
                    break;
                case 1:
                {
                    
                    
                }
                    break;
                case 2:
                {

                    
                    self.colorPickerView = [[XFColorPickerView alloc] init];
                    self.colorPickerView.delegate = self;
                    [self.colorPickerView showDatePicker];
                    
                    self.view.userInteractionEnabled = NO;
                    
                    
                }
                    break;
                case 3:
                {
                    
                    
                }
                    break;
                default:
                    break;
                    
            }
            
        }
            break;
            
        default:
            
            break;
    
    }

}

// 重新计算timeLabel的时间
-(void)reloadTimeLabel {

    NSInteger length = self.totalHoursLabel.text.length;
    
    NSString *totalTimeStr = [self.totalHoursLabel.text substringToIndex:length - 2];
    
    NSInteger totalTime = [totalTimeStr integerValue];
    
    NSString *deadlineString = self.deadLineLabel.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *deadline = [formatter dateFromString:deadlineString];
    
    NSString *todayStr = [formatter stringFromDate:[NSDate date]];
    
    NSDate *today = [formatter dateFromString:todayStr];
    
    NSTimeInterval timeInterval = [deadline timeIntervalSinceDate:today];
    
    
    CGFloat hoursPerDay = (float)totalTime/(timeInterval/3600/24);
    
    self.hourPerdayLabel.text = [NSString stringWithFormat:@"%.1f",hoursPerDay];


}

// 选择时间的代理
- (void)datepickerDeledate:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    self.view.userInteractionEnabled = YES;
    
    // 得到当前时间
    NSDate *currentDate = [NSDate date];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    
    NSInteger result = [self compareDatesWithDate:currentDateStr dateB:dateStr];
    // result < 0时,小于当前时间
    if (result <= 0 ) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:hud];
        
        hud.label.text = @"不能小于当前时间";
        
        hud.mode = MBProgressHUDModeText;
        
        [hud showAnimated:YES];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];

        });
        
    } else if (result > 0) {
    
        self.deadLineLabel.text = dateStr;
        
        self.daysToDeadline = result/3600/24;
        
        CGFloat length = self.totalHoursLabel.text.length;
        
        NSString *totalTimeStr = [self.totalHoursLabel.text substringToIndex:length - 2];
        
        NSInteger totalTime = [totalTimeStr integerValue];
        
        CGFloat perdayTime = totalTime / self.daysToDeadline;
        
        NSString *perdayStr = [NSString stringWithFormat:@"%.1f小时",perdayTime];
        
        self.hourPerdayLabel.text = perdayStr;
    }
}

- (CGFloat)compareDatesWithDate:(NSString *)dateA  dateB:(NSString *)dateb {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *today = [dateFormatter dateFromString:dateA];
    
    NSDate *compareDate = [dateFormatter dateFromString:dateb];
    
    
    NSTimeInterval interval = [compareDate timeIntervalSinceDate:today];
    
    return interval;
    
    

}


// 取消选择时间的代理
-(void)dateCancelDelegate {
    self.view.userInteractionEnabled = YES;
}

// 选择子目标所属大目标代理
-(void)bigGoalSelectDelegate:(NSString *)title {
    
    if ([self.tableviewType isEqualToString:@"goalType"]) {
    
        self.littleGoalLabel.text = title;

    
    } else if ([self.tableviewType isEqualToString:@"goalLevel"]) {
    
        self.levelLabel.text = title;
        
        self.totalHoursLabel.text = [self.bigGoalTimes objectForKey:title];
        
        [self reloadTimeLabel];
        
    } else if ([self.tableviewType isEqualToString:@"littleGoalLevel"]) {
        
        self.levelLabel.text = title;
        
        self.totalHoursLabel.text = [self.littleGoalsTImes objectForKey:title];
        
        [self reloadTimeLabel];

    }

    

}

// 图标/颜色选择的两个代理
-(void)colorPickerDelegateWithColor:(UIColor*)color {

    self.iconMiddleView.backgroundColor = color;

}

-(void)iconPickerDelegateWithIcon:(UIImage *)icon {

    self.iconView.image = icon;
}

- (void)textDidChange {

    self.goalNamePlaceholder.hidden = self.goalTextView.hasText;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
    
        case 0:
        {
            switch (indexPath.row) {
            
                case 0:
                    return 75;
                    break;
                case 1:
                    return 50;
                    break;
                case 2:
                    return 50;
                    break;
                default:
                    break;
            }
        
        }
            break;
        case 1:
            
        {
            switch (indexPath.row) {
                    
                case 0:
                    return 50;
                    break;
                case 1:
                    
                    if (self.idHide) {
                    
                        return 0;

                    } else {
                    
                        return 50;
                    }
                    
                    break;
                default:
                    break;
            }
            
        }
            
            break;
        case 2:
            return 50;
            break;
        default:
            break;
    
    }
    
    return 50;
}
// 保存数据
-(void)saveData {
    
    NSInteger length = self.hourPerdayLabel.text.length;
    
    NSString *timePerdayStr = [self.hourPerdayLabel.text substringToIndex:length - 2];
    
    CGFloat timePerDay = [timePerdayStr floatValue];
    
    if (timePerDay > 24.0) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:hud];
        
        hud.label.text = @"每天的时间请勿大于24小时";
        
        hud.mode = MBProgressHUDModeText;
        
        [hud showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
        });
        
        
    } else if ([self.goalTextView.text isEqualToString:@""]){
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:hud];
        
        hud.label.text = @"请输入目标";
        
        hud.mode = MBProgressHUDModeText;
        
        [hud showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
        });
    } else {
        
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:appdelegate.persistentContainer.viewContext];
        
        Goal *goal = [[Goal alloc] initWithEntity:entity insertIntoManagedObjectContext:appdelegate.persistentContainer.viewContext];
        
        goal.name = self.goalTextView.text;
        goal.encourage = self.encourageTextField.text;
        goal.pic = self.iconView.image;
        goal.type = self.typeLabel.text;
        goal.needs = self.totalHoursLabel.text;
        goal.deadtime = self.deadLineLabel.text;
        goal.everyday = self.hourPerdayLabel.text;
        goal.level = self.levelLabel.text;
        goal.isWaste = NO;
//        goal.color = self.iconMiddleView.backgroundColor;
        
        if ([goal.type isEqualToString:@"子目标"]) {
        
            goal.bigGoalName = self.littleGoalLabel.text;
        
        
        }
        
        if (self.isFirstTimeEdit == YES) {
        
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            
            goal.creatTime = [dateFormatter stringFromDate:[NSDate date]];
            
        }
        
        NSMutableDictionary *times = [NSMutableDictionary dictionary];
        
        NSData *timeData = [NSJSONSerialization dataWithJSONObject:times options:NSJSONWritingPrettyPrinted error:nil];
        
        goal.times = timeData;
        goal.beginAndEnd = timeData;
        
        // 1为进行中,2为已完成,3为删除
        
        /**
         *      kGoalStatusDoing,
         *      kGoalStatusDone,
         *      kGoalStatusDeleted,
         */
        goal.state = kGoalStatusDoing;
        
        goal.showInIndex = YES;
        
        [appdelegate saveContext];
        
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.detailsLabel.text = @"已经添加新目标";
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hideAnimated:YES afterDelay:1];
        HUD.detailsLabel.font = [UIFont systemFontOfSize:14];

        HUD.completionBlock = ^{
            
            [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
        };
        
    }

}


//设置导航栏
- (void)setupNavigationBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:UIBarMetricsDefault ];

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"添加";

    // 返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [backButton addTarget:self action:@selector(popBackToMainView) forControlEvents:(UIControlEventTouchUpInside)];
    [backButton setImage:[UIImage imageNamed:@"addGoal_back"] forState:(UIControlStateNormal)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
    // 保存按钮
    UIButton *saveButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 26, 28))];
    
    [saveButton setBackgroundImage:[UIImage imageNamed:@"addGOal_save"] forState:(UIControlStateNormal)];

    [saveButton addTarget:self action:@selector(saveData) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];

}

-(void)popBackToMainView {

    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
        
}

// 清除
- (IBAction)onClickClearButton:(id)sender {
    
    self.goalTextView.text = @"";
    
    self.encourageTextField.text = @"";
    
    self.iconMiddleView.backgroundColor = [UIColor greenColor];
    
    self.iconView.image = [UIImage imageNamed:@"pickIcon_book"];
    
    self.typeLabel.text = @"大目标";
    
    self.idHide = YES;
    
    [self.tableView reloadData];
    
    self.levelLabel.text = @"业界Top1%";
    
    self.totalHoursLabel.text = @"10000小时";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    self.deadLineLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:864000 * 3]];
    
    [self reloadTimeLabel];
}
// 编辑目标级别
- (IBAction)onCLickLevelEditButton:(id)sender {
    
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入自定义级别" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//       
//            textField.text = self.levelLabel.text;
//    }];
//    
//    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        UITextField *textField = [alertController.textFields lastObject];
//        
//        self.levelLabel.text = textField.text;
//        
//        self.totalHoursLabel.text = @"500小时";
//        
//        [self reloadTimeLabel];
//
//    }];
//    
//    [alertController addAction:doneAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
    
    XFAddAlertView *alertView = [[XFAddAlertView alloc] initWithXFAlertViewType:(XFAlertViewTypeTextField)];
    
    alertView.titleLabel.text = @"编辑级别";
    
    alertView.delegate = self;
    
    alertView.inputTextField.placeholder = @"请输入自定义级别";
    
    alertView.inputTimeTextField.placeholder = @"请输入需要时间(小时)";
    
    alertView.inputTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView show];

}

#pragma mark - alertView代理

-(void)alertViewClickDoneButtonDelegateWithInputText:(NSArray *)inputTexts {

    
    self.levelLabel.text = inputTexts[0];
    
    self.totalHoursLabel.text = [NSString stringWithFormat:@"%@小时",inputTexts[1]];
    
    [self reloadTimeLabel];

}



- (IBAction)onClickNeedsEditButton:(id)sender {
}

- (IBAction)onCLickDeadLineEditButton:(id)sender {
}

- (IBAction)onClickHourPerdayEditButton:(id)sender {
}


- (NSDictionary *)bigGoalTimes {
    
    if (_bigGoalTimes == nil) {
        
        NSMutableDictionary *times = [NSMutableDictionary dictionary];
        [times setObject:@"10000小时" forKey:@"业界Top1%"];
        [times setObject:@"5400小时" forKey:@"业界Top5%"];
        [times setObject:@"1800小时" forKey:@"业界Top10%"];
        [times setObject:@"600小时" forKey:@"业界Top20%"];
        [times setObject:@"2000小时" forKey:@"外语考试"];
        [times setObject:@"5000小时" forKey:@"司法考试"];
        [times setObject:@"5000小时" forKey:@"财务考试"];
        [times setObject:@"2500小时" forKey:@"高考考研"];
        [times setObject:@"1000小时" forKey:@"学期考试"];
        [times setObject:@"小时" forKey:@"自定义"];
        
        _bigGoalTimes = times.copy;
        
    }
    
    return _bigGoalTimes;
}

-(NSDictionary *)littleGoalsTImes {
    
    if (_littleGoalsTImes == nil) {
        
        NSMutableDictionary *times = [NSMutableDictionary dictionary];
        
        
        [times setObject:@"200小时" forKey:@"两月坚持"];
        [times setObject:@"150小时" forKey:@"一月习惯"];
        [times setObject:@"100小时" forKey:@"两周适应"];
        [times setObject:@"50小时" forKey:@"一周努力"];
        [times setObject:@"24小时" forKey:@"三天冲刺"];
        [times setObject:@"4小时" forKey:@"一天尝试"];
        [times setObject:@"小时" forKey:@"自定义"];
        
        _littleGoalsTImes = times.copy;
        
    }
    
    return _littleGoalsTImes;
    
}


@end
