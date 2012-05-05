#import "RewardItem.h"

@implementation RewardItem
@synthesize starRequiredToRedeem, termsAndCondition;


-(void) setLongDescription:(NSString *)longDescription {
	[termsAndCondition release];
	termsAndCondition = [longDescription retain];
}

-(NSString *) longDescription {
	return termsAndCondition;
}

-(void) dealloc {
	[termsAndCondition release];
	termsAndCondition = nil;
	
	[super dealloc];
}

@end
