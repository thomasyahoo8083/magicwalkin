//
//  Localization.h
//  TaxiClient
//
//  Created by Henry Fok on 16/8/11.
//  Copyright 2011 Legato Tehnologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// Interface
@interface Localization : NSObject {
    NSArray     *aryLocalization;
    NSInteger   intDefaultLanguage;
}

@property (nonatomic, retain) NSArray       *aryLocalization;
@property (nonatomic, assign) NSInteger     intDefaultLanguage;

- (NSString*)getLangPhrase:(NSInteger)intPhraseNum language:(NSInteger)intLang;
- (NSString*)getDefaultLangPhrase:(NSInteger)intPhraseNum;
- (void)setDefaultLang:(NSInteger)intDefaultLang;

@end

// Defines
// ========================================== Language =========================================
#define MAX_NUM_LANG            2
#define LANG_ENG                0
#define LANG_CHI                1

// ========================================== English ==========================================
#define PHRASE_TESTING          0
#define PHRASE_TESTING_1        1
#define PHRASE_TESTING_2        2
#define PHRASE_TESTING_3        3

