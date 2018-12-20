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
#import "QRScanViewController.h"

@interface AppDelegate ()<RDVTabBarDelegate>

@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) UINavigationController *firstNC;
@property (nonatomic, strong) UINavigationController *thirdNC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //判断是否有用户登陆
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
    
    return [WXApi handleOpenURL:url delegate:self.loginVC];
    
}

- (void)test:(NSNotification *)note {
    if ([note.object isKindOfClass:[LoginViewController class]]) {
        self.loginVC = note.object;
    }
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
    
    MainViewController *firstVC = [[MainViewController alloc]init];
    UINavigationController *firstNC = [[UINavigationController alloc]initWithRootViewController:firstVC];
    self.firstNC = firstNC;
    
    QRScanViewController *secondVC = [[QRScanViewController alloc]init];
    UINavigationController *secondNC = [[UINavigationController alloc]initWithRootViewController:secondVC];
    
    MyViewController *thirdVC = [[MyViewController alloc]init];
    UINavigationController *thirdNC = [[UINavigationController alloc]initWithRootViewController:thirdVC];
    self.thirdNC = thirdNC;
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc]init];
    [tabBarController setViewControllers:@[firstNC, secondNC, thirdNC]];
    
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}


//为了制作凸起tarbartitem的效果，修改了rdvtabbar的一些东西，加了边线和修改了图像的位置
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"学习", @"扫一扫bluev2", @"我的"];
//    NSArray *tabBarItemTitles = @[@"", @"", @""];
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    tabBar.delegate = self;
    [tabBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66 + BOT_OFFSET)];
    tabBar.backgroundColor = [UIColor clearColor];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        UIImage *selectedimage;
        UIImage *unselectedimage;
        if (index == 1) {
            selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                          [tabBarItemImages objectAtIndex:index]]];
            unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                            [tabBarItemImages objectAtIndex:index]]];
        }
        else {
            selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-选中v2",
                                                      [tabBarItemImages objectAtIndex:index]]];
            unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-默认v2",
                                                        [tabBarItemImages objectAtIndex:index]]];
            item.itemHeight = 48 + BOT_OFFSET;
        }

        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

#pragma mark - RDVTabbarDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    
    if (index == 1) {
        if (self.viewController.selectedIndex == 0) {
            MainViewController *mainVC = (MainViewController *)self.firstNC.viewControllers[0];
            [mainVC toScan];
        }
        else if (self.viewController.selectedIndex == 2){
            MyViewController *myVC = (MyViewController *)self.thirdNC.viewControllers[0];
            [myVC toScan];
        }
        return NO;
    }
    else {
        if ([[self.viewController delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
            if (![[self.viewController delegate] tabBarController:self.viewController shouldSelectViewController:[self.viewController viewControllers][index]]) {
                return NO;
            }
        }
        
        if ([self.viewController selectedViewController] == [self.viewController viewControllers][index]) {
            if ([[self.viewController selectedViewController] isKindOfClass:[UINavigationController class]]) {
                UINavigationController *selectedController = (UINavigationController *)[self.viewController selectedViewController];
                if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                    [selectedController popToRootViewControllerAnimated:YES];
                }
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self.viewController viewControllers] count]) {
        return;
    }

    [self.viewController setSelectedIndex:index];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"wechatLogin" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
