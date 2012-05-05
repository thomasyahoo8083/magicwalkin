#import "MainViewController.h"


@implementation MainViewController

-(void) menuWillOpen {
}

-(void) menuDidOpen {
	isChangingView = YES;
	topMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void) menuWillClose {
}

-(void) menuDidClose {
	isChangingView = YES;
	topMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 43);
}

-(void) loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	
	navbarViewController = [[NavigationBarViewController alloc] init];
	navbarViewController.view.frame = CGRectMake(0, 43, 320, 67);
	[self.view addSubview:navbarViewController.view];
	[navbarViewController viewWillLayoutSubviews];
	navbarViewController.delegate = self;
	
	favoriteController = [[FavoriteController alloc] init];
	favoriteController.view.frame = CGRectMake(10, 110, 300, 407);
	[self.view addSubview:favoriteController.view];
	[favoriteController layoutSubview];
    BaseViewController *b = [favoriteController.navigationController.viewControllers objectAtIndex:0];
	[navbarViewController setActiveViewController:b];
	activeViewController = favoriteController;
	
	topMenuViewController = [[TopMenuViewController alloc] init];
	topMenuViewController.view.frame = CGRectMake(0, 0, 320, 43);
	topMenuViewController.delegate = self;
	[self.view addSubview:topMenuViewController.view];
	[topMenuViewController viewWillLayoutSubviews];
	
	isChangingView = NO;
	
}

-(void) navigationBar: (NavigationBarViewController *) bar buttonWillChange: (int) index {
	isChangingView = YES;
	BaseViewController *targetView;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.4];
    
	CGRect frame = activeViewController.view.frame;
	frame.origin.x = -self.view.frame.size.width;
	activeViewController.view.frame = frame;
    
	[UIView commitAnimations];

	if(index == 2)
	{
		if(nearByController == nil)
		{
			nearByController = [[NearByController alloc] init];
			nearByController.view.frame = CGRectZero;
			[self.view addSubview:nearByController.view];
			[self.view bringSubviewToFront:topMenuViewController.view];
    	}
		
		targetView = nearByController;
	}
	else if(index == 1)
	{
		if(favoriteController == nil)
		{
			favoriteController = [[FavoriteController alloc] init];
			favoriteController.view.frame = CGRectZero;
			[self.view addSubview:favoriteController.view];
			[self.view bringSubviewToFront:topMenuViewController.view];
    	}
		targetView = favoriteController;
	}
	
	targetView.view.frame = CGRectMake(self.view.frame.size.width + 10, 110, self.view.frame.size.width - 20, self.view.frame.size.height - 110);
    [targetView layoutSubview];
    activeViewController = targetView;

	[self performSelector:@selector(loadViewContent) withObject:nil afterDelay:0.4];
	
}

-(void) loadViewContent {
	BaseViewController *b = [activeViewController.navigationController.viewControllers objectAtIndex:0];
	[navbarViewController setActiveViewController:b];
    [b loadViewContent];
    
	if(activeViewController == favoriteController)
	{
		[nearByController release];
		nearByController = nil;
	}
	else {
		[favoriteController release];
		favoriteController = nil;
	}
	
}



-(void) navigationBar: (NavigationBarViewController *) bar buttonNowChange: (int) index {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGRect frame = activeViewController.view.frame;
    frame.origin.x = 10;
    activeViewController.view.frame = frame;
     
    [UIView commitAnimations];	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

-(void) onProfileOpen {
	UIView *v = [self.view viewWithTag:999];
	
	if(v == nil)
	{
		UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
		v.backgroundColor = [UIColor colorWithRed:0	green:0 blue:0 alpha:.85];
		v.tag = 999;
		[self.view addSubview:v];
		[v release];
		
		[self.view bringSubviewToFront:topMenuViewController.view];
		v.alpha = 0;
	}
	
	
	[UIView beginAnimations:nil context:nil];
	v.alpha = 1;
	[UIView commitAnimations];

}

-(void) onProfileClose {
	UIView *v = [self.view viewWithTag:999];
	
	if(v == nil)
		return;
	
	[UIView beginAnimations:nil context:nil];
	v.alpha = 0;
	[UIView commitAnimations];
}



-(void) viewWillLayoutSubviews {
	
	if(!isChangingView)
	{
		CGRect frame = self.view.frame;
		float width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation)  ? frame.size.width : frame.size.height;
		float height = UIInterfaceOrientationIsPortrait(self.interfaceOrientation)  ? frame.size.height : frame.size.width;
		
		topMenuViewController.view.frame = CGRectMake(0, 0, width, 43);
			
		navbarViewController.view.frame = CGRectMake(0, 43, width, 67);

		width = width - 20;
		favoriteController.view.frame = CGRectMake(10, 110, width, height - 110);

		if(nearByController != nil)
			nearByController.view.frame = favoriteController.view.frame;
	}
	
	isChangingView = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	[topMenuViewController release];
	[nearByController release];
	[favoriteController release];
}


@end
