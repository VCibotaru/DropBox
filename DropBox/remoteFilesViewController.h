//
//  remoteFilesViewController.h
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dropboxClient.h"

@interface remoteFilesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property dropboxClient *dropboxManager;
@property BOOL offlineMode;
@end
