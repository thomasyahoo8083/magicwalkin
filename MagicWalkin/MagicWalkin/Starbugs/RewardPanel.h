#import <UIKit/UIKit.h>
#import "NavBarButton.h"
#import "Constant.h"
#import "RewardItem.h"
#import "ItemDetailViewController.h"

@interface RewardPanel : UIView<BaseViewDelegate>
{
	BOOL isAnimating;
	NavBarButton *button;
	UILabel *lblRewardTitle;
	UIView *vMiddleBg;
	
	UILabel *lblMiddle;
	UIScrollView *sView;

	RewardItem *detailingItem;
	BOOL isShowingDetail;
	int showingDetailItemIndex;
	
	ItemDetailViewController *detailVC;
}

-(void) setRewardItems: (NSArray *) items;

@end



