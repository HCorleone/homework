//
//  AppDelegate.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/9.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "LoginViewController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TTUserManager *manager = [TTUserManager sharedInstance];
    if (manager.currentUser.name == nil) {
        manager.isLogin = NO;
        [manager saveCurrentUserInfo];
    }
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    //umeng初始化
    [UMConfigure initWithAppkey:@"5bed3ff1b465f50e1200008e" channel:@"App Store"];
    // U-Share 平台设置
    [self configUSharePlatforms];
    
    //向微信注册
    [WXApi registerApp:@"wxdd59bf4228be5b2d"];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
        return [WXApi handleOpenURL:url delegate:loginVC];

}



- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdd59bf4228be5b2d" appSecret:@"e21f45c9103b92de4b64cea1fb304ab3" redirectURL:@"http://abc.tatatimes.com/palmhomework.html"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://abc.tatatimes.com/palmhomework.html"];
    
}


- (void)setupViewControllers{
    
    UIViewController *firstVC = [[MainViewController alloc]init];
    UIViewController *firstNC = [[UINavigationController alloc]initWithRootViewController:firstVC];
    
    UIViewController *secondVC = [[MyViewController alloc]init];
    UIViewController *secondNC = [[UINavigationController alloc]initWithRootViewController:secondVC];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc]init];
    [tabBarController setViewControllers:@[firstNC, secondNC]];
    
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"学习", @"我的"];
//    NSArray *tabBarItemTitles = @[@"学习", @"我的"];
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    
    [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), 48)];
    
//    tabBar.backgroundView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
//        [item setTitle:tabBarItemTitles[index]];
//        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-激活",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-未激活",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}




















- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
