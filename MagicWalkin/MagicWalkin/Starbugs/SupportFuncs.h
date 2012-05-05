

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "Constant.h"

@interface SupportFuncs: NSObject {
}

+ (UIImage*)imageNamed:(NSString*)inputPath;
+ (NSString*) charToString:(char*) c;

+ (NSString *) makeURLPath:(NSString *) name Ext:(NSString *) ext;
+ (NSString *) loadTextResource:(NSString *) name;

+ (NSString *) applicationDocumentsDirectory;
+ (void) createEditableCopyOfFileIfNeeded: (NSString *) filename;
+ (BOOL) deleteFile: (NSString *) filename;
+ (BOOL) isDatabaseVersionChanged: (NSString *) filename;

+ (NSMutableArray *) getArea: (NSString *) filename byAreaGroup: (NSString *) areaGroupID;
+ (NSMutableArray *) getDistrict:  (NSString *) filename byArea: (NSString *) areaID;

@end