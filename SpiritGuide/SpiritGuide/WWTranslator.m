//
//  WWTranslator.m
//  SpiritGuide
//
//  Created by Mason on 6/2/13.
//  Copyright (c) 2013 Wu Wei Wu. All rights reserved.
//

#import "WWTranslator.h"


@implementation WWTranslator {
    sqlite3* db;
    int total;
}

WW_INIT_SINGELTON

- (void) initSingleton {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"words" withExtension:@"sqlite"];
    if (sqlite3_open([[url absoluteString] UTF8String], &db) != SQLITE_OK) {
        elog(@"[SQLITE] Unable to open database!");
    }
    total = [self selectInt:@"SELECT count(*) FROM words;"];
}

- (NSString*) selectString:(NSString*)query {
    return [[[self query:query] lastObject] lastObject];
}

- (int) selectInt:(NSString*)query {
    return [[[[self query:query] lastObject] lastObject] intValue];
}

- (NSArray *)query:(NSString *)query {
    
    sqlite3_stmt *statement = nil;
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"[SQLITE] Error when preparing query!");
    } else {
        NSMutableArray *result = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *row = [[NSMutableArray alloc] init];
            
            for (int i=0; i<sqlite3_column_count(statement); i++) {
                int colType = sqlite3_column_type(statement, i);
                id value;
                if (colType == SQLITE_TEXT) {
                    const unsigned char *col = sqlite3_column_text(statement, i);
                    value = [NSString stringWithFormat:@"%s", col];
                } else if (colType == SQLITE_INTEGER) {
                    int col = sqlite3_column_int(statement, i);
                    value = [NSNumber numberWithInt:col];
                } else if (colType == SQLITE_FLOAT) {
                    double col = sqlite3_column_double(statement, i);
                    value = [NSNumber numberWithDouble:col];
                } else if (colType == SQLITE_NULL) {
                    value = [NSNull null];
                } else {
                    NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                }
                                
                [row addObject:value];
            }
            [result addObject:row];
        }
        return result;
    }
    return nil;
}

- (NSString*) convert:(NSValue*)rune {
    NSString* glyph = [rune description];
    
    char ch = [[glyph substringFromIndex:glyph.length - 3] intValue];
    
    if ((ch == ' ' || ch == '?' || ch == '!' || ch == '\n') || (ch > 'a' && ch < 'z') || (ch > 'A' && ch < 'Z')) {
        return [NSString stringWithFormat:@"%c", ch];
    } else {
        return [@[@"", @"", @" ", @" ", @" ", @" ", @"\n", @"\n"] objectAtIndex:WWRand(8)];
    }
    
    return nil;
}


- (NSString*) translate:(NSValue*)rune {
    NSString* glyph = [rune description];

    int index = [[glyph substringFromIndex:glyph.length - 6] intValue];
    
    NSString* nxt = @"";
        
    while (index > total) {
        index -= total;
        nxt = @"\n";
    }
    
    return [nxt stringByAppendingString:[self selectString:[NSString stringWithFormat:@"SELECT word FROM words WHERE dex = %d", index]]];
}

@end
