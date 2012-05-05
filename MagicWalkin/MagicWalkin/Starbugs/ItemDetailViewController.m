#import "ItemDetailViewController.h"

@implementation ItemDetailViewController

-(id) initWithItems: (NSArray *) items AndDisplayingItemIndex: (int) index {
	self = [super init];
	if(self)
	{
		_items = [items retain];
		currentDisplayItemIndex = index;
		self.iconImage = [UIImage imageNamed:@"icon_back.png"];
		self.title = @"DEALS & FINDS";
		isAnimating = NO;
	}
	
	return self;
}


-(void) loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.clipsToBounds = YES;
	
	header = [[UIView alloc] initWithFrame:CGRectZero];
	header.backgroundColor = PurpleColor;
	[self.view addSubview:header];
	
	
	ivToolbar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_toolbar.png"]];
	ivToolbar.contentMode = UIViewContentModeScaleAspectFill;
	[self.view addSubview:ivToolbar];
	
	butPrevious = [[UIButton alloc] initWithFrame:CGRectZero];
	[butPrevious addTarget:self action:@selector(PreviousItemDidTouched) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:butPrevious];
	
	
	butNext = [[UIButton alloc] initWithFrame:CGRectZero];
	[butNext addTarget:self action:@selector(NextItemDidTouched) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:butNext];

	butAddToFav = [[UIButton alloc] initWithFrame:CGRectZero];
	[butAddToFav addTarget:self action:@selector(addToFavDidTouched) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:butAddToFav];

	butShare = [[UIButton alloc] initWithFrame:CGRectZero];
	[butShare addTarget:self action:@selector(shareDidTouch) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:butShare];

	
	
	lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, HeaderHeight)];
	lblTitle.backgroundColor = [UIColor clearColor];
	lblTitle.textColor = [UIColor whiteColor];
	[header addSubview:lblTitle];
	[lblTitle release];
	
	mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
	mainScrollView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:mainScrollView];
	
	productImgScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
	productImgScrollView.backgroundColor = [UIColor clearColor];
	productImgScrollView.pagingEnabled = YES;
	productImgScrollView.delegate = self;
	[mainScrollView addSubview:productImgScrollView];
	
	productImgPageControl = [[SBPageControl alloc] initWithFrame:CGRectZero];
	productImgPageControl.backgroundColor = [UIColor clearColor];
	productImgPageControl.hidesForSinglePage = YES;
	[mainScrollView addSubview:productImgPageControl];
	
	borderView = [[UIBorderView alloc] initWithFrame:CGRectZero];
	borderView.border = BorderTop;
	borderView.backgroundColor = [UIColor clearColor];
	[mainScrollView addSubview:borderView];
	
	webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	webView.opaque = NO;
	webView.delegate = self;
	webView.userInteractionEnabled = NO;
	webView.backgroundColor = [UIColor clearColor];
	[mainScrollView addSubview:webView];
	
	[self presentDataOfItemAtIndex:currentDisplayItemIndex];
}



