//
//  ForgetPasswordViewController.m
//  MagicWalkin
//
//  Created by Thomas Chan on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

@synthesize btnback;
@synthesize btnforgetpwd;

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

-(void) backtoview:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Forget Password Method
-(void) forgetpwd:(id)sender {
    
}


-(void) dealloc {
    
    [btnback dealloc];
    [btnforgetpwd dealloc];
    
    [super dealloc];
}

@end
