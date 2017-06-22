//
//  AppDelegate.m
//  buBo
//
//  Created by mr.zhou on 2017/4/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "AppDelegate.h"
#import "XFMineViewController.h"
#import "XFCountViewController.h"
#import "XFTodayViewController.h"
#import "XFEverydayViewController.h"
#import "CountNavigationViewController.h"

#import "Goal+CoreDataClass.h"

#import "NavViewController.h"
#import <RTRootNavigationController.h>
#import "HallViewController.h"
#import "XFMenuTableViewController.h"
#import "XFLookAtRecodeViewController.h"

#import <AVFoundation/AVFoundation.h>

#import <UserNotifications/UserNotifications.h>

#import <UMSocialCore/UMSocialCore.h>




@interface AppDelegate () 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    // 初始化数据库,添加三行固定的数据
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:self.persistentContainer.viewContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = entity;
    
    request.predicate = [NSPredicate predicateWithFormat:@"name like %@",@"固定"];
    
    NSArray *result = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    if (result.count > 0) {
    
    
    
    } else {
        
        Goal *goalStatic = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:self.persistentContainer.viewContext];
        
        goalStatic.name = @"固定";
        goalStatic.pic = [UIImage imageNamed:@"static"];
        goalStatic.encourage = @"无帮助但是必须花费的时间";
        goalStatic.showInIndex = YES;
        goalStatic.state = 0;
        goalStatic.color = [UIColor whiteColor];
        goalStatic.bigGoalName = @"";
        goalStatic.isWaste = YES;
        NSMutableDictionary *times = [NSMutableDictionary dictionary];
        
        NSData *timeData = [NSJSONSerialization dataWithJSONObject:times options:NSJSONWritingPrettyPrinted error:nil];
        
        goalStatic.times = timeData;
        goalStatic.beginAndEnd = timeData;
        
        Goal *goalSleep = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:self.persistentContainer.viewContext];
        
        goalSleep.name = @"睡眠";
        goalSleep.pic = [UIImage imageNamed:@"sleep"];
        goalSleep.encourage = @"每天睡觉时间";
        goalSleep.showInIndex = YES;
        goalSleep.state = 0;
        goalSleep.color = [UIColor whiteColor];
        goalSleep.bigGoalName = @"";
        goalSleep.isWaste = YES;

        
        goalSleep.times = timeData;
        goalSleep.beginAndEnd = timeData;

        Goal *goalWaste = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:self.persistentContainer.viewContext];
        
        goalWaste.name = @"浪费";
        goalWaste.pic = [UIImage imageNamed:@"wast"];
        goalWaste.encourage = @"无帮助且非必须的时间";
        goalWaste.showInIndex = YES;
        goalWaste.state = 0;
        goalWaste.color = [UIColor whiteColor];
        goalWaste.bigGoalName = @"";
        goalWaste.isWaste = YES;

        
        goalWaste.times = timeData;
        goalWaste.beginAndEnd = timeData;

        [self saveContext];
    }

    // 初始化跟控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    
    // 设置根控制器
    HallViewController *hallVC = [[HallViewController alloc] init];
    
    self.window.rootViewController = hallVC;
    
    [self.window makeKeyAndVisible];
//    
//    // 注册本地推送
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    
//    // 监听回调
//    center.delegate = self;
//    // 请求授权
//    [center requestAuthorizationWithOptions:(UNAlertStyleAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        
//        
//    }];
//    // 获取当前通知
//    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//        
//        
//    }];
    // 第三方分享相关
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"594a1fb15312ddbd4f0017a5"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"RR3zSOtBfqfD0J6M"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3463412843"  appSecret:@"aceb56dd0ca17d0f5ae773985d29ff94" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
//    /* 钉钉的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
//    
//    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//
//    
//    /* 设置易信的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    
//    /* 设置点点虫（原来往）的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
//    
//    /* 设置领英的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
//    
//    /* 设置Twitter的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
//    
//    /* 设置Facebook的appKey和UrlString */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
//    
//    /* 设置Pinterest的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
//    
//    /* dropbox的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
//    
//    /* vk的appkey */
//    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


#pragma mark - notificationCenterDelegate
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler {
//
//    // 处理通知
//    
//    // 处理完成调用 completeHandle
//
//}

UIBackgroundTaskIdentifier _bgtaskId;

- (void)applicationWillResignActive:(UIApplication *)application {
    // 开启后台处理多媒体时间
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setActive:YES error:nil];
    
    // 后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 申请持续播放ID

    
    _bgtaskId = [AppDelegate backgroundPlayerID:_bgtaskId];
    
    
}

+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskID {
    // 设置并激活音频会话类别
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    // 允许应用接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 设置任务后台ID
    UIBackgroundTaskIdentifier newTaskID = UIBackgroundTaskInvalid;
    
    newTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        if (newTaskID != UIBackgroundTaskInvalid && newTaskID != UIBackgroundTaskInvalid) {
        
            [[UIApplication sharedApplication] endBackgroundTask:backTaskID];
        
        }
        
    }];
    
    return newTaskID;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 发出进入后台通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 发出进入前台通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSDate date] forKey:@"endTime"];
    
    [userDefaults synchronize];
        
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"buBo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
