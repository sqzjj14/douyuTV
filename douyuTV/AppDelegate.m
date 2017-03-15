//
//  AppDelegate.m
//  douyuTV
//
//  Created by 吴凡 on 17/3/15.
//  Copyright © 2017年 吴凡. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LiveViewController.h"
#import "FollowViewController.h"
#import "ProfileViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong) UITabBarController *tabbarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    HomeViewController * homeVc = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVc];
    
    LiveViewController * liveVc = [[LiveViewController alloc]init];
    UINavigationController *liveNav = [[UINavigationController alloc]initWithRootViewController:liveVc];
    
    FollowViewController *followVc = [[FollowViewController alloc]init];
    UINavigationController *followNav = [[UINavigationController alloc]initWithRootViewController:followVc];
    
    ProfileViewController *profileVc = [[ProfileViewController alloc]init];
    UINavigationController *profileNav = [[UINavigationController alloc]initWithRootViewController:profileVc];
    
    _tabbarController = [[UITabBarController alloc ]init];
    _tabbarController.viewControllers = [NSArray arrayWithObjects:homeNav,liveNav,followNav,profileNav, nil];
    
    UITabBar *tabbar = _tabbarController.tabBar;
    UITabBarItem *firstItem = [tabbar.items objectAtIndex:0];
    firstItem.tag = 1;
    UITabBarItem *secItem = [tabbar.items objectAtIndex:1];
    secItem.tag =2;
    UITabBarItem *thrItem = [tabbar.items objectAtIndex:2];
    thrItem.tag =3;
    UITabBarItem *fourItem = [tabbar.items objectAtIndex:3];
    fourItem.tag =4;
    
    firstItem.title = @"首页";
    secItem.title = @"直播";
    thrItem.title = @"关注";
    fourItem.title = @"我的";
    firstItem.image = [UIImage imageNamed:@"btn_home_normal"];
    UIImage *homeImageSel = [UIImage imageNamed:@"btn_home_selected"];
    homeImageSel = [homeImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstItem.selectedImage = homeImageSel;
    
    secItem.image = [UIImage imageNamed:@"btn_column_normal"];
    UIImage *secImageSel = [UIImage imageNamed:@"btn_column_selected"];
    secImageSel = [secImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secItem.selectedImage = secImageSel;
    
    
    thrItem.image = [UIImage imageNamed:@"btn_live_normal"];
    UIImage *thirdImageSel = [UIImage imageNamed:@"btn_live_selected"];
    thirdImageSel = [thirdImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thrItem.selectedImage = thirdImageSel;
    
    fourItem.image = [UIImage imageNamed:@"btn_user_normal"];
    UIImage *fourImageSel = [UIImage imageNamed:@"btn_user_selected"];
    fourImageSel = [fourImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fourItem.selectedImage = fourImageSel;
    
    NSMutableDictionary *atts=[NSMutableDictionary dictionary];
    atts[NSFontAttributeName]=[UIFont systemFontOfSize:12];
    atts[NSForegroundColorAttributeName]=[UIColor grayColor];
    
    NSMutableDictionary *selectedAtts=[NSMutableDictionary dictionary];
    selectedAtts[NSFontAttributeName]=atts[NSFontAttributeName];
    selectedAtts[NSForegroundColorAttributeName]=[UIColor orangeColor];
    
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:atts forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAtts forState:UIControlStateSelected];
    
    self.window.rootViewController = _tabbarController;

    [self.window makeKeyAndVisible];

    return YES;
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
