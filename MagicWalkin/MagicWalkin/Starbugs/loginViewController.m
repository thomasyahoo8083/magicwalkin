//
//  loginViewController.m
//  MagicWalkin
//
//  Created by Thomas Chan on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "loginViewController.h"


@implementation loginViewController

@synthesize loginview;
@synthesize loginscview;
@synthesize txtemail;
@synthesize txtpwd;
@synthesize lblemail;
@synthesize lblpwd;
@synthesize btnsignup;
@synthesize btnforgetpwd;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    
    txtemail.keyboardType = UIKeyboardTypeEmailAddress;
    
}

#pragma mark - Login Methods
-(IBAction)login :(id) sender {
    
    NSLog(@"[loginViewController]{login} START");
    
    if ([txtemail.text isEqualToString:@""] || [txtpwd.text isEqualToString:@""]) {
        
        NSString *result = @"Please enter your information";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:result delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];   
        NSLog(@"No input for login");
        
    } else {
        
        //[DELEGATE loadingViewStart:@"Login......"];   //Login Method
        
        NSString *loginUDID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice]uniqueIdentifier]];
        //NSString *loginPushToken = [NSString stringWithFormat:@""];
        NSString *post =[NSString stringWithFormat:@"email=%@&pwd=%@", txtemail.text, txtpwd.text];
        
        //NSString *const hostStr  = SERVERPATH; 
        //NSString *host = [NSString stringWithFormat:@"%@auth.php?", hostStr];
        NSString *hostStr = @"http://dev.star-berry.com/auth.php?";
        hostStr = [hostStr stringByAppendingString:post];
        NSLog(@"hostStr: %@",hostStr);
       
        NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];    
        NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
        NSLog(@"The php return is : %@",serverOutput);

        
    }
    NSLog(@"[loginViewController]{login} END");
    
}

- (void) loginprocess {
    
    //login successful - read plist data from server
    /*if ([loginstatus isEqualToString:@"0"]) {
        
        [[DELEGATE userInfo] setUserInfo:[logindict valueForKey:@"ClientID"] andstringKey: KEY_USERID];
        [lblloginnum setText:[NSString stringWithFormat:@"%@", [[DELEGATE userInfo] getUserInfo:KEY_PHONE]]];
        
        [txtphoneNum resignFirstResponder];
        [txtphoneNum    setHidden:YES];
        
        NSLog(@"Login Successful");
        
    } else {
        
        NSLog (@"login status: %@", loginstatus);
        NSString *result = @"Login Fail";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:result delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];   
        NSLog(@"Login Fail");
    }
    
    [DELEGATE loadingViewStop];	
    */
}

#pragma mark - Switch View Methods
- (IBAction)switchtosignup:(id) sender {
    
    SignupViewController *signupview = [[SignupViewController alloc] initWithNibName:nil bundle:nil];
    [self presentModalViewController:signupview animated:YES];

}

- (IBAction)switchtoforgetpwd:(id)sender{

    ForgetPasswordViewController *forgetpwdview  = [[ForgetPasswordViewController alloc] initWithNibName:nil bundle:nil];
    [self presentModalViewController:forgetpwdview animated:YES];

}


#pragma mark - Text Field Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == txtemail) {
        return (newLength > MAX_NUM_txtEmail) ? NO : YES;
    } else if (textField == txtpwd) {
        return (newLength > MAX_NUM_txtPwd) ? NO : YES;
    }    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [txtemail resignFirstResponder];
    [txtpwd resignFirstResponder];
    
    //[self hidekeyboard];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

-(void) touchesBegan :(NSSet *) touches withEvent:(UIEvent *)event{
	
    [txtemail   resignFirstResponder];
    [txtpwd     resignFirstResponder];
    
    //[self hidekeyboard];
    
	[super touchesBegan:touches withEvent:event ];
}

-(void) hidekeyboard{
    
   /* if (bg.frame.origin.y == -30) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.15f];
        CGRect  rect = [bg frame];
        rect.origin.y = 60;
        [bg setFrame:rect];        
        [UIView commitAnimations];
    }*/
    
}

-(void) showkeyboard{
    
    /*if (bg.frame.origin.y == 60) {    
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.15f];
        CGRect  rect = [bg frame];
        rect.origin.y = -30;
        [bg setFrame:rect];        
        [UIView commitAnimations];
    }*/
      
}


- (void)dealloc {
    
    [loginview release];
    [loginscview release];
    [txtemail release];
    [txtpwd release];
    [lblemail release];
    [lblpwd release];
    [btnsignup release];
    [btnforgetpwd release];
    
    [super dealloc];

}

@end