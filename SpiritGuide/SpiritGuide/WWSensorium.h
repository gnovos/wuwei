//
//  WWSensor.h
//  SpiritGuide
//
//  Created by Mason on 5/12/13.
//  Copyright (c) 2013 Wu Wei Wu. All rights reserved.
//

typedef enum {
   WWSensoriumModeOff = 0,
   WWSensoriumModeFull,
   WWSensoriumModeBio,
   WWSensoriumModeForce,
   WWSensoriumModes
} WWSensoriumMode;

typedef void (^WWMedium)(NSString* message);

@interface WWSensorium : NSObject

WW_SINGLETON_INTERFACE(WWSensorium*)

@property (nonatomic, strong) NSMutableString* vapors;
@property (nonatomic, strong) WWMedium medium;
@property (nonatomic, assign) WWSensoriumMode mode;
@property (nonatomic, assign) CGFloat sensitivity;

- (void) start;
- (void) stop;

- (void) sense;

@end
