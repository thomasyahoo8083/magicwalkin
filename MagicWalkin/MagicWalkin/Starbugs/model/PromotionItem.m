#import "PromotionItem.h"

@implementation PromotionItem

@synthesize brand=_brand, shopsCanUse, termsAndCondition;


-(void) setLongDescription:(NSString *)longDescription {
	[termsAndCondition release];
	termsAndCondition = [longDescription retain];
}

-(NSString *) longDescription {
	return termsAndCondition;
}

-(id) initWithBrand: (Brand *) brand {
	self = [super init];
	
	if(self)
	{
		_brand = [brand retain];
		shopsCanUse = [[NSMutableArray alloc] init];
	}
	return self;
}



-(void) dealloc {
	[termsAndCondition release];
	termsAndCondition = nil;
	
	[shopsCanUse removeAllObjects];
	[shopsCanUse release];
	
	[_brand release];
	[super dealloc];
}

@end
