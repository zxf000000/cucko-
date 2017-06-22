//
//  XFManageGoalViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/4/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFManageGoalViewController.h"
#import "XFManageGoalTableViewCell.h"

#import "Goal+CoreDataClass.h"

#import "XFCoreDataManager.h"

@interface XFManageGoalViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *goalsTableView;

@property (weak, nonatomic) IBOutlet UIButton *doingButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *deletedButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconBack;

// 数据库搜索出的文件
- (IBAction)onTouchDoingButton:(id)sender;
- (IBAction)onTouchDoneButton:(id)sender;
- (IBAction)onTpuchDelecedButton:(id)sender;

@property (nonatomic,strong) NSArray *doneGoals;
@property (nonatomic,strong) NSArray *doingGoal;
@property (nonatomic,strong) NSArray *delectedGoals;

// 目标列表的类型
@property (nonatomic,assign) NSInteger tableViewType;

@end

@implementation XFManageGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goalsTableView.delegate = self;
    self.goalsTableView.dataSource = self;
    
    self.tableViewType = 1;
    
    self.doingButton.backgroundColor = kNavigationBarColor;
    [self.doingButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    
    self.title = @"所有目标";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBack"] forBarMetrics:(UIBarMetricsDefault)];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [backButton setImage:[UIImage imageNamed:@"addGoal_back"] forState:(UIControlStateNormal)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [backButton addTarget:self action:@selector(popBack) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)popBack {

    [self.navigationController popViewControllerAnimated:YES];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.tableViewType) {
            
        case 1:
            return self.doingGoal.count;
            break;
        case 2:
            return self.doneGoals.count;
            break;
        case 3:
            return self.delectedGoals.count;
            break;
        default:
            break;
    
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFManageGoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"manageCell"];
    
    Goal *goal = [[Goal alloc] init];
    
    switch (self.tableViewType) {
            
        case 1:
            goal = self.doingGoal[indexPath.row];
            break;
        case 2:
            goal = self.doneGoals[indexPath.row];
            break;
        case 3:
            goal = self.delectedGoals[indexPath.row];
            break;
        default:
            break;
            
    }
    
    cell.goal = goal;
    


    
    return cell;
}

- (IBAction)onTouchDoingButton:(id)sender {
    [self.doingButton setBackgroundColor:kNavigationBarColor];
    [self.doingButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    [self.deletedButton setBackgroundColor:[UIColor whiteColor]];
    [self.deletedButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    self.tableViewType = (NSInteger)1;
    
    [self.goalsTableView reloadData];
    

    
}

- (IBAction)onTouchDoneButton:(id)sender {
    [self.doingButton setBackgroundColor:[UIColor whiteColor]];
    [self.doingButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    [self.doneButton setBackgroundColor:kNavigationBarColor];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [self.deletedButton setBackgroundColor:[UIColor whiteColor]];
    [self.deletedButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    self.tableViewType = 2;
    [self.goalsTableView reloadData];

}

- (IBAction)onTpuchDelecedButton:(id)sender {
    [self.doingButton setBackgroundColor:[UIColor whiteColor]];
    [self.doingButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    [self.deletedButton setBackgroundColor:kNavigationBarColor];
    [self.deletedButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    self.tableViewType = 3;
    [self.goalsTableView reloadData];

}

-(NSArray *)doingGoal {

    
    if(_doingGoal == nil) {
        XFCoreDataManager *manager = [XFCoreDataManager shareManager];
        
        [manager fetchData];
        
        NSMutableArray *goals = [NSMutableArray array];
        for (Goal *goal in manager.goals) {
        
            if (goal.state == kGoalStatusDoing) {
            
                [goals addObject:goal];
            
            }
        
        }
        
        _doingGoal = goals;
    }
   
    
    return _doingGoal;

}

-(NSArray *)doneGoals {
    
    
    if( _doneGoals == nil) {
        XFCoreDataManager *manager = [XFCoreDataManager shareManager];
        
        [manager fetchData];
        NSMutableArray *goals = [NSMutableArray array];
        for (Goal *goal in manager.goals) {
            
            if (goal.state == kGoalStatusDone) {
                
                [goals addObject:goal];
                
            }
            
        }
        
        _doneGoals = goals;
    }
    return _doneGoals;
}
-(NSArray *)delectedGoals {
    
    
    if( _delectedGoals == nil) {
        XFCoreDataManager *manager = [XFCoreDataManager shareManager];
        
        [manager fetchData];
        NSMutableArray *goals = [NSMutableArray array];
        for (Goal *goal in manager.goals) {
            
            if (goal.state == kGoalStatusDeleted) {
                
                [goals addObject:goal];
                
            }
            
        }
        
        _delectedGoals = goals;
    }
    return _delectedGoals;
}


@end
