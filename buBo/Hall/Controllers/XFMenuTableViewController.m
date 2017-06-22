//
//  XFMenuTableViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/5/25.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMenuTableViewController.h"
#import <Masonry.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface XFMenuTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *setButton;

@end

@implementation XFMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:5/255.f green:14/255.f blue:59/255.f alpha:1.000];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view setNeedsUpdateConstraints];
}

// 设置cell被选中的颜色
-(void)setupSelectedCell {


}

-(void)updateViewConstraints {

    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-kScreenWidth * 0.3);
        
    }];
    
    
    [super updateViewConstraints];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
    
        
    
    } else {
    
        if ([self.delegate respondsToSelector:@selector(clickMenuCellDelegateWith:)]) {
            
            [self.delegate clickMenuCellDelegateWith:indexPath.row];
            
        }
   
    
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
