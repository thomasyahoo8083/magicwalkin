#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ProfilePanel : UIView
{
	UIImageView *ivProfilePic;
	UIImageView *ivLevel;
	
	
	UILabel *lblUsername;
	UILabel *lblLevel;
	UILabel *lblNoOfCheckin;
	UILabel *lblNoOfScanned;
	UILabel *lblNoOfRedeem;
	
	UIImageView *ivCheckin;
	UIImageView *ivScan;
	UIImageView *ivRedeem;
	UIImageView *ivMore;
	
	UILabel *lblCheckin;
	UILabel *lblScan;
	UILabel *lblRedeem;
	UILabel *lblMore;
	
	
	UIImage *imageArrow;
	
}

@end
