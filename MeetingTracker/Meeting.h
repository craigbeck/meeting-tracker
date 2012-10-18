//
//  Meeting.h
//  MeetingTracker
//
//  Created by Craig Beck on 10/10/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

+ (id)meetingWithCaptains;
+ (id)meetingWithMarxBrothers;
+ (id)meetingWithStooges;

- (NSDate*)startingTime;
- (void)setStartingTime:(NSDate *)aStartingTime;
- (NSDate*)endingTime;
- (void)setEndingTime:(NSDate*)anEndingTime;
- (NSMutableArray*)personsPresent;
- (void)setPersonsPresent:(NSArray*)people;
- (void)addToPersonsPresent:(id)person;
- (void)removeFromPersonsPresent:(id)personsPresentObject;
- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)object inPersonsPresentAtIndex:(NSUInteger)idx;
- (NSUInteger)countOfPersonsPresent;
- (NSUInteger)elapsedSeconds;
- (double)elapsedHours;
- (NSString *)elapsedTimeDisplayString;
- (NSNumber*)accruedCost;
- (NSNumber*)totalBillingRate;
@end
