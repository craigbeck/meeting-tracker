//
//  Meeting.m
//  MeetingTracker
//
//  Created by Craig Beck on 10/10/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

@implementation Meeting
{
    NSDate *_startTime;
    NSDate *_endTime;
    NSMutableArray *_persons;
}


#pragma mark - Factory Methods

+ (id)meetingWithCaptains
{
    Meeting* meeting = [[Meeting alloc] init];
    [meeting insertObject:[[[Person alloc] initWithName:@"Picard" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Kirk" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Joe" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    return [meeting autorelease];
}

+ (id)meetingWithMarxBrothers
{
    Meeting* meeting = [[Meeting alloc] init];
    [meeting insertObject:[[[Person alloc] initWithName:@"Groucho" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Harpo" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Curly" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    return [meeting autorelease];
}

+ (id)meetingWithStooges
{
    Meeting* meeting = [[Meeting alloc] init];
    [meeting insertObject:[[[Person alloc] initWithName:@"Larry" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Moe" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Curly" rate:12.5] autorelease] inPersonsPresentAtIndex:0];
    return [meeting autorelease];
}

#pragma mark - Object Creation

- (id)init
{
    self = [super init];
    if (self)
    {
        _persons = [[[NSMutableArray alloc] init] retain];
        _startTime = nil;
    }
    return self;
}

- (void)dealloc
{
    [self setEndingTime:nil];
    [self setStartingTime:nil];
    [self setPersonsPresent:nil];
    [super dealloc];
}

- (NSString*)description
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *description = [[NSString alloc] initWithFormat:@"Meeting: %li attendees, hourly rate %@/hour, cost %@",
                             [self countOfPersonsPresent],
                             [currencyFormatter stringFromNumber:[self totalBillingRate]],
                             [currencyFormatter stringFromNumber:[self accruedCost]]];
    [currencyFormatter release];
    return [description autorelease];
}

#pragma mark - Praticipant Methods

- (NSArray*)personsPresent
{
    return [[[NSArray alloc] initWithArray:_persons] autorelease];
}

- (void)setPersonsPresent:(NSArray *)people
{
    if (people == _persons) return;
    [_persons release];
    _persons = [[[NSMutableArray alloc] initWithArray:people] retain];
}

- (void)insertObject:(id)object inPersonsPresentAtIndex:(NSUInteger)idx
{
    [_persons insertObject:object atIndex:idx];
}

- (void)addToPersonsPresent:(id)person
{
    [self insertObject:person inPersonsPresentAtIndex:0];
}

- (void)removeFromPersonsPresent:(id)personsPresentObject
{
    [_persons removeObject:personsPresentObject];
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx
{
    [_persons removeObjectAtIndex:idx];
}

- (NSUInteger)countOfPersonsPresent
{
    return [_persons count];
}

#pragma mark - Time Methods

- (NSDate*)startingTime
{
    return [[_startTime copy] autorelease];
}

- (void)setStartingTime:(NSDate *)start
{
    if (start == _startTime) return;
    [start retain];
    [_startTime release];
    _startTime = start;
}

- (NSDate*)endingTime
{
    return [[_endTime copy] autorelease];
}

- (void)setEndingTime:(NSDate *)end
{
    if (end == _endTime) return;
    [end retain];
    [_endTime release];
    _endTime = end;
}

- (NSUInteger)elapsedSeconds {
    return 10800;
}

- (double)elapsedHours {
    return 3.0;
}

- (NSString*)elapsedTimeDisplayString {
    return @"00:00:00";
}

#pragma mark - Costing Methods

- (NSNumber*)totalBillingRate
{
    __block double total = 0;
    [[self personsPresent] enumerateObjectsUsingBlock:^(id p, NSUInteger idx, BOOL *stop){
        total += [[p hourlyRate] doubleValue];
    }];
    return [[[NSNumber alloc] initWithDouble:total] autorelease];
}

- (NSNumber*)accruedCost
{
    double cost = [[self totalBillingRate] doubleValue] * [self elapsedHours];
    return [[[NSNumber alloc] initWithDouble:cost] autorelease];
}
@end