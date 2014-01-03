//
//  fileThumbView.m
//  DropBox
//
//  Created by Viktor Chibotaru on 1/2/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import "fileThumbView.h"

@implementation fileThumbView

@synthesize imageView;
@synthesize file;
@synthesize label;
@synthesize dropboxManager;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setFile:(File *)fileToSet
{
    file = fileToSet;
    label.text = file.localPath;
    if ([file.thumbExists boolValue] == YES) {
        NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@",file.localPath]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
            imageView.image = [UIImage imageWithContentsOfFile:storePath];
        }
        else {
            NSString *urlString = [NSString stringWithFormat:@"https://api-content.dropbox.com/1/thumbnails/dropbox%@", [file.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", dropboxManager.userToken] forHTTPHeaderField:@"Authorization"];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:storePath append:NO];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                imageView.image = [UIImage imageWithContentsOfFile:storePath];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"%@", error);
            }];
            [operation start];
        }
    }
    else {
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@48.gif", file.icon]];
    }

}
@end
