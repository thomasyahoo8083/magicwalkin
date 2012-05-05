
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NearByViewController.h"
#import "ShopManager.h"

@interface NearByController : BaseViewController<ShopManagerDelegate, BaseViewDelegate>
{
	NearByViewController *fvc;	
	ShopManager *manager;
    
    @public
    UINavigationController *navController;
}
@end
