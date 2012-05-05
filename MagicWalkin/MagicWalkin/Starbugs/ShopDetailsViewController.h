
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Shop.h"
#import "Constant.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PromotionItem.h"
#import "SBPageControl.h"
#import "ItemListViewController.h"
#import "ItemDetailViewController.h"
#import "AsyncImageView.h"

@interface ShopDetailsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MKMapViewDelegate, BaseViewDelegate>
{
	
	UITableView *mainTableView;
	UIImage *starImage;
	MKMapView *mapView;
	
	UIScrollView *svDealsAndFinds;
	SBPageControl *findAndDealsPageControl;
}

@property (retain, nonatomic) Shop *shop;
-(id) initWithShop: (Shop *) theShop;

@end
