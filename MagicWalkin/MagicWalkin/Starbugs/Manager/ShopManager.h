#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Shop.h"
#import "PromotionItem.h"

@class ShopManager;

@protocol ShopManagerDelegate <NSObject>

@optional
-(void) shopManager: (ShopManager *) manager nearestShopUpdated: (NSArray *) shops;
-(void) shopManager: (ShopManager *) manager FailToUpdateLocationWithError: (NSError *) error;

@end

@interface ShopManager : NSObject<CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
}


@property (nonatomic, retain) id<ShopManagerDelegate> delegate;
-(void) getNearestShopFromCurrentLocation;

@end
