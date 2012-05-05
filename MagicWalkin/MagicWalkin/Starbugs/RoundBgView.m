#import "RoundBgView.h"

@implementation RoundBgView
@synthesize bgColor;

-(id) initWithFrame:(CGRect)frame {
	self =[super initWithFrame:frame];
    bgColor = [UIColor whiteColor];
    
	return self;
}


- (void)drawRect:(CGRect)rect
{
	float width = self.frame.size.width;
	CGContextRef theContext = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(theContext,  [bgColor CGColor]);
	CGContextAddArc(theContext, width / 2, width / 2, self.frame.size.width / 2, 0, 2 * M_PI, 0);
	CGContextFillPath(theContext);
}


@end
