#import "UIBorderView.h"

@implementation UIBorderView

@synthesize borderColor, border, borderMargin, touchCallbackTarget, touchCallback, borderWidth;

-(id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	self.borderColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];
	self.border = 0;
	self.borderMargin = 0;
	self.borderWidth = 1;
	return self;
}

- (void)drawRect:(CGRect)rect
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
	CGContextSetLineWidth(context, borderWidth);
	CGContextSetAllowsAntialiasing(context, NO);
	
	if(self.border & BorderRight)
	{
		CGContextMoveToPoint(context, self.frame.size.width - borderWidth , borderMargin);
		CGContextAddLineToPoint(context,  self.frame.size.width - borderWidth , self.frame.size.height - borderMargin);
	}
	
	if(self.border & BorderLeft)
	{
		CGContextMoveToPoint(context, borderWidth, borderMargin);
		CGContextAddLineToPoint(context, borderWidth, self.frame.size.height - borderMargin);
	}
	
	if(self.border & BorderBottom)
	{
		CGContextMoveToPoint(context, borderMargin, self.frame.size.height - borderWidth * 0.8);
		CGContextAddLineToPoint(context, self.frame.size.width - borderMargin, self.frame.size.height - borderWidth * 0.8);
	}
	
	if(self.border & BorderTop)
	{
		CGContextMoveToPoint(context, borderMargin, borderWidth * 0.8);
		CGContextAddLineToPoint(context, self.frame.size.width - borderMargin, borderWidth * 0.8);
	}
	
	CGContextStrokePath(context);
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(self.touchCallbackTarget != nil) {
		
		UIView *v = [[UIView alloc] initWithFrame:self.bounds];
		v.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
		v.tag = 1000;
		[self addSubview:v];
		[v release];
		
	}
	else {
		[super touchesBegan:touches withEvent:event];
	}
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if(self.touchCallbackTarget != nil) {
		UITouch *touch = [[event touchesForView:self] anyObject];
		CGPoint location = [touch locationInView:touch.view];
		
		UIView *v = [self viewWithTag:1000];
		
		if((location.x >= 0 && location.x <= self.frame.size.width) && 
		   (location.y >= 0 && location.y < self.frame.size.height)) 
		{
			v.hidden = NO;
		}
		else {
			v.hidden = YES;
		}
	}
	else {
		[super touchesMoved:touches withEvent:event];
	}
	
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if(self.touchCallbackTarget != nil) {
		UIView *v = [self viewWithTag:1000];
		[v removeFromSuperview];
		
		UITouch *touch = [[event touchesForView:self] anyObject];
		CGPoint location = [touch locationInView:touch.view];
		
		if((location.x >= 0 && location.x <= self.frame.size.width) && 
		   (location.y >= 0 && location.y < self.frame.size.height)) 
		{
			if([self.touchCallbackTarget respondsToSelector:self.touchCallback])
				[self.touchCallbackTarget performSelector:self.touchCallback];

		}
	}
	else {
		[super touchesEnded:touches withEvent:event];
	}
}

@end
