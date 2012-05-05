//
//  Localization.m
//  TaxiClient
//
//  Created by Henry Fok on 16/8/11.
//  Copyright 2011 Legato Tehnologies Ltd. All rights reserved.
//

#import "Localization.h"

@implementation Localization

@synthesize aryLocalization;
@synthesize intDefaultLanguage;

#pragma mark - External Methods
- (NSString*)getLangPhrase:(NSInteger)intPhraseNum language:(NSInteger)intLang {
    if (intPhraseNum < [self.aryLocalization count] && intLang < MAX_NUM_LANG)
        return [[self.aryLocalization objectAtIndex:intPhraseNum] objectAtIndex:intLang];
    else
        return @"";
}

- (NSString*)getDefaultLangPhrase:(NSInteger)intPhraseNum {
    if (intPhraseNum < [self.aryLocalization count])
        return [[self.aryLocalization objectAtIndex:intPhraseNum] objectAtIndex:self.intDefaultLanguage];
    else
        return @"";    
}

- (void)setDefaultLang:(NSInteger)intDefaultLang {
    if (intDefaultLang < MAX_NUM_LANG)
        self.intDefaultLanguage = intDefaultLang;
}

#pragma mark - Initialization
- (id)init
{
    NSArray     *aryTemp;
    
    self = [super init];
    if (self) {
        // Init array
        NSString *stringPath    = [[NSBundle mainBundle] pathForResource:@"Localization" ofType:@"plist"];
        //NSLog(@"%@", stringPath);
        aryTemp                 = [[NSArray alloc] initWithContentsOfFile:stringPath];
        self.aryLocalization	= aryTemp;
        [aryTemp release];
        //[self.aryLocalization release];
        //NSLog(@"%d", [self.aryLocalization count]);
        
        // Set default language
        self.intDefaultLanguage = LANG_ENG;
    }
    
    return self;
}

#pragma mark - Memory
- (void)dealloc
{
    NSLog(@"[Localication]{dealloc}");
    [aryLocalization release];
    [super dealloc];
}

@end
