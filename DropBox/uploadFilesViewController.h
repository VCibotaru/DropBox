//
//  uploadFilesViewController.h
//  DropBox
//
//  Created by Viktor Chibotaru on 1/2/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uploadFilesViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) dropboxClient *dropboxManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) BOOL offline;

- (IBAction)choosePicture:(id)sender;

@end
