#import "BaseViewController.h"
#import "Constant.h"
#import "SBPageControl.h"
#import "UIBorderView.h"
#import "Item.h"

@interface ItemDetailViewController : BaseViewController<UIScrollViewDelegate, UIWebViewDelegate>
{
	BOOL isAnimating;
	UIScrollView *mainScrollView;
	UILabel *lblTitle;
	UIView *header;
	
	UIImageView *ivToolbar;
	
	UIScrollView *productImgScrollView;
	SBPageControl *productImgPageControl;
	
	int currentDisplayItemIndex;
	
	UIBorderView *borderView;
	UIWebView *webView;
	
	UIButton *butPrevious;
	UIButton *butNext;
	
	UIButton *butAddToFav;
	UIButton *butShare;
	
	NSArray *_items;
}

-(void) presentDataOfItemAtIndex: (int) index;
-(id) initWithItems: (NSArray *) items AndDisplayingItemIndex: (int) index;


@end
