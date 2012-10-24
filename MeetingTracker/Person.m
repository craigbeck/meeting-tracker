//
//  Person.m
//  MeetingTracker
//
//  Created by Craig Beck on 10/8/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark - Object Creation

+ (id)personWithName:(NSString *)name hourlyRate:(double)rate
{
    return [[[Person alloc] initWithName:name rate:rate] autorelease];
}

- (id)initWithName:(NSString *)name rate:(double)rate
{
    self = [super init];
    if (self) {
        _name = [[name copy] retain];
        _hourlyRate = [[[NSNumber alloc] initWithDouble:rate] retain];
    }
    return self;
}

- (id)init
{
    return [self initWithName:@"anonymous" rate:0.0];
}

- (void)dealloc
{
    [self setName:nil];
    [self setHourlyRate:nil];
    [super dealloc];
}

#pragma mark - Property Accessors

- (NSNumber*)hourlyRate {
    return [[_hourlyRate copy] autorelease];
}

- (void)setHourlyRate:(NSNumber*)rate {
    if (rate == _hourlyRate) return;
    [_hourlyRate release];
    _hourlyRate = [[rate copy] retain];
}

- (NSString*)name {
    return [[_name copy] autorelease];
}

- (void)setName:(NSString*)name
{
    if (name == _name) return;
    [_name release];
    _name = [[name copy] retain];
}

- (NSString*)description
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencyCode:@"USD"];
    NSString *description = [[NSString alloc] initWithFormat:@"%@, %@/hour",
                             [self name],
                             [currencyFormatter stringFromNumber:[self hourlyRate]]];
    [currencyFormatter release];
    return [description autorelease];
}

#pragma mark - Archiving Methods

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])
    {
        _name = [[coder decodeObjectForKey:@"name"] retain];
        _hourlyRate = [[coder decodeObjectForKey:@"hourlyRate"] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[self name] forKey:@"name"];
    [coder encodeObject:[self hourlyRate] forKey:@"hourlyRate"];
}

@end
