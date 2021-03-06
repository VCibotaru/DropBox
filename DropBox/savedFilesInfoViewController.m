//
//  fileInfoViewController.m
//  DropBox
//
//  Created by Viktor Chibotaru on 1/1/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import "savedFilesInfoViewController.h"
#import "fileThumbView.h"
#import "detailViewController.h"

@interface savedFilesInfoViewController ()

@end

@implementation savedFilesInfoViewController

@synthesize selectedFile;
@synthesize dropboxManager;
@synthesize fileViews;

#define THUMB_WIDTH 100
#define THUMB_HEIGHT 100
#define THUMB_VERTICAL_SPACE 10
#define THUMB_HORIZONTAL_SPACE 50

- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([File class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"path" ascending:YES]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(uid == %@) && (savedOnDevice == YES)", dropboxManager.uid]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dropboxManager.objectManager managedObjectStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:@"localFile"];
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
- (IBAction)didTap:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *) sender;
    fileThumbView *thumbView = (fileThumbView *) tap.view;
    File *file = thumbView.file;
    detailViewController *detail = [[detailViewController alloc] initWithNibName:@"detailViewController" bundle:[NSBundle mainBundle]];
    detail.file = file;
    detail.hidesBottomBarWhenPushed = YES;
    detail.dropboxManager = dropboxManager;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void) refreshSubViews
{
    if (!fileViews) {
        fileViews = [[NSMutableArray alloc] init];
    }
    for (fileThumbView *thumbView in fileViews) {
        [thumbView removeFromSuperview];
    }
    [fileViews removeAllObjects];
    int i = 0;
    for (File *file in self.fetchedResultsController.fetchedObjects) {
        if ([file.savedOnDevice boolValue] == NO || file.localPath == nil) continue;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"fileThumbView" owner:self options:nil];
        fileThumbView *thumbView = [nib objectAtIndex:0];
        [thumbView setFrame:CGRectMake(THUMB_HORIZONTAL_SPACE + (THUMB_HORIZONTAL_SPACE + THUMB_WIDTH) * (i % 2),
                                       THUMB_VERTICAL_SPACE + (THUMB_VERTICAL_SPACE + THUMB_HEIGHT) * (i / 2)
                                       , THUMB_WIDTH, THUMB_HEIGHT)];
        thumbView.dropboxManager = dropboxManager;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [thumbView addGestureRecognizer:tap];
        [thumbView setFile:file];
        [self.view addSubview:thumbView];
        [fileViews addObject:thumbView];
        i++;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self refreshSubViews];
}
@end
