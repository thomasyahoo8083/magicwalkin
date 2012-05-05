#import <UIKit/UIKit.h>
#import "TopMenuViewController.h"
#import "FavoriteController.h"
#import "NearByController.h"
#import "NavigationBarViewController.h"
#import "loginViewController.h"
#import "DeviceManager.h"
#import "Constant.h"

#import <Foundation/Foundation.h>


@interface SignupViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {
    
    IBOutlet UIView *signupview;
    IBOutlet UIScrollView * scview;
    IBOutlet UIButton *btncam;
    IBOutlet UIButton *btnsignup;
    IBOutlet UIButton *btnback;
    IBOutlet UIImageView *userimage;

}

-(IBAction)backtoview:(id)sender;

#pragma mark - Sign Up Method
-(IBAction)signup:(id)sender;

#pragma mark - Select Photo Method
-(IBAction)selectphoto:(id)sender;

#pragma mark - UploadImage Method
-(void) uploadimage;

@property (nonatomic, retain) UIView *signupview;
@property (nonatomic, retain) UIScrollView *scview;
@property (nonatomic, retain) UIButton *btncam;
@property (nonatomic, retain) UIButton *btnsignup;
@property (nonatomic, retain) UIButton *btnback;
@property (nonatomic, retain) UIImageView *userimage;

@end
