//
//  AppDelegate.m
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import "AppDelegate.h"
#import "dropboxClient.h"


@implementation AppDelegate

@synthesize dropboxManager;
@synthesize tabBarController;
@synthesize first;
@synthesize second;
@synthesize third;
@synthesize fourth;

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
- (void) didLogout
{
    first.offlineMode = YES;
    third.offline = YES;
    fourth.offline = YES;
}
-(void) didLogin: (BOOL) offline;
{
    
    
    if (!first) {
        tabBarController = [[UITabBarController alloc] init];
        
        first = [[remoteFilesViewController alloc] init];
        first.dropboxManager = dropboxManager;
        first.title = @"Your DropBox files";
        UINavigationController *firstNavController = [[UINavigationController alloc] initWithRootViewController:first];
        firstNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dropbox files" image:[UIImage imageNamed:@"wifi.png"] tag:0];
        
        second = [[savedFilesInfoViewController alloc] init];
        second.dropboxManager = dropboxManager;
        second.title = @"Saved files";
        UINavigationController *secondNavController = [[UINavigationController alloc] initWithRootViewController:second];
        second.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Saved files" image:[UIImage imageNamed:@"arrow-big-04.png"] tag:1];
        
        third = [[uploadFilesViewController alloc] initWithNibName:@"uploadFilesViewController" bundle:[NSBundle mainBundle]];
        third.dropboxManager = dropboxManager;
        third.title = @"Upload photos";
        UINavigationController *thirdNavController = [[UINavigationController alloc] initWithRootViewController:third];
        thirdNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Upload files" image:[UIImage imageNamed:@"arrow-big-03.png"] tag:2];
        
        fourth = [[settingsViewController alloc] initWithNibName:@"settingsViewController" bundle:[NSBundle mainBundle]];
        fourth.dropboxManager = dropboxManager;
        fourth.title = @"Settings";
        UINavigationController *fourthNavController = [[UINavigationController alloc] initWithRootViewController:fourth];
        fourthNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"gear.png"] tag:3];
        
        tabBarController.viewControllers = [NSArray arrayWithObjects:firstNavController, secondNavController, thirdNavController, fourthNavController, nil];
        self.window.rootViewController = tabBarController;
    }
    
    first.offlineMode = offline;
    fourth.offline = offline;
    third.offline = offline;
    
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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        dropboxManager.uid = [userDefaults stringForKey:@"dropboxUID"];
        if (!dropboxManager.uid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"No valid user info found in userDefaults, so no files will be displayed. Please log in!" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
            [alert show];
        }
        [self didLogin:YES];
        
    }
    
}
@end
