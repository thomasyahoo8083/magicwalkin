//
//  UserInfo.h
//  TaxiClient
//
//  Created by Thomas Chan on 22/8/11.
//  Copyright 2011 Legato Tehnologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_USERID              @"userid"
#define KEY_PHONE               @"phone"
#define KEY_PASSWORD            @"password"
#define KEY_USERNAME            @"name"
#define KEY_MOBILE              @"mobile"
#define KEY_ADDRESS             @"address"
#define KEY_LANGUAGE            @"language"
#define KEY_NON_SMOKING         @"Non_Smoking"
#define KEY_DRIVER_LANGUAGE     @"Driver_Language"


@interface UserInfo : NSObject {
    
    NSMutableDictionary *dict;
    
}

@property (nonatomic, retain) NSMutableDictionary *dict;

- (NSString *) getUserInfo:(NSString*) stringKey;
- (void) setUserInfo:(NSString*)Object andstringKey: (NSString*)stringKey;
- (void) datalengthvalidate:(NSString*) userInput;

@end
