//
//  uploadFilesViewController.m
//  DropBox
//
//  Created by Viktor Chibotaru on 1/2/14.
//  Copyright (c) 2014 Viktor Chibotaru. All rights reserved.
//

#import "uploadFilesViewController.h"

@interface uploadFilesViewController ()

@end

@implementation uploadFilesViewController

@synthesize dropboxManager;
@synthesize imageView;
@synthesize button;
@synthesize offline;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)uploadPicture:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Upload picture" message:@"Please enter a name for the picture to upload" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok!", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
}
- (IBAction)cancelUpload:(id)sender
{
    imageView.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    button.hidden = NO;
    
}
- (IBAction)offlineTouch:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You are offline, so please login in to be able to upload smth!" delegate:Nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
    [alert show];
}
- (void) setOffline:(BOOL)selectedOffline
{
    offline = selectedOffline;
    [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    if (offline) {
        [button addTarget:self action:@selector(offlineTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [button addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setOffline:offline];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelUpload:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadPicture:)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)choosePicture:(id)sender {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    imageView.image = originalImage;
    imageView.hidden = NO;
    button.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (!textField || [textField.text length] == 0) {
            UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Upload picture" message:@"Please enter a name for the picture to upload" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok!", nil];
            newAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [newAlert show];
            return;
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/dropbox/%@?overwrite=false", textField.text]]];
        [request setHTTPMethod:@"PUT"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", dropboxManager.userToken] forHTTPHeaderField:@"Authorization"];
        NSData *imageData= UIImageJPEGRepresentation(imageView.image, 1.0);
        [request setValue:[NSString stringWithFormat:@"%u", [imageData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:imageData];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:activity];
        activity.center = self.view.center;
        [activity startAnimating];
        self.view.alpha = 0.5f;
        [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
            [activity stopAnimating];
            self.view.alpha = 1.0f;
            NSLog(@"upload successful\n");

        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"%@", [error userInfo]);
            self.view.alpha = 1.0f;
            [activity stopAnimating];
        }];
        [operation start];
        
    }
}
@end
