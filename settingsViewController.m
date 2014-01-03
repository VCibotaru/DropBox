//
//  settingsViewController.m
//  DropBox
//
//  Created by Viktor Chibotaru on 1/3/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import "settingsViewController.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

@synthesize dropboxManager;
@synthesize offline;
@synthesize currentUser;
@synthesize countryLabel;
@synthesize uidLabel;
@synthesize linkLabel;
@synthesize nameLabel;
@synthesize progressView;
@synthesize ratioLabel;
@synthesize infoLabel;

- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(uid == %@)", dropboxManager.uid]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dropboxManager.objectManager managedObjectStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:@"users"];
        self.fetchedResultsController.delegate = self;
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)Logout:(id)sender
{
    infoLabel.text = @"last logged user info";
    [dropboxManager dropBoxLogout];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(Login:)];
}
- (IBAction)Login:(id)sender
{
    infoLabel.text = @"current user info";
    [dropboxManager dropBoxLogin];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(Logout:)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dropboxManager updateUser];
    [self refreshUserInfo];
    if (offline) {
        infoLabel.text = @"last logged user info";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(Login:)];
    }
    else {
        infoLabel.text = @"current user info";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(Logout:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) refreshUserInfo
{
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) return;
    currentUser = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    if (!currentUser) return;
    nameLabel.text = [NSString stringWithFormat:@"Name: %@",currentUser.displayName];
    linkLabel.text = [NSString stringWithFormat:@"URL: %@",currentUser.referralLink];
    uidLabel.text = [NSString stringWithFormat:@"UID: %@",currentUser.uid];
    countryLabel.text = [NSString stringWithFormat:@"Country: %@",currentUser.country];
    double ratio = [currentUser.quotaInfo.normal doubleValue] / [currentUser.quotaInfo.quota doubleValue];
    ratioLabel.text = [NSString stringWithFormat:@"Used/Available Memory Ratio: %.3lf", ratio];
    progressView.progress = ratio;
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self refreshUserInfo];
}

@end
