//
//  AppDelegate.m
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import "AppDelegate.h"
#import "dropboxClient.h"
#import "remoteFilesViewController.h"

@implementation AppDelegate

@synthesize dropboxManager;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"You are now redirected to dropbox login page" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:@"Stay Offline!", nil];
    [alert show];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [dropboxManager parseOpenURL:url];
    return YES;
}
-(void) didLogin: (BOOL) offline;
{
    tabBarController = [[UITabBarController alloc] init];
    remoteFilesViewController *first = [[remoteFilesViewController alloc] initWithNibName:@"remoteFilesViewController" bundle:[NSBundle mainBundle]];
    first.dropboxManager = dropboxManager;
    first.offlineMode = offline;
    first.title = @"Your DropBox files";
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:first];
    navController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    
    tabBarController.viewControllers = [NSArray arrayWithObject:navController];
    self.window.rootViewController = tabBarController;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dropboxManager = [[dropboxClient alloc] init];
    dropboxManager.delegate = self;
    [dropboxManager setUpRestKit];
    if (!buttonIndex) {
        [dropboxManager dropBoxLogin];
    }
    else {
        [self didLogin:YES];
        
    }
    
}
@end
