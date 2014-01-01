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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setFile:(File *)file
{
    
}
@end
