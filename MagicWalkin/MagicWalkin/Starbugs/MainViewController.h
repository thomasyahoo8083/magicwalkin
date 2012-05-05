#import <UIKit/UIKit.h>
#import "TopMenuViewController.h"
#import "FavoriteController.h"
#import "NearByController.h"
#import "NavigationBarViewController.h"

@interface MainViewController : UIViewController<TopMenuDelegate, NavigationBarDelegate>
{
	TopMenuViewController *topMenuViewController;
	NavigationBarViewController *navbarViewController;
	
	FavoriteController *favoriteController;
	NearByController *nearByController;
	
	BaseViewController *activeViewController;
		
	BOOL isChangingView;
}
@end
