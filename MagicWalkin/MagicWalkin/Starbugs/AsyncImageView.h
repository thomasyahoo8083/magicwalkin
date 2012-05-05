#import <UIKit/UIKit.h>
#import "ImageManager.h"

@interface AsyncImageView : UIImageView<ImageConsumer>
{
	UIView *loadingBgView;
	UIActivityIndicatorView *loadingIndicatorView;
	BOOL imageLoaded;
}

@property (nonatomic, retain) NSString *imageURL;

-(void) loadImage;


@end
