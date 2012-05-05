#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *imageUrls;
@property (nonatomic, retain) NSString *shortDescription;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *longDescription;

@end
   