//
//  AppDelegate.h
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dropboxClient.h"
#import "remoteFilesViewController.h"
#import "savedFilesInfoViewController.h"
#import "uploadFilesViewController.h"
#import "settingsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, dropboxSyncProtocol, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) dropboxClient *dropboxManager;
@property (strong, nonatomic) UITabBarController * tabBarController;
@property (strong, nonatomic) remoteFilesViewController *first;
@property (strong, nonatomic) savedFilesInfoViewController *second;
@property (strong, nonatomic) uploadFilesViewController *third;
@property (strong, nonatomic) settingsViewController *fourth;
@end
