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
    NSMutableArray *_personsPresent;
}


#pragma mark - Factory Methods

+ (id)meetingWithCaptains
{
    Meeting* meeting = [[Meeting alloc] init];
    
    NSArray *attendees = @[
        [[[Person alloc] initWithName:@"Picard" rate:32.5] autorelease],
        [[[Person alloc] initWithName:@"Kirk" rate:32.5] autorelease],
        [[[Person alloc] initWithName:@"Jack" rate:32.5] autorelease]
    ];
    
    [meeting setPersonsPresent:attendees];
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

+ (id)meetingWithDogs
{
    Meeting* meeting = [[Meeting alloc] init];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Blonde" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Blue" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Brown" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Orange" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Pink" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. White" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    
    return [meeting autorelease];
}

#pragma mark - Object Creation

- (id)init
{
    self = [super init];
    if (self)
    {
        _personsPresent = [[[NSMutableArray alloc] init] retain];
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

#pragma mark - Description

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

- (NSMutableArray*)personsPresent
{
    return _personsPresent;
}

- (void)setPersonsPresent:(NSArray *)people
{
    if (people == _personsPresent) return;
    [_personsPresent release];
    _personsPresent = [[[NSMutableArray alloc] initWithArray:people] retain];
    [_personsPresent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        [obj addObserver:self forKeyPath:@"hourlyRate" options:NSKeyValueObservingOptionNew context:NULL];
    }];
    [self notifyOfTotalBillingRateChange];
}

- (void)insertObject:(id)object inPersonsPresentAtIndex:(NSUInteger)idx
{
    [[self personsPresent] insertObject:object atIndex:idx];
    [object addObserver:self forKeyPath:@"hourlyRate" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)addToPersonsPresent:(id)person
{
    [self insertObject:person inPersonsPresentAtIndex:0];
}

- (void)removeFromPersonsPresent:(id)personsPresentObject
{
    NSUInteger idx = [[self personsPresent] indexOfObject:personsPresentObject];
    [self removeObjectFromPersonsPresentAtIndex:idx];
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx
{
    Person *person = [[self personsPresent] objectAtIndex:idx];
    [[self personsPresent] removeObjectAtIndex:idx];
    [person removeObserver:self forKeyPath:@"hourlyRate"];
    [self notifyOfTotalBillingRateChange];
}

- (NSUInteger)countOfPersonsPresent
{
    return [[self personsPresent] count];
}

#pragma mark - KVO Instance Methods

- (void)notifyOfTotalBillingRateChange
{
    NSString *billingRateKey = @"totalBillingRate";
    [self willChangeValueForKey:billingRateKey];
    [self didChangeValueForKey:billingRateKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hourlyRate"])
    {
        [self notifyOfTotalBillingRateChange];
    }
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
    if ([self startingTime] == nil) return 0U;
    NSDate *end = nil;
    if ([self endingTime] == nil)
    {
        end = [NSDate date];
    }
    else
    {
        end = [self endingTime];
    }
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
    return [[self personsPresent] valueForKeyPath:@"@sum.hourlyRate"];
}

- (NSNumber*)accruedCost
{
    double cost = [[self totalBillingRate] doubleValue] * [self elapsedHours];
    NSNumber *value = [[[NSNumber alloc] initWithDouble:cost] autorelease];
    return value;
}

#pragma mark - Archiving Methods

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])
    {
        _startingTime = [[coder decodeObjectForKey:@"startingTime"] retain];
        _endingTime = [[coder decodeObjectForKey:@"endingTime"] retain];
        _personsPresent = [[coder decodeObjectForKey:@"personsPresent"] retain];
        [_personsPresent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            [obj addObserver:self forKeyPath:@"hourlyRate" options:NSKeyValueObservingOptionNew context:nil];
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[self startingTime] forKey:@"startingTime"];
    [coder encodeObject:[self endingTime] forKey:@"endingTime"];
    [coder encodeObject:[self personsPresent] forKey:@"personsPresent"];
}

@end
