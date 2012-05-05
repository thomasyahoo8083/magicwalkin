#import <UIKit/UIKit.h>
#import "Constant.h"
#import "BaseViewController.h"
#import "UIBorderView.h"
#import <MapKit/Mapkit.h>
#import <QuartzCore/QuartzCore.h>
#import "ShopManager.h"
#import "ShopAnnotation.h"
#import "ShopDetailsViewController.h"
#import "NavigationBarViewController.h"
#import "AsyncImageView.h"

@interface NearByViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, ShopManagerDelegate, MKMapViewDelegate, BaseViewDelegate>
{
	UITableView *listView;
	UIView *topBar;
	UIBorderView *vLeft;
	UILabel *lblLeft;
	
	UIBorderView *vRight;
	UILabel *lblRight;
	
	UIImage *starImage;
	MKMapView *theMapView;
	BOOL isChangingView;
	BOOL showingList;
	
	NSMutableArray *nearestShops;
	ShopManager *shopManager;
}


@end
