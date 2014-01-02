//
//  detailViewController.m
//  DropBox
//
//  Created by Viktor Chibotaru on 1/2/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController

@synthesize file;
@synthesize webView;
@synthesize imageView;
@synthesize dropboxManager;

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
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}
- (IBAction)deleteFile:(id)sender
{
    NSManagedObjectContext *context = [dropboxManager.objectManager managedObjectStore].mainQueueManagedObjectContext;
    NSString *thumbStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@",file.localPath]];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:file.localPath];
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:storePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
    }
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:thumbStorePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:thumbStorePath error:&error];
    }
    file.localPath = nil;
    file.savedOnDevice = [NSNumber numberWithBool:NO];
    [context save:&error];
    [context saveToPersistentStore:&error];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)showOtherApps:(id)sender
{
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:file.localPath];
    NSData *data = [NSData dataWithContentsOfFile:storePath];
    NSArray* dataToShare = [NSArray arrayWithObjects:@"Check it out!", data, nil];
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
    
}
- (void) initViews
{
    NSString *ext = file.localPath.pathExtension;
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:file.localPath];
    NSArray *images = [NSArray arrayWithObjects:@"jpg", @"png", @"gif", @"bmp", @"tiff", @"tif", @"jpeg" , @"ico", nil];
    if ([images containsObject:ext]) {
        self.navigationController.navigationBarHidden = YES;
        self.imageView.image = [UIImage imageWithContentsOfFile:storePath];
        self.imageView.hidden = NO;
        return;
    }
    NSArray *docs = [NSArray arrayWithObjects:@"xls", @"pdf", @"ppt", @"doc", @"rtf", @"key", @"numbers", @"pages", nil];
    if ([docs containsObject:ext]) {
        NSURL *url = [NSURL fileURLWithPath:storePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        webView.hidden = NO;
        return;
    }
    NSLog(@"Unsupported format( for file %@\n", file.localPath);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
    UIBarButtonItem *first = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showOtherApps:)];
    UIBarButtonItem *second = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteFile:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:first, second, nil];
    [self initViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
