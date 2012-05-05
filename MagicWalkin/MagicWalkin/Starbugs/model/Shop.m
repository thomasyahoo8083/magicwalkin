#import "Shop.h"

@implementation Shop

@synthesize brand=_brand, longitude, latitude, noOfWalkinStar, totalStarCanEarnToday, address, dealsAndFindItems, contactNo;

-(id) initWithBrand:(Brand *)brand {
	self = [super init];
	if(self)
	{
		_brand = [brand retain];
		[self.brand addShop:self];
		dealsAndFindItems = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc {
	[dealsAndFindItems release];
	[self.brand release];
	[super dealloc];
}


@end
