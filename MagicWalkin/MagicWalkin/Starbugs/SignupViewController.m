//
//  SignupViewController.m
//  MagicWalkin
//
//  Created by Thomas Chan on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize signupview;
@synthesize scview;
@synthesize btncam;
@synthesize btnsignup;
@synthesize btnback;
@synthesize userimage;

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
    
    // Do any additional setup after loading the view from its nib.
    
    //Testing Get IP Address
    DeviceManager *devicemanager = [[DeviceManager alloc] init];
    NSLog(@"%@", [devicemanager getIPAddress]);     
    
    /*NSString *result = [self getIPAddress];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"IP Address" message:result delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release]; */
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)backtoview:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Select Photo Method
-(IBAction)selectphoto:(id)sender{
    
    NSLog(@"[SignupViewController]{selectphoto} START");

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController: picker animated: YES];
    [picker release];
    
    
    NSLog(@"[SignupViewController]{selectphoto} END");
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [btncam setImage:image forState:UIControlStateNormal];
    [userimage setImage:image];
    
    NSLog(@"%@", image);

    [image autorelease]; 
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - Sign Up Method
-(IBAction)signup:(id)sender{
    
    NSLog(@"[SignupViewController]{signup} START");
    
    NSLog(@"[SignupViewController]{signup} END");

}




#pragma mark - UploadImage Method
-(void) uploadimage{
    
    NSLog(@"[SignupViewController]{uploadimage} START");
    
    NSLog(@"[SignupViewController]{uploadimage} END");
    
}

- (void)dealloc {
    
    [signupview release];
    [scview release];
    [btncam release];
    [btnsignup release];
    [btnback release];
    [userimage release];
        
    [super dealloc];
    
}

@end
