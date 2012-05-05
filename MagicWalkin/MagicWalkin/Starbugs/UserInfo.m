//
//  UserInfo.m
//  TaxiClient
//
//  Created by Thomas Chan on 22/8/11.
//  Copyright 2011 Legato Tehnologies Ltd. All rights reserved.
//

#import "UserInfo.h"
#import "SupportFuncs.h"

@implementation UserInfo

@synthesize dict;

#pragma mark - Initialization Methods
- (id)init
{
    NSString        *documentDirectory  = [SupportFuncs applicationDocumentsDirectory];
    
    self = [super init];
    if (self) {
        // Initialization code here.
        [SupportFuncs createEditableCopyOfFileIfNeeded:@"userinfo.plist"];
        NSString        *writableFilePath   = [documentDirectory stringByAppendingPathComponent:@"userinfo.plist"];        
        dict   = [[NSMutableDictionary alloc] initWithContentsOfFile:writableFilePath];
        
    }
    
    return self;
}

#pragma mark - External Methods
- (NSString *)getUserInfo:(NSString*)stringKey {
    NSLog(@"[UserInfo]{get%@} - [%@]", [dict objectForKey:stringKey], [dict objectForKey:stringKey]);
    return [dict objectForKey:stringKey];    
}

- (void)setUserInfo:(NSString*)Object andstringKey: (NSString*)stringKey {
    
    NSString        *documentDirectory  = [SupportFuncs applicationDocumentsDirectory];
    NSString        *writableFilePath   = [documentDirectory stringByAppendingPathComponent:@"userinfo.plist"];       
    [dict setObject:Object forKey:stringKey];
    NSLog(@"[UserInfo]{set%@} - [%@]", [dict objectForKey:stringKey], [dict objectForKey:stringKey]);  
    
    [dict writeToFile:writableFilePath atomically: YES];
}

- (void) datalengthvalidate:(NSString*) userInput {
    
    /*NSLog(@"[UserInfo]{datalengthvalidate} - [%@]", userInput);
    int userInputLen = [userInput length];
    NSString *result;
    
    if (userInputLen < MIN_NUM_txtphoneNum) {
        result = @"The max length of phone Number is : 8!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:result delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }*/
}

#pragma mark - Memory Methods
- (void)dealloc
{
    NSLog(@"[UserInfo]{dealloc}");
    [dict release];
    [super dealloc];
}

@end
