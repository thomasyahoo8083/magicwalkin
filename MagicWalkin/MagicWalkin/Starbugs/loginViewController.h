#import <UIKit/UIKit.h>
#import "TopMenuViewController.h"
#import "FavoriteController.h"
#import "NearByController.h"
#import "NavigationBarViewController.h"
#import "SignupViewController.h"
#import "ForgetPasswordViewController.h"
#import "Constant.h"

#import <Foundation/Foundation.h>

@interface loginViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {
    
    IBOutlet UIView *loginview;
    IBOutlet UIScrollView *loginscview;
    IBOutlet UITextField *txtemail;
    IBOutlet UITextField *txtpwd;
    IBOutlet UILabel *lblemail;
    IBOutlet UILabel *lblpwd;
    
    IBOutlet UIButton *btnsignup;
    IBOutlet UIButton *btnforgetpwd;
    
}

#pragma mark - Login Method
- (IBAction)login :(id) sender;
- (void) loginprocess;

#pragma mark - Switch View Method
- (IBAction)switchtosignup:(id) sender;
- (IBAction)switchtoforgetpwd:(id)sender;

@property(nonatomic, retain) UIView *loginview;
@property(nonatomic, retain) UIScrollView *loginscview;
@property(nonatomic, retain) UITextField *txtemail;
@property(nonatomic, retain) UITextField *txtpwd;
@property(nonatomic, retain) UILabel *lblemail;
@property(nonatomic, retain) UILabel *lblpwd;
@property(nonatomic, retain) UIButton *btnsignup;
@property(nonatomic, retain) UIButton *btnforgetpwd;

@end
