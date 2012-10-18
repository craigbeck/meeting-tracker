//
//  BLPerson.h
//  MeetingTracker
//
//  Created by Craig Beck on 10/8/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    NSString *_name;
    NSNumber *_hourlyRate;
}

+ (id)personWithName:(NSString*)name hourlyRate:(double)rate;
- (id)initWithName:(NSString*)name rate:(double)rate;
- (NSString *)description;
- (NSString *)name;
- (void)setName:(NSString *)name;
- (NSNumber *)hourlyRate;
- (void)setHourlyRate:(NSNumber*)rate;

@end
