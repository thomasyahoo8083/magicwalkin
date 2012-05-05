#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import "Shop.h"
#import "AsyncImageView.h"

@interface ShopAnnotation : NSObject<MKAnnotation>
{
}

@property (nonatomic, readonly) Shop *shop;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithShop: (Shop *) shop;


@end




@interface ShopAnnotationView : MKAnnotationView {
	AsyncImageView *logoView;
}

@end