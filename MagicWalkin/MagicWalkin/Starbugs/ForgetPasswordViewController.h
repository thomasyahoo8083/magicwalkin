#import <UIKit/UIKit.h>
#import "TopMenuViewController.h"
#import "FavoriteController.h"
#import "NearByController.h"
#import "NavigationBarViewController.h"
#import "SignupViewController.h"
#import "ForgetPasswordViewController.h"
#import "forgetPwdViewController.h"
#import "Constant.h"

#import <Foundation/Foundation.h>

@interface ForgetPasswordViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {
    
    IBOutlet UIButton *btnback;
    IBOutlet UIButton *btnforgetpwd;
    IBOutlet UITextField *txtemail;
    
}

-(IBAction) backtoview : (id) sender;
-(IBAction) forgetpwd :(id)sender;


@property (nonatomic, retain) UIButton *btnback;
@property (nonatomic, retain) UIButton *btnforgetpwd;
@property (nonatomic, retain) UITextField *txtemail;

@end
