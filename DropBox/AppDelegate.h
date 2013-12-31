//
//  AppDelegate.h
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dropboxClient.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, dropboxSyncProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) dropboxClient *dropboxManager;
@end
