//
//  fileInfoViewController.h
//  DropBox
//
//  Created by Viktor Chibotaru on 1/1/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"
#import "dropboxClient.h"

@interface savedFilesInfoViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) File *selectedFile;
@property (strong, nonatomic) dropboxClient *dropboxManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableArray *fileViews;
@end
