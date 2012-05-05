#import "NavigationBarViewController.h"


@implementation NavigationBarViewController

@synthesize delegate;

-(void) loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	navImage[0] = [[UIImage imageNamed:@"icon_fav.png"] retain];
    navImage[1] = [[UIImage imageNamed:@"icon_nearby.png"] retain];
	
	for(int i=0; i<NavButtonNumber; i++)
	{
		navButton[i] = [[NavBarButton alloc] initWithFrame:CGRectZero];
		[navButton[i] setIsActive:i == 0 Animated:NO];
		viewId[i] = i+1;
		navButton[i].iconImage = navImage[i];
		navButton[i].autoresizesSubviews = YES;
		navButton[i].tag = i+1;
        
        if(i == 0)
            [navButton[i] addTarget:self action:@selector(backButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        else
            [navButton[i] addTarget:self action:@selector(changeNavigation:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:navButton[i]];
	}
	
	activeNavButton = navButton[0];
	
	
	for(int i=0; i<2; i++)
	{
		tmpAnimatBut[i] = [[NavBarButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		tmpAnimatBut[i].autoresizesSubviews = YES;
		tmpAnimatBut[i].hidden = YES;
		[self.view addSubview:tmpAnimatBut[i]];
	}
	
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    [b addTarget:self action:@selector(backButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    [b release];
    
    isChangingView = NO;
    _isLoading = NO;
}


-(void) backButtonDidTouch: (UIButton *) button {
    
    if(isPushingView || isChangingView)
        return;
    
	UINavigationController *v = activeViewController.navigationController;
	
	if([v.viewControllers count] > 1)
	{
        isPushingView = YES;
        
		BaseViewController *bvc = [v.viewControllers objectAtIndex:[v.viewControllers count] - 2];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		
		CGRect t = activeViewController.view.frame;
		t.origin.x = t.size.width;
		activeViewController.view.frame = t;		
		[UIView commitAnimations];
		
		[CATransaction begin];
		[self ZoomOutView: currentHeaderView clockwise: NO];
		
		[navButton[0] setIsLoading:YES Animated:YES clockwise:YES completion:^(BOOL completed) {
			
			navButton[0].iconImage = bvc.iconImage;
			
			if([activeViewController.navigationController.viewControllers count] <= 2)
			{
				[UIView animateWithDuration:0.4 animations:^{
					CGRect f = navButton[1].frame;
					f.origin.x = self.view.frame.size.width - 60;
					navButton[1].frame = f;
				}];
			}
			
            [self setActiveViewController:bvc];
			[activeViewController.navigationController popViewControllerAnimated:YES];
			
			[CATransaction begin];
			[navButton[0] setIsLoading:NO Animated:YES];
			[self ZoomInView:currentHeaderView clockwise: NO];
			[CATransaction commit];
			
			[self performSelector:@selector(setPushViewFlagToNo) withObject:nil afterDelay:0.3];
            
		}];	
		[CATransaction commit];
	}
}

-(void) viewWillLayoutSubviews {
   
    if(!isChangingView && !isPushingView)
    {
        float width = self.view.frame.size.width;
        navButton[0].frame = CGRectMake(10, 5, 50, 50);
        
        for(int i=1; i<NavButtonNumber; i++)
            navButton[i].frame = CGRectMake(width - ((NavButtonNumber - i) * 60), 5, 50, 50);
    }
}

-(void) rotationButton: (NavBarButton*) button1 With: (NavBarButton *) button2 {
	CALayer *layer = button1.layer;
	
	CGPoint from = button1.center;
	CGPoint to = CGPointMake(button2.center.x, from.y);
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	[animation setFromValue:[NSValue valueWithCGPoint:from]];
	animation.toValue = [NSValue valueWithCGPoint:to];
	
	CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	animation2.fromValue = [NSNumber numberWithFloat:0];
	animation2.toValue = [NSNumber numberWithFloat:M_PI];
	
	CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:1.0], nil];
	NSArray *values = [NSArray arrayWithObjects: [NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.7], [NSNumber numberWithFloat:1.0], nil];
	[animation3 setKeyTimes:times];
	[animation3 setValues:values];
	
	CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[animation4 setFromValue:[NSNumber numberWithFloat:1]];
	animation4.toValue = [NSNumber numberWithFloat:0.5];
	
	CAAnimationGroup *grp = [CAAnimationGroup animation];
	grp.animations = [NSArray arrayWithObjects:animation, animation2, animation3, nil];
	[grp setFillMode:kCAFillModeForwards];
	[grp setRemovedOnCompletion:NO];
    [grp setDuration:animationDuration];
	[grp setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	[layer addAnimation:grp forKey:nil];
	
	from = button2.center;
	to = CGPointMake(button1.center.x, from.y);
	animation = [CABasicAnimation animationWithKeyPath:@"position"];
	[animation setFromValue:[NSValue valueWithCGPoint:from]];
	animation.toValue = [NSValue valueWithCGPoint:to];
	
	animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	animation2.fromValue = [NSNumber numberWithFloat:0];
	animation2.toValue = [NSNumber numberWithFloat:M_PI];
	
	animation3 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	values = [NSArray arrayWithObjects: [NSNumber numberWithFloat:1], [NSNumber numberWithFloat:1.3], [NSNumber numberWithFloat:1], nil];
	[animation3 setKeyTimes:times];
	[animation3 setValues:values];
	
	grp = [CAAnimationGroup animation];
	grp.animations = [NSArray arrayWithObjects:animation, animation2, animation3, nil];
	grp.delegate = self;
    [grp setDuration:animationDuration];
	[grp setRemovedOnCompletion:NO];
	[grp setFillMode:kCAFillModeForwards];
	[grp setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	[button2.layer addAnimation:grp forKey:nil];
}


-(void) ZoomOutView: (UIView *) view clockwise: (BOOL) clockwise {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.toValue = [NSNumber numberWithFloat:0];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	
	if(clockwise)
	{
		animation2.fromValue = [NSNumber numberWithFloat: 0];
		animation2.toValue = [NSNumber numberWithFloat: - M_PI / 2];
    	animation3.fromValue = [NSNumber numberWithFloat: 1];
		animation3.toValue = [NSNumber numberWithFloat:0.3];
    }
	else {
		animation2.fromValue = [NSNumber numberWithFloat: 0];
		animation2.toValue = [NSNumber numberWithFloat:  M_PI / 2];
    	animation3.fromValue = [NSNumber numberWithFloat: 1];
		animation3.toValue = [NSNumber numberWithFloat:1.8];
	}
    CAAnimationGroup *grp = [CAAnimationGroup animation];
    grp.animations = [NSArray arrayWithObjects:animation, animation2, animation3, nil];
    [grp setFillMode:kCAFillModeForwards];
    [grp setRemovedOnCompletion:NO];
    [grp setDuration:0.3];
	[grp setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:grp forKey:nil];
}

-(void) ZoomInView: (UIView *) view clockwise:(BOOL) clockwise {
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = [NSNumber numberWithFloat:0];
	animation.toValue = [NSNumber numberWithFloat:1];
	
	CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	
	if(clockwise)
	{
		animation2.fromValue = [NSNumber numberWithFloat: M_PI / 2];
		animation2.toValue = [NSNumber numberWithFloat:0];
		animation3.fromValue = [NSNumber numberWithFloat: 1.8];
		animation3.toValue = [NSNumber numberWithFloat:1];
	}
	else {
		animation2.fromValue = [NSNumber numberWithFloat: -M_PI / 2];
		animation2.toValue = [NSNumber numberWithFloat:0];
		animation3.fromValue = [NSNumber numberWithFloat: 0.3];
		animation3.toValue = [NSNumber numberWithFloat:1];
	}
	
	CAAnimationGroup *grp = [CAAnimationGroup animation];
	grp.animations = [NSArray arrayWithObjects:animation, animation2, animation3, nil];
	[grp setDuration:animationDuration];
	[grp setFillMode:kCAFillModeForwards];
	[grp setRemovedOnCompletion:NO];
	grp.delegate = self;
	[grp setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[view.layer addAnimation:grp forKey:nil];
}

-(void) changeNavigation: (NavBarButton *) button {
    
    if(_isLoading)
        return;

    char tmp = viewId[0];
	viewId[0] = viewId[button.tag - 1];
	viewId[button.tag - 1] = tmp;
    
    isChangingView = YES;
    _isLoading = YES;
    animatingButton = button;
    
	[CATransaction begin];
	
    [self ZoomOutView:currentHeaderView clockwise:YES];
    
    [tmpAnimatBut[0].layer removeAllAnimations];
    [tmpAnimatBut[1].layer removeAllAnimations];
    tmpAnimatBut[0].frame = navButton[0].frame;
    tmpAnimatBut[1].frame = animatingButton.frame;
    tmpAnimatBut[0].iconImage = navButton[0].iconImage;
    tmpAnimatBut[1].iconImage = animatingButton.iconImage;
    [tmpAnimatBut[0] setIsActive:YES Animated:NO];
    [tmpAnimatBut[1] setIsActive:NO Animated:NO];
        
    UIImage *img = navButton[0].iconImage;
    navButton[0].iconImage = animatingButton.iconImage;
    animatingButton.iconImage = img;
    
    navButton[0].hidden = YES;
    animatingButton.hidden = YES;
    tmpAnimatBut[0].hidden = NO;
    tmpAnimatBut[1].hidden = NO;
    
    [tmpAnimatBut[0] setIsActive:NO Animated:YES];
    [tmpAnimatBut[1] setIsLoading:YES Animated:YES clockwise:YES completion:nil];
   
    
	[CATransaction commit];
    
    SEL sel = @selector(navigationBar:buttonWillChange:);
    
    if(delegate != nil)
        if([delegate respondsToSelector:sel])
            [delegate navigationBar:self buttonWillChange:(int)viewId[0]];
}

-(void) rotateButton: (NavBarButton *) button {
	currentAnimationId = @"rotationButton";
	[CATransaction  begin];
	[self rotationButton:tmpAnimatBut[0] With:tmpAnimatBut[1]];
	[CATransaction commit];
	
	SEL sel = @selector(navigationBar:buttonNowChange:);
	if(delegate != nil)
		if([delegate respondsToSelector:sel])
			[delegate navigationBar:self buttonNowChange:(int)viewId[0]];
	
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	if([currentAnimationId isEqualToString:@"rotationButton"]) 
    {
        
        navButton[0].hidden = NO;
        animatingButton.hidden = NO;
        animatingButton = nil;
		
        tmpAnimatBut[0].hidden = YES;
        tmpAnimatBut[1].hidden = YES;
        [tmpAnimatBut[0].layer removeAllAnimations];
        [tmpAnimatBut[1].layer removeAllAnimations];

        [self ZoomInView:currentHeaderView clockwise:YES];
        
		currentAnimationId = @"showLabel";
        
    }
	else if([currentAnimationId isEqualToString:@"showLabel"])
	{
        [currentHeaderView.layer removeAllAnimations];
		currentHeaderView.layer.opacity = 1;
        
		SEL sel = @selector(navigationBar: buttonDidChange:);
        if(delegate != nil)
            if([delegate respondsToSelector:sel])
                [delegate navigationBar:self buttonDidChange:(int)viewId[0]];
	}
}

-(void) setActiveViewController: (BaseViewController *) viewController {
    [activeViewController release];
    
    activeViewController = [viewController retain];
    activeViewController.delegate = self;

    if (currentHeaderView != nil) {
        [currentHeaderView removeFromSuperview];
        currentHeaderView = nil;
    }
    
    currentHeaderView = viewController.navigationHeaderView;
    [currentHeaderView.layer setAnchorPoint:CGPointMake(0, 0)];
    currentHeaderView.backgroundColor = [UIColor clearColor];
    currentHeaderView.frame = CGRectMake(70, 5, 170, 50);
	currentHeaderView.clipsToBounds = YES;
    
    if (isChangingView || isPushingView) {
        currentHeaderView.layer.opacity = 0;
    }
    
    if(isPushingView)
        currentHeaderView.frame = CGRectMake(70, 5, 230, 50);
    
    [self.view addSubview:currentHeaderView];
}

-(void) baseViewWillChangeToView:(BaseViewController *)viewController {
	
    isPushingView = YES;
	[CATransaction begin];
	
    [self ZoomOutView:currentHeaderView clockwise: YES];
	[UIView animateWithDuration:0.35 animations:^{
		
		CGRect f = navButton[1].frame;
		f.origin.x = self.view.frame.size.width + 60;
		navButton[1].frame = f;
	}];
	
	[navButton[0] setIsLoading:YES Animated:YES clockwise:YES completion:nil];
	[CATransaction commit];
}

-(void) baseViewDidChangeToView:(BaseViewController *)viewController {
	[self setActiveViewController:viewController];
    navButton[0].iconImage = viewController.iconImage;
	
    [CATransaction begin];
	[navButton[0] setIsLoading:NO Animated:YES];
	[self ZoomInView: currentHeaderView clockwise:YES];
	[CATransaction commit];
    
	[self performSelector:@selector(setPushViewFlagToNo) withObject:nil afterDelay:0.4];
    
}

-(void) setPushViewFlagToNo {
    isPushingView = NO;
}

-(void) baseViewWillStartLoading: (BaseViewController *) viewController {
    _isLoading = YES;
    if(!isChangingView)
    {
        [navButton[0] setIsLoading:YES Animated:YES];
		[self ZoomOutView: currentHeaderView clockwise: YES];
        //perform loading animation for active button
    }
}

-(void) baseViewDidEndLoading: (BaseViewController *) viewController {
    _isLoading = NO;
    
    if(isChangingView)
    {
        [tmpAnimatBut[1] setIsLoading:NO Animated:NO]; 
        
        NSTimeInterval animationDur = 0.4;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDur];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animateViewChange)];
		 
        [tmpAnimatBut[0] setIsActive:NO Animated:YES];
        [tmpAnimatBut[1] setIsActive:YES Animated:YES];
        [UIView commitAnimations];
        isChangingView = NO;
    }
    else {
        [navButton[0] setIsLoading:NO Animated:YES];
		[self ZoomInView: currentHeaderView clockwise: YES];
    }
}

-(void) animateViewChange {
    [self performSelector:@selector(rotateButton:) withObject:animatingButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isLoading = NO;
}


- (void)viewDidUnload
{	
	for(int i=0; i<NavButtonNumber; i++)
	{
		[navButton[i] release];
		navButton[i] = nil;
        
        [navImage[i] release];
        navImage[i] = nil;
	}
	
    [activeViewController release];
	[tmpAnimatBut[0] release];
	[tmpAnimatBut[1] release];
	
	[imgBack release];
    [super viewDidUnload];
}


@end
