#import "Brand.h"

@implementation Brand
@synthesize name, logoURL=_logoURL;

-(id) init {
	self = [super init];
	if(self)
		_shops = [[NSMutableArray alloc] init];

	return self;
}

-(void) addShop: (Shop *) shop {
	[_shops addObject:shop];
}

-(void) dealloc {
	[_shops removeAllObjects];
	[_shops release];
	[super dealloc];
}

@end