-(void) layoutSubview {
	header.frame = CGRectMake(0, 0, self.view.frame.size.width, HeaderHeight);
	CGRect f = header.frame;
	
	ivToolbar.frame = CGRectMake(f.origin.x,
								 f.origin.y + f.size.height + 2, 
								 self.view.frame.size.width, 
								 30);
	
	f = ivToolbar.frame;
	float width = 40;
	butPrevious.frame = CGRectMake(f.origin.x, f.origin.y, width, f.size.height);
	butNext.frame = CGRectMake(butPrevious.frame.size.width, f.origin.y, width, f.size.height);
	
	butAddToFav.frame = CGRectMake(f.size.width - 2 * width, f.origin.y, width, f.size.height);
	butShare.frame = CGRectMake(f.size.width - width, f.origin.y, width, f.size.height);
	
	mainScrollView.frame = CGRectMake(f.origin.x,
									  f.origin.y + f.size.height, 
									  self.view.frame.size.width, 
									  self.view.frame.size.height - f.origin.y - f.size.height);
	
	
	f = mainScrollView.frame;
	productImgScrollView.frame = CGRectMake(0, 10, f.size.width, 150);
	
	f = productImgScrollView.frame;
	productImgPageControl.frame = CGRectMake(f.origin.x, f.origin.y + f.size.height + 10, f.size.width, 20);
	
	
	int cnt = [productImgScrollView.subviews count];
	productImgPageControl.numberOfPages = cnt;
	
	for(int i=0; i<cnt; i++)
	{
		UIView *v = [productImgScrollView.subviews objectAtIndex:i];
		v.frame = CGRectMake(f.size.width * i, 0, f.size.width, f.size.height);
	}
	
	productImgScrollView.contentSize = CGSizeMake(productImgScrollView.frame.size.width * cnt, productImgScrollView.frame.size.height);
	
	f = productImgPageControl.frame;
	
	if(productImgPageControl.numberOfPages == 1)
		borderView.frame = CGRectMake(0, f.origin.y, f.size.width, 3);
	else
		borderView.frame = CGRectMake(0, f.origin.y + f.size.height + 10, f.size.width, 3);
	
	f = borderView.frame;
	if(CGRectEqualToRect(webView.frame, CGRectZero))
		webView.frame = CGRectMake(0, f.origin.y + f.size.height + 3, f.size.width, 50);

	
	

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
	if(sv == productImgScrollView)
	{
		int page = sv.contentOffset.x / sv.frame.size.width;
		productImgPageControl.currentPage = page;
	}
}

-(void) hideCurrentView: (SEL) callbackSelector {
}



-(void) PreviousItemDidTouched {
	
	if(isAnimating)
		return;
	
	if(currentDisplayItemIndex > 0)
	{
		isAnimating = YES;
		if(self.delegate != nil)
			if([self.delegate respondsToSelector:@selector(baseViewWillStartLoading:)])
				[self.delegate baseViewWillStartLoading:self];
		
		[UIView beginAnimations:nil context:nil];
		
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDidStopSelector:@selector(showPreviousItems_step2)];
		
		
		CGRect f = mainScrollView.frame;
		f.origin.x = f.size.width;
		mainScrollView.frame = f;
		
		f = ivToolbar.frame;
		f.origin.x = f.size.width;
		ivToolbar.frame = f;
		
		
		f = header.frame;
		f.origin.x = f.size.width;
		header.frame = f;
		
		[UIView commitAnimations];
	}
}

-(void) showPreviousItems_step2 {
	
	[self presentDataOfItemAtIndex:currentDisplayItemIndex-1];
	[mainScrollView scrollRectToVisible:CGRectMake(0, 0, 100, 100) animated:NO];
	
	if(self.delegate != nil)
		if([self.delegate respondsToSelector:@selector(baseViewDidEndLoading:)])
			[self.delegate baseViewDidEndLoading:self];
	
	CGRect f = mainScrollView.frame;
	f.origin.x = -self.view.frame.size.width;
	mainScrollView.frame = f;
	
	f = ivToolbar.frame;
	f.origin.x = -f.size.width;
	ivToolbar.frame = f;
	
	f = header.frame;
	f.origin.x = -f.size.width;
	header.frame = f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(setNoAnimationgFlag)];

	f = mainScrollView.frame;
	f.origin.x = 0;
	mainScrollView.frame = f;
	
	f = ivToolbar.frame;
	f.origin.x = 0;
	ivToolbar.frame = f;
	
	f = header.frame;
	f.origin.x = 0;
	header.frame = f;
	
	
	[UIView commitAnimations];
}

-(void) NextItemDidTouched {
	
	if(isAnimating)
		return;
	
	if(currentDisplayItemIndex < [_items count] - 1)
	{
		isAnimating = YES;
		if(self.delegate != nil)
			if([self.delegate respondsToSelector:@selector(baseViewWillStartLoading:)])
				[self.delegate baseViewWillStartLoading:self];
		
		[UIView beginAnimations:nil context:nil];
		
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDidStopSelector:@selector(showNextItems_step2)];
		
		
		CGRect f = mainScrollView.frame;
		f.origin.x = -f.size.width;
		mainScrollView.frame = f;
		
		f = ivToolbar.frame;
		f.origin.x = -f.size.width;
		ivToolbar.frame = f;
		
		
		f = header.frame;
		f.origin.x = -f.size.width;
		header.frame = f;
		
		[UIView commitAnimations];
	}
	
}

