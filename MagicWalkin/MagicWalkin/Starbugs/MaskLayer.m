#import "MaskLayer.h"

@implementation MaskLayer
@synthesize maskWidth;




-(void) drawInContext:(CGContextRef)ctx {
	float radius = maskWidth / 2;
	CGContextSetFillColorWithColor(ctx,  [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]);
	CGContextAddArc(ctx, radius, radius, radius, 0, 2 * M_PI, 0);
	CGContextFillPath(ctx);
}


+(BOOL)needsDisplayForKey:(NSString*)key
{
    if ([key isEqualToString:@"bounds"])
        return YES;
    return [super needsDisplayForKey:key];
}

@end
