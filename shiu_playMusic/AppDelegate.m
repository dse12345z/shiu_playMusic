//
//  AppDelegate.m
//  shiu_playMusic
//
//  Created by allen_hsu on 2015/10/15.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicsListViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav pushViewController:[MusicsListViewController new] animated:NO];
    self.window.rootViewController = [MusicsListViewController new];
    [self.window makeKeyAndVisible];

    return YES;
}


@end
