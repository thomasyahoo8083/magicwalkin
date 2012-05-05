#import "BaseViewController.h"

@implementation BaseViewController

@synthesize iconImage, delegate, headerStyle, headerInfo;

-(id) init {
	self = [super init];
	if(self)
	{
		headerStyle = BaseViewHeaderLabelOnlyStyle;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) layoutSubview {
	
}

-(void) dealloc {
    [headerView removeFromSuperview];
	[headerView release];
	headerView = nil;
    [super dealloc];
}

-(UIView *) navigationHeaderView {
	
	if(headerView == nil)
	{
		if(headerStyle == BaseViewHeaderImageAndSubtitleStyle) {
			headerView = [[UIView alloc] initWithFrame:CGRectZero];
			
			AsyncImageView *logo = [[AsyncImageView alloc] initWithFrame: CGRectMake(5, 0, 50, 50)];
			logo.contentMode = UIViewContentModeScaleAspectFit;
			logo.imageURL = headerInfo.imageURL;
			[headerView addSubview:logo];
			[logo loadImage];
			[logo release];
			
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 150, 25)];
			lbl.font = [UIFont boldSystemFontOfSize:21];
			lbl.textColor = PurpleColor;
			lbl.text = headerInfo.title;
			[headerView addSubview:lbl];
			[lbl release];
			
			UIBorderView *b = [[UIBorderView alloc] initWithFrame:CGRectMake(60, 25, 175, 2)];
			b.border = BorderTop;
			b.backgroundColor = [UIColor clearColor];
			b.borderColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
			[headerView addSubview:b];
			[b release];
			
			lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 150, 25)];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.text = headerInfo.subTitle;
			lbl.font = [UIFont systemFontOfSize:13];
			lbl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
			lbl.text = headerInfo.subTitle;
			[headerView addSubview:lbl];
			[lbl release];
		}
		else if(headerStyle == BaseViewHeaderImageOnlyStyle)
		{
			AsyncImageView *img = [[AsyncImageView alloc] initWithFrame:CGRectZero];
			img.contentMode = UIViewContentModeScaleAspectFit;
			img.imageURL = headerInfo.imageURL;
			[img loadImage];
			headerView = img;
		}
		else if(headerStyle == BaseViewHeaderImageAndSubtitleOnlyStyle)
		{
			headerView = [[UIView alloc] initWithFrame:CGRectZero];
			
			AsyncImageView *logo = [[AsyncImageView alloc] initWithFrame: CGRectMake(0, 0, 200, 25)];
			logo.contentMode = UIViewContentModeScaleAspectFit;
			logo.imageURL = headerInfo.imageURL;
			[headerView addSubview:logo];
			[logo loadImage];
			[logo release];
			
			UIBorderView *b = [[UIBorderView alloc] initWithFrame:CGRectMake(0, 27, 175, 2)];
			b.border = BorderTop;
			b.backgroundColor = [UIColor clearColor];
			b.borderColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
			[headerView addSubview:b];
			[b release];
			
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 150, 20)];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.text = headerInfo.subTitle;
			lbl.font = [UIFont systemFontOfSize:13];
			lbl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
			lbl.text = headerInfo.subTitle;
			[headerView addSubview:lbl];
			[lbl release];
		}
		else 
		{
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
			lbl.font = [UIFont systemFontOfSize:20];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.textColor = PurpleColor;
			lbl.text = headerInfo.title == nil ? self.title : headerInfo.title;
			
			
			
			headerView = lbl;
		}
	}
	return headerView;
}

-(void) loadViewContent {
	if(delegate != nil)
	{
		[delegate baseViewDidEndLoading:self];
	}
}

-(void) viewDidUnload {
	[headerView removeFromSuperview];
	[headerView release];
	headerView = nil;
	
	[super viewDidUnload];
}

-(void) pushViewController: (BaseViewController *) viewController {
	vc = [viewController retain];
	vc.view.frame = self.view.frame;
	[vc layoutSubview];
	
	if([self.delegate respondsToSelector:@selector(baseViewWillChangeToView:)])
        [self.delegate baseViewWillChangeToView: vc];
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDidStopSelector:@selector(StartLoadDetailContent)];
	
    CGRect f = self.view.frame;
    f.origin.x = -f.size.width;
    self.view.frame = f;
	
    [UIView commitAnimations];
	
}



-(void) StartLoadDetailContent {
	[vc setDelegate:self];
    [vc loadViewContent];
}

-(void) baseViewDidEndLoading:(BaseViewController *)viewController {
	[vc setDelegate:self.delegate];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	[self.navigationController pushViewController:vc animated:YES];
	[UIView commitAnimations];
	
    if([self.delegate respondsToSelector:@selector(baseViewDidChangeToView:)])
        [self.delegate baseViewDidChangeToView:vc];
	
    [vc release];
    vc = nil;
	
}


-(void) viewWillLayoutSubviews {
	[self layoutSubview];
}

@end
