//
//  AppDelegate.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/9.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AppDelegate.h"
#import "AnswerViewController.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "LoginViewController.h"
#import "QRScanViewController.h"
#import "Book.h"

@interface AppDelegate ()<RDVTabBarDelegate>

@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) UINavigationController *firstNC;
@property (nonatomic, strong) UINavigationController *thirdNC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //判断是否为第一次安装
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstInstalled"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstInstalled"];
    }
    
    //判断是否有浏览记录的数据库，没有就生成
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"history.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbpath] == NO) {
        FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE IF NOT EXISTS 'history' ('coverURL' VARCHAR(30), 'title' VARCHAR(30), 'subject' VARCHAR(30), 'bookVersion' VARCHAR(30), 'uploaderName' VARCHAR(30), 'answerID' VARCHAR(30), 'grade' VARCHAR(30) , 'currentTime' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
    
    //判断是否有我的下载数据库，没有就生成
    NSString *doc1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath1 = [doc1 stringByAppendingPathComponent:@"MyDownload.sqlite"];
    NSFileManager *fileManager1 = [NSFileManager defaultManager];
    if ([fileManager1 fileExistsAtPath:dbpath1] == NO) {
        FMDatabase *db1 = [FMDatabase databaseWithPath:dbpath1];
        if ([db1 open]) {
            NSString *sql1 = @"CREATE TABLE IF NOT EXISTS 'downloadModel' ('coverImgPath' VARCHAR(50), 'title' VARCHAR(30), 'subject' VARCHAR(30), 'bookVersion' VARCHAR(30), 'uploaderName' VARCHAR(30), 'answerID' VARCHAR(30), 'grade' VARCHAR(30) , 'currentTime' VARCHAR(30))";
            NSString *sql2 = @"CREATE TABLE IF NOT EXISTS 'imagePath' ('answerID' VARCHAR(30),'thumbsPath' VARCHAR(50),'detailPath' VARCHAR(50),'idx' VARCHAR(20))";
            BOOL res1 = [db1 executeUpdate:sql1];
            BOOL res2 = [db1 executeUpdate:sql2];
            if (!res1 && !res2) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db1 close];
        } else {
            NSLog(@"error when open db");
        }
    }
    
    //创建用于存放下载图片的目录
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * imgFilePath = [docsdir stringByAppendingPathComponent:@"MyDownloadImages"];//将需要创建的串拼接到后面
    NSFileManager *fileManager2 = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager2 fileExistsAtPath:imgFilePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
        [fileManager2 createDirectoryAtPath:imgFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
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
    [UMConfigure initWithAppkey:@"5c3c008bb465f53b1b000387" channel:@"App Store"];
    // U-Share 平台设置
    [self configUSharePlatforms];
    
    //向微信注册
    [WXApi registerApp:WX_APPID];
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //分享书籍返回的url样式：tataera.downloadhomework://book/（answerID），并跳转到相应的答案详情页
    
//    NSLog(@"%@",[[url absoluteString] substringFromIndex:30]);
    
    NSString *checkURL = [url absoluteString];
    if (checkURL.length > 7) {
        checkURL = [checkURL substringToIndex:7];
        if ([checkURL isEqualToString:@"tataera"]) {
            if ([url absoluteString].length >= 32) {
                MainViewController *mainVC = (MainViewController *)self.firstNC.viewControllers[0];
                MyViewController *myVC = (MyViewController *)self.thirdNC.viewControllers[0];
                
                [mainVC.navigationController popToRootViewControllerAnimated:YES];
                [myVC.navigationController popToRootViewControllerAnimated:NO];
                
                AnswerViewController *answerVC = [[AnswerViewController alloc]init];
                Book *model = [Book new];
                model.answerID = [[url absoluteString] substringFromIndex:32];
                answerVC.bookModel = model;
                //        [mainVC.navigationController popToRootViewControllerAnimated:NO];
                [mainVC.navigationController pushViewController:answerVC animated:YES];
                
                [self.viewController setSelectedIndex:0];
                return NO;
            }
        }
        else {
            return [WXApi handleOpenURL:url delegate:self.loginVC];
        }
    }
    
    return NO;
}

- (void)test:(NSNotification *)note {
    if ([note.object isKindOfClass:[LoginViewController class]]) {
        self.loginVC = note.object;
    }
}

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPID appSecret:WX_APPKEYSECRET redirectURL:@"http://abc.tatatimes.com/downloadhomework.html"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1108038381"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://abc.tatatimes.com/palmhomework.html"];
    
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
    NSArray *tabBarItemImages = @[@"学习", @"扫一扫orangev2", @"我的"];
    
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
