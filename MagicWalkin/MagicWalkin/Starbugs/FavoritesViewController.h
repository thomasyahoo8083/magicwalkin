
#import <UIKit/UIKit.h>
#import "UIBorderView.h"
#import "PromotionItem.h"
#import "Constant.h"
#import "SBPageControl.h"
#import "BaseViewController.h"
#import "AsyncImageView.h"

@interface FavoritesViewController : BaseViewController<UIScrollViewDelegate>
{
	UIBorderView *vTopTenFaves;
	UILabel *lblTopTenRank;
	UIScrollView *svtopTen;
	SBPageControl *topTenPageControl;
	
	PromotionItem *topTenItems[10];
	
	UIView *vTopTenOverlay;
	AsyncImageView *ivTopTenOverlayLogo;
	UILabel *lblTopTenOverlayBrand;
	UILabel *lblTopTenOverlayDescription;
	
	UINavigationController *navController;
}


@end
