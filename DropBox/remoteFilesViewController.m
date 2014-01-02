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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!offlineMode) [dropboxManager updateFiles];

    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if ([file.savedOnDevice boolValue] == YES) {
        cell.downloadButton.hidden = YES;
        cell.bigLabel.text = [NSString stringWithFormat:@"Saved in: %@", file.localPath];
    }
    else {
         cell.smallLabel.text = [NSString stringWithFormat:@"File size: %@", file.size];
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    fileInfoViewController *detailViewController = [[fileInfoViewController alloc] initWithNibName:@"fileInfoViewController" bundle:nil];
    detailViewController.selectedFile = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detailViewController animated:YES];
}*/
@end
