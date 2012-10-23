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

+ (id)meetingWithDogs
{
    // blonde, blue, brown, orange, pink, white
    Meeting* meeting = [[Meeting alloc] init];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Blonde" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Blue" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Brown" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Orange" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. Pink" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    [meeting insertObject:[[[Person alloc] initWithName:@"Mr. White" rate:25.] autorelease] inPersonsPresentAtIndex:0];
    
    return [meeting autorelease];
}

#pragma mark - KVO Methods

+ (NSSet *)keyPathsForValuesAffectingValueForTotalBillingRate
{
    NSSet *keyPaths = [NSSet setWithArray:@[@"self.personsPresent.hourlyRate"]];
    NSLog(@"keys: %@", keyPaths);
    return keyPaths;
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
}

- (void)insertObject:(id)object inPersonsPresentAtIndex:(NSUInteger)idx
{
    [_personsPresent insertObject:object atIndex:idx];
}

- (void)addToPersonsPresent:(id)person
{
    [self insertObject:person inPersonsPresentAtIndex:0];
}

- (void)removeFromPersonsPresent:(id)personsPresentObject
{
    [_personsPresent removeObject:personsPresentObject];
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx
{
    [_personsPresent removeObjectAtIndex:idx];
}

- (NSUInteger)countOfPersonsPresent
{
    return [_personsPresent count];
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
    __block double total = 0;
    [[self personsPresent] enumerateObjectsUsingBlock:^(id p, NSUInteger idx, BOOL *stop){
        total += [[p hourlyRate] doubleValue];
    }];
    return [[[NSNumber alloc] initWithDouble:total] autorelease];
}

- (NSNumber*)accruedCost
{
    double cost = [[self totalBillingRate] doubleValue] * [self elapsedHours];
    NSNumber *value = [[[NSNumber alloc] initWithDouble:cost] autorelease];
    return value;
}
@end
