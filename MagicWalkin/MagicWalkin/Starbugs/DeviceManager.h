
#include <ifaddrs.h>
#include <arpa/inet.h>

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject

-(NSString *)getIPAddress;

@end
