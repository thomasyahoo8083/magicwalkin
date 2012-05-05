#import "ShopAnnotation.h"

@implementation ShopAnnotation
@synthesize shop=_shop, coordinate;


-(CLLocationCoordinate2D) coordinate {
	return CLLocationCoordinate2DMake(_shop.latitude, _shop.longitude);
}

-(id) initWithShop: (Shop *) shop {
	self = [super init];
	_shop = [shop retain];
	return self;
}

-(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	_shop.latitude = newCoordinate.latitude;
	_shop.longitude = newCoordinate.longitude;
}

-(void) dealloc {
	[_shop release];
	[super dealloc];
}

@end

@implementation ShopAnnotationView 

-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	self.image = [UIImage imageNamed:@"map_pin_01.png"];
	self.frame = CGRectMake(0, 0, 88, 88);
	
	if([annotation isKindOfClass:[ShopAnnotation class]])
	{
		ShopAnnotation *anno = (ShopAnnotation *) annotation;
		logoView = [[AsyncImageView alloc] initWithImage:nil];
		logoView.imageURL = anno.shop.brand.logoURL;
		logoView.frame = CGRectMake(10, 10, 54, 38);
		logoView.backgroundColor = [UIColor clearColor];
		logoView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:logoView];
		[logoView loadImage];
	}
	
	self.opaque = NO;
	return self;
	 
}


-(void) setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	if(animated)
	{
		NSLog(@"animated");
	}
	else {
		NSLog(@"not animated");
	}
	
}
@end
