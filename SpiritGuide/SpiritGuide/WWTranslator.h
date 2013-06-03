//
//  WWTranslator.h
//  SpiritGuide
//
//  Created by Mason on 6/2/13.
//  Copyright (c) 2013 Wu Wei Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWTranslator : NSObject

WW_SINGLETON_INTERFACE(WWTranslator*)

- (NSString*) translate:(NSValue*)rune;
- (NSString*) convert:(NSValue*)rune;

@end
