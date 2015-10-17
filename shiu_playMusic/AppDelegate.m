//
//  AppDelegate.m
//  shiu_playMusic
//
//  Created by allen_hsu on 2015/10/15.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicsListViewController.h"
#import "DownloadMusicViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UINavigationController *musicsListNavigationController = [[UINavigationController alloc] init];
    MusicsListViewController *musicsListView = [[MusicsListViewController alloc] init];
    [musicsListNavigationController pushViewController:musicsListView animated:NO];
    UITabBarItem *musicsListBarItem=[[UITabBarItem alloc]initWithTitle:@"Audio" image:[UIImage imageNamed:@"musicVideoIcon.png"] selectedImage:[UIImage imageNamed:@"musicVideoIcon.png.png"]];
    musicsListNavigationController.tabBarItem=musicsListBarItem;

    UINavigationController *downloadMusicNavigationController = [[UINavigationController alloc] init];
    DownloadMusicViewController *downloadMusicView = [[DownloadMusicViewController alloc] init];
    [downloadMusicNavigationController pushViewController:downloadMusicView animated:NO];
    UITabBarItem *downloadBarItem=[[UITabBarItem alloc]initWithTitle:@"Download" image:[UIImage imageNamed:@"downloadIcon.png"] selectedImage:[UIImage imageNamed:@"downloadIcon.png"]];
    downloadMusicNavigationController.tabBarItem=downloadBarItem;
    
    //  宣告 TabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //  將物件加入 TabBarController
    tabBarController.viewControllers = [NSArray arrayWithObjects: downloadMusicNavigationController,musicsListNavigationController , nil];

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];






    return YES;
}


@end
