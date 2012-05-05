#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIBorderView.h"
#import "AsyncImageView.h"

@class BaseViewController, NavigationBarViewController;

typedef enum {
	BaseViewHeaderLabelOnlyStyle,
	BaseViewHeaderImageAndSubtitleStyle,
	BaseViewHeaderImageOnlyStyle,
	BaseViewHeaderImageAndSubtitleOnlyStyle
} BaseViewHeaderStyle;

typedef struct {
	NSString *imageURL;
	NSString *title;
	NSString *subTitle;
} BaseViewHeaderInfo;

@protocol BaseViewDelegate <NSObject>

@optional
-(void) baseViewWillChangeToView: (BaseViewController *) viewController;
-(void) baseViewDidChangeToView:(BaseViewController *)viewController;

-(void) baseViewWillStartLoading: (BaseViewController *) viewController;
-(void) baseViewDidStartLoading: (BaseViewController *) viewController;
-(void) baseViewWillEndLoading: (BaseViewController *) viewController;
-(void) baseViewDidEndLoading: (BaseViewController *) viewController;

@end

@interface BaseViewController : UIViewController<BaseViewDelegate>
{
    @private
	BaseViewController *vc;
	UIView *headerView;
}

@property (nonatomic, assign) BaseViewHeaderStyle headerStyle;
@property (nonatomic, assign) BaseViewHeaderInfo headerInfo;
@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic, retain) id<BaseViewDelegate> delegate;

-(UIView *) navigationHeaderView;
-(void) pushViewController: (BaseViewController *) viewController;
-(void) layoutSubview;
-(void) loadViewContent;

@end
