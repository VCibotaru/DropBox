//
//  customFileCell.h
//  DropBox
//
//  Created by Viktor Chibotaru on 12/31/13.
//  Copyright (c) 2013 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"
#import "dropboxClient.h"

@interface customFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) File *file;
@property (strong, nonatomic) dropboxClient *dropboxManager;
- (IBAction)buttonClick:(id)sender;

@end
