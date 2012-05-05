#import <UIKit/UIKit.h>
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "MaskLayer.h"
#import "RoundBgView.h"

@interface NavBarButton : UIButton
{
	UIImageView *img;
	MaskLayer *maskLayer;
	RoundBgView *hlView;
    UIActivityIndicatorView *loadingIndicator;
	unsigned char animationCnt;
	BOOL isAnimationClockwise;
	void (^animationCallback) (BOOL);
}

@property (nonatomic, assign) bool isLoading;
@property (nonatomic, assign) bool isActive;
@property (nonatomic, retain) UIImage *iconImage;

-(void) setIsActive:(bool)isActive Animated: (BOOL) animated;
-(void) setIsLoading:(bool)isLoading Animated: (BOOL) animated;
-(void) setIsLoading:(bool)isLoading Animated: (BOOL) animated clockwise: (BOOL) clockwise completion: (void (^)(BOOL)) completion;

@end
