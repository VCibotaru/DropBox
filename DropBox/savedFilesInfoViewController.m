//
//  fileInfoViewController.m
//  DropBox
//
//  Created by Viktor Chibotaru on 1/1/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import "savedFilesInfoViewController.h"
#import "fileThumbView.h"

@interface savedFilesInfoViewController ()

@end

@implementation savedFilesInfoViewController

@synthesize selectedFile;
@synthesize dropboxManager;




- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([File class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"path" ascending:YES]];
        //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(uid == %@) && (savedOnDevice == YES)", dropboxManager.uid]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dropboxManager.objectManager managedObjectStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:@"File"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"%u", controller.fetchedObjects.count);
}
@end
