//
//  remoteFilesViewController.m
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import "remoteFilesViewController.h"
#import "File.h"
#import "customFileCell.h"
#import "savedFilesInfoViewController.h"

@interface remoteFilesViewController ()

@end

@implementation remoteFilesViewController

@synthesize dropboxManager;
@synthesize offlineMode;

- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([File class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"path" ascending:YES]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(uid == %@)", dropboxManager.uid]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dropboxManager.objectManager managedObjectStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:@"remoteFiles"];
        self.fetchedResultsController.delegate = self;
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) fetchFiles
{
    NSManagedObjectContext *context = [dropboxManager.objectManager managedObjectStore].mainQueueManagedObjectContext;
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    for (File *file in self.fetchedResultsController.fetchedObjects) {
        if ([file.savedOnDevice boolValue] == NO) {
            [toDelete addObject:file];
        }
    }
    for (File *file in toDelete) {
        [context deleteObject:file];
    }
    NSError *error;
    [context save:&error];
    [context saveToPersistentStore:&error];
    [dropboxManager updateFiles];

}
-(IBAction)refreshFileList:(id)sender
{
    if (offlineMode) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You are offline, please login to refresh file list" delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self fetchFiles];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFileList:)];
    if (!offlineMode) {
        [self fetchFiles];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self.fetchedResultsController fetchedObjects] count];
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customFileCell";
    customFileCell *cell = (customFileCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"customFileCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    File *file = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.bigLabel.text = file.path.lastPathComponent;
    cell.smallLabel.text = [NSString stringWithFormat:@"File size: %@", file.size];
    if ([file.savedOnDevice boolValue] == YES) {
        cell.downloadButton.hidden = YES;
        cell.bigLabel.text = [NSString stringWithFormat:@"Saved in: %@", file.localPath];
    }
    else {
        cell.downloadButton.hidden = NO;
    }
    if (offlineMode == YES) {
        cell.downloadButton.hidden = YES;
    }
    cell.dropboxManager = dropboxManager;
    cell.file = file;
    NSString *fileType = [NSString stringWithFormat:@"%@48.gif", file.icon];
    cell.imageView.image = [UIImage imageNamed:fileType];
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView reloadData];
}
@end
