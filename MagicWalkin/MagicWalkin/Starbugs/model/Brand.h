
#import <Foundation/Foundation.h>
#import "Shop.h"

@class Shop;

@interface Brand : NSObject
{
@private
	NSMutableArray *_shops;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *logoURL;

-(void) addShop: (Shop *) shop;

@end
