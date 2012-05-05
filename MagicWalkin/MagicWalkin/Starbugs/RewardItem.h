#import <UIKit/UIKit.h>
#import "Item.h"

@interface RewardItem : Item

@property (nonatomic, assign) float starRequiredToRedeem;
@property (nonatomic, retain) NSString *termsAndCondition;

@end
