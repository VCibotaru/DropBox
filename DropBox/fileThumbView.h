//
//  fileThumbView.h
//  DropBox
//
//  Created by Viktor Chibotaru on 1/2/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fileThumbView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) File *file;
@property (strong, nonatomic) dropboxClient *dropboxManager;
@end
