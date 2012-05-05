#import "NavBarButton.h"

@implementation NavBarButton
@synthesize isActive=_isActive, iconImage, isLoading=_isLoading;

-(id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor clearColor];
	
	if(self)
	{
		hlView = [[RoundBgView alloc] initWithFrame:CGRectZero];
		hlView.bgColor = PurpleColor;
        hlView.backgroundColor = [UIColor clearColor];
		hlView.hidden = !self.isActive;
		[self addSubview:hlView];
		
		img = [[UIImageView alloc] initWithFrame:self.bounds];
		img.backgroundColor = [UIColor clearColor];
		img.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:img];
		
		maskLayer =[[MaskLayer alloc] init];
		[maskLayer setAnchorPoint:CGPointMake(0, 0)];
		self.layer.mask = maskLayer;
	}
	return self;
}

-(UIImage *) iconImage {
	return img.image;
}

-(void) setIconImage:(UIImage *)image {
	[img.image release];
	img.image = [image retain];
}

-(void) setIsActive:(bool)isActive {
	[self setIsActive:isActive Animated:YES];
}


-(void) setIsLoading:(bool)isLoading Animated: (BOOL) animated  {
	[self setIsLoading:isLoading Animated:animated clockwise:YES completion:nil];
}


-(void) setIsLoading:(bool)isLoading Animated: (BOOL) animated clockwise: (BOOL) isClockwise completion: (void (^)(BOOL)) completion {
    if(self.isLoading == isLoading)
	{
		return;
    }
    _isLoading = isLoading;
    
    if(loadingIndicator == nil) {
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingIndicator.frame = self.bounds;
		loadingIndicator.contentMode = UIViewContentModeCenter;
        loadingIndicator.backgroundColor =[UIColor clearColor];
        [self addSubview:loadingIndicator];
    }
    
    if(!animated)
    {
        img.hidden = isLoading;
        loadingIndicator.hidden = img.hidden;
        
        if(isLoading)
            [loadingIndicator startAnimating];
        else
            [loadingIndicator stopAnimating];
        
    }
    else {
        animationCallback = Block_copy(completion);
		animationCnt = 1;
		
		[self.layer removeAnimationForKey: @"transform.rotation.y"];

		CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
		isAnimationClockwise = isClockwise;
		if(isClockwise)
		{
			anim.fromValue = [NSNumber numberWithFloat: 0];
			anim.toValue = [NSNumber numberWithFloat:M_PI / 2];
		}
		else {
			anim.fromValue = [NSNumber numberWithFloat: 0];
			anim.toValue = [NSNumber numberWithFloat:- M_PI / 2];
		}
		
        anim.delegate = self;
        anim.duration = 0.15;
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.layer addAnimation:anim forKey:@"transform.rotation.y"];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	if(animationCnt == 1)
	{
		animationCnt = 2;
		img.hidden = self.isLoading;
		loadingIndicator.hidden = !img.hidden;
		
		if(self.isLoading)
			[loadingIndicator startAnimating];
		else
			[loadingIndicator stopAnimating];
		
		CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
		
		if(isAnimationClockwise)
		{
			anim.fromValue = [NSNumber numberWithFloat: -M_PI / 2];
			anim.toValue = [NSNumber numberWithFloat:0];
		}
		else
		{
			anim.fromValue = [NSNumber numberWithFloat: M_PI / 2];
			anim.toValue = [NSNumber numberWithFloat:0];
		}
		
		anim.duration = 0.15;
		anim.fillMode = kCAFillModeForwards;
		anim.removedOnCompletion = NO;
		anim.delegate = self;
		anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		
		[self.layer addAnimation:anim forKey:@"transform.rotation.y"];
	}
	else if(animationCnt == 2)
	{
		[self.layer removeAnimationForKey:@"transform.rotation.y"];
		animationCnt = 0;
        if(animationCallback != nil)
        {
            animationCallback(flag);
            Block_release(animationCallback);
        }
        animationCallback = nil;
	}
}

-(void) setIsActive:(bool)isActive Animated: (BOOL) animated {
	
	if(self.isActive == isActive)
		return;
	
    _isActive = isActive;
    CGRect f = self.bounds;
    if(isActive)
        f.origin.x = -self.frame.size.width;
    else 
        f.origin.x = 0;
    
    hlView.frame = f;
    hlView.hidden = NO;
    
	if(!animated)
	{
		f.origin.x += f.size.width;
		hlView.frame = f;
		hlView.hidden = !self.isActive;
	}
	else {
		[UIView beginAnimations:nil context:nil];
		f.origin.x += f.size.width;
		hlView.frame = f;
		[UIView commitAnimations];
	}
}



-(void) layoutSubviews {
	img.frame = self.bounds;
    loadingIndicator.frame = self.bounds;
	hlView.frame = self.bounds;
	maskLayer.maskWidth = self.bounds.size.width;
	maskLayer.bounds = self.bounds;
	[maskLayer setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	float width = self.frame.size.width;
	CGContextRef theContext = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(theContext,  [[UIColor colorWithRed:.67 green:.67 blue:.67 alpha:1] CGColor]);
	CGContextAddArc(theContext, width / 2, width / 2, self.frame.size.width / 2, 0, 2 * M_PI, 0);
	CGContextFillPath(theContext);
}

-(void) dealloc {
	[img release];
	[maskLayer release];
	[hlView release];
	[super dealloc];
}

@end
