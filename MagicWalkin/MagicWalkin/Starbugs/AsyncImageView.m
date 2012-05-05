#import "AsyncImageView.h"

@implementation AsyncImageView
@synthesize imageURL=_imageURL;


-(id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self)
	{
		[self addLoadingSubview];
	}
	return self;
}

-(void) setImageURL:(NSString *)imageURL {
	
	if([imageURL isEqualToString:_imageURL])
		return;
	
	imageLoaded = NO;
	_imageURL = imageURL;
}

-(id) initWithImage:(UIImage *)image {
	self = [super initWithImage:image];
	if(self)
	{
		[self addLoadingSubview];
	}
	return self;
}


-(void) addLoadingSubview {
	loadingBgView = [[UIView alloc] initWithFrame:CGRectZero];
	loadingBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
	[self addSubview:loadingBgView];
	
	loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
	[loadingIndicatorView startAnimating];
	loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[loadingBgView addSubview:loadingIndicatorView];
	
}

-(void) setFrame:(CGRect)frame {
	[super setFrame:frame];
	loadingBgView.frame = self.bounds;
	loadingIndicatorView.frame = loadingBgView.bounds;
}

- (NSURLRequest *)request {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.imageURL]];
	return request;
}

- (void)renderImage:(UIImage *)image {
	imageLoaded =  YES;
	self.image = image;
	[UIView animateWithDuration:0.3 animations:^{
		loadingBgView.alpha = 0;
		[loadingIndicatorView stopAnimating];
	}];
	
}

-(void) loadImage {
	if(!imageLoaded)
	{
		[UIView animateWithDuration:0.3 animations:^{
			loadingBgView.alpha = 1;
			[loadingIndicatorView startAnimating];
		} completion:^(BOOL finished) {
			ImageManager *manager = [ImageManager sharedManager];
			[manager addClientToDownloadQueue:self];	
		}];
		
		
	}
}

-(void) dealloc {
	[loadingBgView removeFromSuperview];
	[loadingIndicatorView removeFromSuperview];
	[loadingBgView release];
	[loadingIndicatorView release];
	loadingBgView = nil;
	loadingIndicatorView = nil;
	[super dealloc];
}

@end
