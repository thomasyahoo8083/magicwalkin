#import "ShopManager.h"

@implementation ShopManager
@synthesize delegate;

-(void) getNearestShopFromCurrentLocation {

	if(locationManager == nil)
	{
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
	}
	
	[locationManager startUpdatingLocation];
}
                        

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(self.delegate != nil)
	{
        [delegate shopManager:self FailToUpdateLocationWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
	[locationManager stopUpdatingLocation];
	
	if(self.delegate != nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		
		for(int i=0; i<10; i++)
		{
			Brand *brand = [[Brand alloc] init];
			
			if(i % 2 == 0)
			{
				brand.name = @"Circle K";
				brand.logoURL = @"http://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Circle_K_logo.svg/325px-Circle_K_logo.svg.png";
			}
			else
			{
				brand.name = @"ZARA";
				brand.logoURL = @"http://kalejdoskop.wroclaw.pl/wp-content/uploads/2011/12/zara-logo.jpg";
			}
			
			Shop *shop = [[Shop alloc] initWithBrand:brand];
			shop.noOfWalkinStar = i % 2 == 0 ? 60 : 70;
			shop.totalStarCanEarnToday = i % 2 == 0 ? 100 : 90;
			
			if(i % 2 == 0)
			{
				shop.address = @"Basement L & D House, 2-4A Cameron Road, TST, Hong Kong";
				shop.contactNo = @"12345678";
			
			}
			else 
			{
				shop.address = @"Room 1000-1002, 1/F, TST Building, 2 Road, Mong Kok, Hong Kong, Room 1000-1002";
				
			}
			
			for(int j=0; j<i+1; j++)
			{
				PromotionItem *item = [[PromotionItem alloc] initWithBrand:brand];
				if(j % 2 == 0)
				{
					item.name = @"Ice Cream";
					item.shortDescription = @"$5 Discount";
					item.description = @"You will get $5 Discount when buying 10 of it.";
					
					
				}
				else {
					item.name = @"M&M";
					item.shortDescription = @"Buy 1 get 1 free";
					item.description = @"You will get another one for free!";
				}
				
				item.termsAndCondition = @"";
				
				for(int k=0; k<=j; k++)
				{
					[item.imageUrls addObject:@"pic_rewards_nike.jpg"];
					item.termsAndCondition = [item.termsAndCondition stringByAppendingFormat:@"%d, Terms and Condition<br/>", k+1];
				}
				
				
				[shop.dealsAndFindItems addObject:item];
				[item release];
			}
			
			
			switch (i) {
				case 0:
					shop.latitude = 22.3005;
					shop.longitude = 114.1742;
					break;
					
				case 1:
					shop.latitude = 22.3009;
					shop.longitude = 114.1744;
					break;
					
				case 2:
					shop.latitude = 22.3006;
					shop.longitude = 114.1724;
					break;
					
				case 3:
					shop.latitude = 22.2990;
					shop.longitude = 114.1737;
					break;
					
				case 4:
					shop.latitude = 22.2986;
					shop.longitude = 114.1757;
					break;
					
				case 5:
					shop.latitude = 22.2972;
					shop.longitude = 114.1724;
					break;
				default:
					shop.latitude = 22.3005;
					shop.longitude = 114.1742;
					break;
			}
			
			
			[array addObject:shop];
			[brand release];
			[shop release];
		}
		[delegate shopManager:self nearestShopUpdated:array];
		[array release];
	}
}

		
-(void) dealloc {
	[locationManager release];
	[super dealloc];
}
						   
						   

@end
