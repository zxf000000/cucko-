//
//  XFAboutViewController.m
//  buBo
//
//  Created by mr.zhou on 2017/6/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAboutViewController.h"
#import <UShareUI/UShareUI.h>

#define kAboutViewCell @"aboutViewTableViewCell"

@interface XFAboutViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)clickBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation XFAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = kNavigationBarColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    
}

- (IBAction)clickBackButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAboutViewCell];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kAboutViewCell];
        
        
    }

    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"去评分";
        }
            
            break;
            
        case 1:
        {
            cell.textLabel.text = @"去提意见";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"去分享";
        }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
    
//    itms-apps://itunes.apple.com/cn/app/cucko%E6%97%B6%E9%97%B4%E7%AE%A1%E7%90%86/id1247823435?mt=8
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/cucko%E6%97%B6%E9%97%B4%E7%AE%A1%E7%90%86/id1247823435?mt=8"] options:nil completionHandler:nil];
            
        }
            
            break;
            
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sinaweibo://userinfo?uid=5871738104"] options:nil completionHandler:nil];
            

        }
            break;
        case 2:
        {
            // 分享
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                [self shareWebPageToPlatformType:platformType];
                
            }];
    
        }
            break;
        default:
            break;
    }

}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"这个时间管理app还可以哦";
    
    
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"jpeg"]]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
    
    
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    // 图片内容对象
//    UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
//    
//    imageObject.shareImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"jpeg"]];
//                              
//    messageObject.shareObject = imageObject;
//    
//    //创建网页内容对象
////    NSString* thumbURL =  ;
////    
////    
////;
//    
////    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"这个时间管理app还不错哦" descr:@"" thumImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"jpeg"]]];
////    //设置网页地址
////    shareObject.webpageUrl = @"itms-apps://itunes.apple.com/cn/app/cucko%E6%97%B6%E9%97%B4%E7%AE%A1%E7%90%86/id1247823435?mt=8";
////    
////    //分享消息对象设置分享内容对象
////    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        [self alertWithError:error];
//    }];
}

-(void)alertWithError:(NSError *)error {

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

@end
