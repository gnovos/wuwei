//
//  WWSensor.m
//  SpiritGuide
//
//  Created by Mason on 5/12/13.
//  Copyright (c) 2013 Wu Wei Wu. All rights reserved.
//

#import "WWSensorium.h"
#import "WWTranslator.h"

@implementation WWSensorium {
    CMMotionManager* _motionManager;
    NSTimer* _sensor;
}

WW_INIT_SINGELTON

- (void) initSingleton {
    _motionManager = [[CMMotionManager alloc] init];
    _vapors = [[NSMutableString alloc] initWithString:@"\n~\n"];
    _sensitivity = 0.1;
}

- (void) sense {
    [_sensor invalidate];
    _sensor = [NSTimer scheduledTimerWithTimeInterval:(M_PI * M_E) target:self selector:@selector(listen) userInfo:nil repeats:YES];
}

- (void) listen {
    
    NSMutableDictionary* voices = [[NSMutableDictionary alloc] init];

    if (_motionManager.magnetometerAvailable) {
        CMMagnetometerData* mag = _motionManager.magnetometerData;
        [voices setObject:@[@(mag.magneticField.x), @(mag.magneticField.y),@(mag.magneticField.z)] forKey:@"magnets"];
    }
    
    if (_motionManager.gyroAvailable) {
        CMGyroData* gyro = _motionManager.gyroData;
        [voices setObject:@[@(gyro.rotationRate.x), @(gyro.rotationRate.y),@(gyro.rotationRate.z)] forKey:@"gyro"];
    }

    if (_motionManager.accelerometerAvailable) {
        CMAccelerometerData* accel = _motionManager.accelerometerData;
        [voices setObject:@[@(accel.acceleration.x), @(accel.acceleration.y),@(accel.acceleration.z)] forKey:@"spark"];
    }
    
    if (_motionManager.deviceMotionAvailable) {
        CMDeviceMotion* motion = _motionManager.deviceMotion;
        CMAttitude* attitude = motion.attitude;
        [voices setObject:@[@(attitude.roll), @(attitude.pitch),@(attitude.yaw)] forKey:@"yawn"];

        CMRotationRate rotation = motion.rotationRate;
        [voices setObject:@[@(rotation.x), @(rotation.y),@(rotation.z)] forKey:@"spin"];
        
        CMAcceleration gravity = motion.gravity;
        [voices setObject:@[@(gravity.x), @(gravity.y),@(gravity.z)] forKey:@"valgrav"];
        
        CMAcceleration acceleration = motion.userAcceleration;
        [voices setObject:@[@(acceleration.x), @(acceleration.y),@(acceleration.z)] forKey:@"scoot"];
    }
    
    [voices enumerateKeysAndObjectsUsingBlock:^(id key, NSArray* values, BOOL *stop) {
        [values enumerateObjectsUsingBlock:^(NSValue* val, NSUInteger idx, BOOL *stop) {
            if (idx % 7 == 0) {
                NSString* translation = [[WWTranslator instance] translate:val];
                if (translation && translation.length) {
                    [_vapors appendFormat:@" %@ ", translation];
                }
            } else {
                NSString* translation = [[WWTranslator instance] convert:val];
                if (translation && translation.length) {
                    [_vapors appendFormat:@"%@", translation];
                }                
            }
        }];
        
        if (_vapors.length && self.medium && WWRandPercent < _sensitivity) {
            self.medium(_vapors);
            [_vapors setString:@"~\n"];
        }
    }];

}


- (void) start {
    
    if (_motionManager.magnetometerAvailable) {
        [_motionManager startMagnetometerUpdates];
    }

    if (_motionManager.gyroAvailable) {
        [_motionManager startGyroUpdates];
    }

    if (_motionManager.accelerometerAvailable) {
        [_motionManager startAccelerometerUpdates];
    }
    
    if (_motionManager.deviceMotionAvailable) {
        [_motionManager startDeviceMotionUpdates];
    }

}

- (void) stop {
    
    if (_motionManager.magnetometerAvailable) {
        [_motionManager stopMagnetometerUpdates];
    }
    
    if (_motionManager.gyroAvailable) {
        [_motionManager stopGyroUpdates];
    }

    if (_motionManager.accelerometerAvailable) {
        [_motionManager stopAccelerometerUpdates];
    }
    
    if (_motionManager.deviceMotionAvailable) {
        [_motionManager stopDeviceMotionUpdates];
    }
    
}

@end




