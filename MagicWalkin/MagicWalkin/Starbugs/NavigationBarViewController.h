#import <UIKit/UIKit.h>
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "NavBarButton.h"
#import "BaseViewController.h"


#define NavButtonNumber 2
#define animationDuration 0.4


@class NavigationBarViewController;

@protocol  NavigationBarDelegate <NSObject>

@optional
-(void) navigationBar: (NavigationBarViewController *) bar buttonWillChange: (int) index;
-(void) navigationBar: (NavigationBarViewController *) bar buttonNowChange: (int) index;
-(void) navigationBar: (NavigationBarViewController *) bar buttonDidChange: (int) index;

@end

@interface NavigationBarViewController : UIViewController<BaseViewDelegate>
{
	NavBarButton *tmpAnimatBut[2];
	NavBarButton *activeNavButton;
	
	
	unsigned char viewId[NavButtonNumber];
    UIImage *navImage[NavButtonNumber];
    
	UIImage *imgBack;
	NavBarButton *animatingButton;
	
    BOOL _isLoading;
    BOOL isChangingView;
    BOOL isPushingView;
    
    BaseViewController* activeViewController;
    NSString *currentAnimationId;
    
	UIView *currentHeaderView;
	
    NavBarButton *navButton[NavButtonNumber];
}


@property (nonatomic, retain) id<NavigationBarDelegate> delegate;

-(void) setActiveViewController: (BaseViewController *) viewController;

@end
