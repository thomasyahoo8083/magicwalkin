#import "SBPageControl.h"

@implementation SBPageControl

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
	if(self){
		activeImage = [[UIImage imageNamed:@"pageControlActive.png"] retain];
		inactiveImage = [[UIImage imageNamed:@"pageControlInactive.png"] retain];
	}
    return self;
}

-(void) updateDots
{
	int cnt = [self.subviews count];
    for (int i = 0; i < cnt; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        dot.image = i == self.currentPage ? activeImage : inactiveImage;
    }
}

-(void) setNumberOfPages:(NSInteger)numberOfPages {
	[super setNumberOfPages:numberOfPages];
	[self updateDots];
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)dealloc
{
	[activeImage release];
	[inactiveImage release];
    [super dealloc];
}

@end
