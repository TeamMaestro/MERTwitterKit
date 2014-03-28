//
//  MERAppDelegate.m
//  MERTwitterKitDemo
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERAppDelegate.h"
#import "MERRootViewController.h"

@implementation MERAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MERRootViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
