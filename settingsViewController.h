//
//  settingsViewController.h
//  DropBox
//
//  Created by Viktor Chibotaru on 1/3/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quota.h"

@interface settingsViewController : UIViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) dropboxClient *dropboxManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL offline;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end
