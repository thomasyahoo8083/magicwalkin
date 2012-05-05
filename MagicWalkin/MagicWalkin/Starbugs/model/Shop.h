
#import <Foundation/Foundation.h>
#import "Brand.h"

@class Brand;

@interface Shop : NSObject

@property (nonatomic, readonly) Brand *brand;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;
@property (nonatomic, retain) NSString *contactNo;
@property (nonatomic, assign) int totalStarCanEarnToday;
@property (nonatomic, assign) int noOfWalkinStar;
@property (nonatomic, retain) NSMutableArray *dealsAndFindItems;
@property (nonatomic, retain) NSString *address;


-(id) initWithBrand: (Brand *) brand;

@end
