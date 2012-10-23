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
    NSDate *_startingTime;
    NSDate *_endingTime;
    NSMutableArray *_persons;
}


#pragma mark - Factory Methods

+ (id)meetingWithCaptains
{
    Meeting* meeting = [[Meeting alloc] init];
    [meeting insertObject:[[[Person alloc] initWithName:@"Picard" rate:312.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Kirk" rate:212.5] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Joe" rate:32.5] autorelease] inPersonsPresentAtIndex:0];
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
        _startingTime = nil;
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
    NSString *description = [[NSString alloc] initWithFormat:@"Meeting: %li attendees, hourly rate %@/hour, elapsed %@, cost %@",
                             [self countOfPersonsPresent],
                             [currencyFormatter stringFromNumber:[self totalBillingRate]],
                             [self elapsedTimeDisplayString],
                             [currencyFormatter stringFromNumber:[self accruedCost]]];
    [currencyFormatter release];
    return [description autorelease];
}

#pragma mark - Praticipant Methods

- (NSArray*)personsPresent
{
    return [[[NSMutableArray alloc] initWithArray:_persons] autorelease];
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
    return [[_startingTime copy] autorelease];
}

- (void)setStartingTime:(NSDate *)start
{
    if (start == _startingTime) return;
    [_startingTime release];
    _startingTime = [[start copy] retain];
    // clear end time if start time > end time
    if ([start compare:[self endingTime]] == NSOrderedDescending)
    {
        [self setEndingTime:nil];
    }
}

- (NSDate*)endingTime
{
    return [[_endingTime copy] autorelease];
}

- (void)setEndingTime:(NSDate *)end
{
    if (end == _endingTime) return;
    // do not allow setting of end time < start time
    if ([end compare:[self startingTime]] == NSOrderedAscending) return;
    [end retain];
    [_endingTime release];
    _endingTime = [[end copy] retain];
}

- (NSUInteger)elapsedSeconds
{
    NSDate *end = [NSDate date];
    if ([self endingTime]) end = [self endingTime];
    NSTimeInterval difference = [end timeIntervalSinceDate:[self startingTime]];
    return difference;
}

- (double)elapsedHours
{
    return (double)[self elapsedSeconds] / 60.0 / 60.0;
}

- (NSString*)elapsedTimeDisplayString
{
    long totalSeconds = [self elapsedSeconds];
    uint seconds = totalSeconds % 60;
    uint minutes = (totalSeconds / 60) % 60;
    uint hours = totalSeconds / 60 / 60;
    return [[[NSString alloc] initWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds] autorelease];
}

#pragma mark - Costing Methods

- (NSNumber*)totalBillingRate
{
    __block double total = 0;
    [[self personsPresent] enumerateObjectsUsingBlock:^(id p, NSUInteger idx, BOOL *stop){
        total += [[p hourlyRate] doubleValue];
    }];
    NSLog(@"calculated total: %f", total);
    return [[[NSNumber alloc] initWithDouble:total] autorelease];
}

- (NSNumber*)accruedCost
{
    double cost = [[self totalBillingRate] doubleValue] * [self elapsedHours];
    return [[[NSNumber alloc] initWithDouble:cost] autorelease];
}
@end
