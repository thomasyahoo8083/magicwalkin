#import "Item.h"

@implementation Item
@synthesize name, imageUrls, shortDescription, description, longDescription;

-(id) init {
	self = [super init];
	if(self)
	{
		imageUrls  = [[NSMutableArray alloc] init];
	}
	
	return self;
}


-(void) dealloc {
	[imageUrls removeAllObjects];
	[imageUrls release];
	imageUrls = nil;
	
	[super dealloc];
}

@end
