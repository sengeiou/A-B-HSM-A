//
//  SmaLocalizeableInfo.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SmaLocalizeableInfo.h"

@implementation SmaLocalizeableInfo
#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])

+ (NSString *)localizedString:(NSString *)translation_key {
    NSString *s = NSLocalizedString(translation_key, nil);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    
#if SMA
    if (![preferredLang isEqualToString:@"zh"] && ![preferredLang isEqualToString:@"es"] && ![preferredLang isEqualToString:@"it"] && ![preferredLang isEqualToString:@"ko"] && ![preferredLang isEqualToString:@"ru"] && ![preferredLang isEqualToString:@"id"]&& ![preferredLang isEqualToString:@"fr"]&& ![preferredLang isEqualToString:@"de"]&& ![preferredLang isEqualToString:@"nl"]&& ![preferredLang isEqualToString:@"fi"]&& ![preferredLang isEqualToString:@"sv"]&& ![preferredLang isEqualToString:@"da"]&& ![preferredLang isEqualToString:@"nb"]&& ![preferredLang isEqualToString:@"tr"]/*&& ![preferredLang isEqualToString:@"uk"]&& ![preferredLang isEqualToString:@"pt"]&& ![preferredLang isEqualToString:@"hu"]&& ![preferredLang isEqualToString:@"ro"]&& ![preferredLang isEqualToString:@"pl"]*/) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
#elif ZENFIT
    if (![preferredLang isEqualToString:@"en"]) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"es" ofType:@"lproj"];
        
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
#elif EVOLVEO
    if (![preferredLang isEqualToString:@"zh"] && ![preferredLang isEqualToString:@"es"] && ![preferredLang isEqualToString:@"de"] && ![preferredLang isEqualToString:@"nl"] && ![preferredLang isEqualToString:@"fr"] && ![preferredLang isEqualToString:@"tr"] && ![preferredLang isEqualToString:@"cs"] /*&& ![preferredLang isEqualToString:@"ru"] && ![preferredLang isEqualToString:@"id"]&& ![preferredLang isEqualToString:@"fi"]&& ![preferredLang isEqualToString:@"sv"]&& ![preferredLang isEqualToString:@"da"]&& ![preferredLang isEqualToString:@"uk"]&& ![preferredLang isEqualToString:@"pt"]&& ![preferredLang isEqualToString:@"hu"]&& ![preferredLang isEqualToString:@"ro"]&& ![preferredLang isEqualToString:@"pl"]*/) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
       s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
#endif
    return s;
}

+ (NSString *)localizedStringDic:(NSString *)translation_key comment:(NSString *)comment{
    //    NSString *s = NSLocalizedString(translation_key, nil);
    //    NSString *s = NSLocalizedStringWithDefaultValue(translation_key, nil, nil, comment, nil);
    NSString *s = [NSString localizedStringWithFormat:NSLocalizedString(translation_key, nil),comment];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
#if SMA
    if (![preferredLang isEqualToString:@"zh"] && ![preferredLang isEqualToString:@"es"] && ![preferredLang isEqualToString:@"it"] && ![preferredLang isEqualToString:@"ko"] && ![preferredLang isEqualToString:@"ru"] && ![preferredLang isEqualToString:@"id"]&& ![preferredLang isEqualToString:@"fr"]&& ![preferredLang isEqualToString:@"de"]&& ![preferredLang isEqualToString:@"nl"]&& ![preferredLang isEqualToString:@"fi"]&& ![preferredLang isEqualToString:@"sv"]&& ![preferredLang isEqualToString:@"da"]&& ![preferredLang isEqualToString:@"nb"]&& ![preferredLang isEqualToString:@"tr"]/*&& ![preferredLang isEqualToString:@"uk"]&& ![preferredLang isEqualToString:@"pt"]&& ![preferredLang isEqualToString:@"hu"]&& ![preferredLang isEqualToString:@"ro"]&& ![preferredLang isEqualToString:@"pl"]*/) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [NSString localizedStringWithFormat:[languageBundle localizedStringForKey:translation_key value:@"" table:nil],comment];
    }
#elif ZENFIT
    if (![preferredLang isEqualToString:@"en"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [NSString localizedStringWithFormat:[languageBundle localizedStringForKey:translation_key value:@"" table:nil],comment];
    }
#elif EVOLVEO
     if (![preferredLang isEqualToString:@"zh"] && ![preferredLang isEqualToString:@"es"] && ![preferredLang isEqualToString:@"de"] && ![preferredLang isEqualToString:@"nl"] && ![preferredLang isEqualToString:@"fr"] && ![preferredLang isEqualToString:@"tr"] && ![preferredLang isEqualToString:@"cs"] /*&& ![preferredLang isEqualToString:@"ru"] && ![preferredLang isEqualToString:@"id"]&& ![preferredLang isEqualToString:@"fi"]&& ![preferredLang isEqualToString:@"sv"]&& ![preferredLang isEqualToString:@"da"]&& ![preferredLang isEqualToString:@"uk"]&& ![preferredLang isEqualToString:@"pt"]&& ![preferredLang isEqualToString:@"hu"]&& ![preferredLang isEqualToString:@"ro"]&& ![preferredLang isEqualToString:@"pl"]*/) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [NSString localizedStringWithFormat:[languageBundle localizedStringForKey:translation_key value:@"" table:nil],comment];
    }
#endif
    return s;
}
@end
