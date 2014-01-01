//
//  customFileCell.m
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import "customFileCell.h"

@implementation customFileCell

@synthesize bigLabel;
@synthesize smallLabel;
@synthesize imageView;
@synthesize file;
@synthesize downloadButton;
@synthesize progressView;
@synthesize dropboxManager;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateLocalPath
{
    NSManagedObjectContext *context = [dropboxManager.objectManager managedObjectStore].mainQueueManagedObjectContext;
    file.localPath = file.path.lastPathComponent;
    file.savedOnDevice = [NSNumber numberWithBool:YES];
    NSError *error;
    [context save:&error];
    [context saveToPersistentStore:&error];
}
- (IBAction)buttonClick:(id)sender
{
    downloadButton.hidden = YES;
    progressView.hidden = NO;
    progressView.progress = 0.0f;
    [self updateLocalPath];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:file.localPath];
    NSString *urlString = [NSString stringWithFormat:@"https://api-content.dropbox.com/1/files/dropbox%@", [file.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", dropboxManager.userToken] forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:storePath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         progressView.progress = (double) totalBytesRead / (double) totalBytesExpectedToRead;
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"SUCCCESSFULL IMG RETRIEVE to %@!",storePath);
        downloadButton.hidden = NO;
        progressView.hidden = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];
    [operation start];
}
@end
