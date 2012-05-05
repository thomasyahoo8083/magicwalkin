#import <UIKit/UIKit.h>
#import "UIBorderView.h"
#import "ProfilePanel.h"
#import "Constant.h"
#import "BaseViewController.h"
#import "RewardPanel.h"
#import "RewardItem.h"

@protocol TopMenuDelegate <NSObject>

@optional
-(void) menuWillOpen;
-(void) menuDidOpen;

-(void) menuWillClose;
-(void) menuDidClose;


@end


@interface TopMenuViewController : UIViewController
{
	BOOL isProfileOpened;
	BOOL isRewardOpened;
	
	UIBorderView *mainBorderView;
	
	UIBorderView *vProfile;
	UIImageView *ivProfile;
	UILabel *lblProfile;
	
	UIBorderView *vReward;
	UIImageView *ivReward;
	UILabel *lblReward;
	
	
	UIBorderView *vClose;
	UIImageView *ivClose;
	UILabel *lblClose;
	
	
	UIImageView *ivScorebar;
	UILabel *lblMoney[18];
	
	ProfilePanel *profilePanel;
	
	RewardPanel *vRewardPanel;
}

@property (nonatomic, retain) id<TopMenuDelegate> delegate;

-(void) openProfileMenu;
-(void) closeProfileMenu;

-(void) openRewardsMenu;
-(void) closeRewardsMenu;

@end