-(void) showNextItems_step2 {
	
	[mainScrollView scrollRectToVisible:CGRectMake(0, 0, 100, 100) animated:NO];
	[self presentDataOfItemAtIndex:currentDisplayItemIndex+1];
	
	if(self.delegate != nil)
		if([self.delegate respondsToSelector:@selector(baseViewDidEndLoading:)])
			[self.delegate baseViewDidEndLoading:self];
	
	CGRect f = mainScrollView.frame;
	f.origin.x = self.view.frame.size.width;
	mainScrollView.frame = f;
	
	f = ivToolbar.frame;
	f.origin.x = f.size.width;
	ivToolbar.frame = f;
	
	f = header.frame;
	f.origin.x = f.size.width;
	header.frame = f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(setNoAnimationgFlag)];
	
	f = mainScrollView.frame;
	f.origin.x = 0;
	mainScrollView.frame = f;
	
	f = ivToolbar.frame;
	f.origin.x = 0;
	ivToolbar.frame = f;
	
	f = header.frame;
	f.origin.x = 0;
	header.frame = f;
	
	[UIView commitAnimations];
}

-(void) setNoAnimationgFlag {
	isAnimating = NO;
}


-(void) addToFavDidTouched {
	NSLog(@"addToFavDidTouched");
}

-(void) shareDidTouch {
	NSLog(@"shareDidTouch");
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	
	CGRect f = wv.frame;
	f.origin.y = borderView.frame.origin.y + 5;
	float height = [[wv stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetHeight;"] floatValue];
	f.size.height = height + 20;
	wv.frame = f;
	
	mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, wv.frame.origin.y + height + 15);
}

-(void) presentDataOfItemAtIndex: (int) index {
	
	if(index < 0)
		return;
	
	currentDisplayItemIndex = index;
	Item *item = [_items objectAtIndex:index];
	lblTitle.text = item.name;

	int cnt = [productImgScrollView.subviews count];
	for(int i=0; i<cnt; i++)
	{
		UIView *v = [productImgScrollView.subviews objectAtIndex:0];
		[v removeFromSuperview];
	}
	
	CGRect f = productImgScrollView.bounds;
	cnt = [item.imageUrls count];
	
	for(int i=0; i<cnt; i++)
	{
		UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(f.size.width * i, 0, f.size.width, f.size.height)];
		img.contentMode = UIViewContentModeScaleAspectFill;
		img.clipsToBounds = YES;
		
		NSString *url = [item.imageUrls objectAtIndex:i];
		img.image = [UIImage imageNamed:url];
		[productImgScrollView addSubview:img];
		[img release];
	}
	productImgScrollView.contentSize = CGSizeMake(productImgScrollView.frame.size.width * cnt, productImgScrollView.frame.size.height);
	productImgPageControl.numberOfPages = [item.imageUrls count];
	
	NSString *html = @"<html><meta name=\"viewport\" content=\"width=300, initial-scale=1, maximum-scale=1\"><body><div style='color: rgb(100, 100, 100); font-size: 14px;' id='content'>";
	
	if(item.longDescription != nil)
		html = [html stringByAppendingString:item.longDescription];
		
	html = [html stringByAppendingString:@"</div><body></html>"];
	
	f = productImgPageControl.frame;
	
	if(productImgPageControl.numberOfPages == 1)
		borderView.frame = CGRectMake(0, f.origin.y, f.size.width, 3);
	else
		borderView.frame = CGRectMake(0, f.origin.y + f.size.height + 10, f.size.width, 3);
	
	[webView loadHTMLString:html baseURL:nil]; 
}

-(void) dealloc {
	[productImgScrollView release];
	[productImgPageControl release];
	[_items release];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
	[productImgScrollView release];
	[productImgPageControl release];
	
	
	[ivToolbar release];
	[lblTitle release];
	[header release];

	[borderView release];
	
	[webView release];
	[butPrevious release];
	[butNext release];
	
	
	[butShare release];
	[butAddToFav release];
	[mainScrollView release];

	
    [super viewDidUnload];
}


@end
