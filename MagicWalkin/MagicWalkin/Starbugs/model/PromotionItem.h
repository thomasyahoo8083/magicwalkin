#import <Foundation/Foundation.h>
#import "Item.h"
#import "Brand.h"
#import "Shop.h"

@class Brand, Shop;

@interface PromotionItem : Item
{
	
}

@property (nonatomic, readonly) Brand *brand;
@property (nonatomic, retain) NSString *termsAndCondition;
@property (nonatomic, retain) NSMutableArray *shopsCanUse;

-(id) initWithBrand: (Brand *) brand;

@end
