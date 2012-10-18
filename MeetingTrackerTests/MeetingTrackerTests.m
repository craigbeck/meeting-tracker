//
//  MeetingTrackerTests.m
//  MeetingTrackerTests
//
//  Created by Craig Beck on 10/8/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import "MeetingTrackerTests.h"
#import "Person.h"
#import "Meeting.h"

@implementation MeetingTrackerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testHourlyRate
{
    Person *person = [[Person alloc] initWithName:@"myname" rate:0.85];
    STAssertEquals(0.85, [[person hourlyRate] doubleValue], @"unexpected hourly rate");
}

- (void)testDescription {
    Person *person = [[[Person alloc] initWithName:@"Mr. Foobar" rate:3.13] autorelease];
    NSString *expected = @"Mr. Foobar, $3.13/hour";
    STAssertTrue([[person description] isEqualToString:expected], @"expected: \"%@\" actual: \"%@\"", expected, person);
}

- (void)testTotalBillingRateWithOnePerson {
    Person* person = [[Person alloc] initWithName:@"foo" rate:7.0];
    Meeting* meeting = [[Meeting alloc] init];
    [meeting insertObject:person inPersonsPresentAtIndex:0];
    STAssertEqualsWithAccuracy([[meeting totalBillingRate] doubleValue], [[person hourlyRate] doubleValue], 0.01, @"meeting rate nexpected");
}

//- (void)testTotalBilingRateWithMultiplePersons {
//    Meeting* meeting = [[Meeting alloc] init];
//    [meeting insertObject:[[Person alloc] initWithName:@"foo" rate:3.0] inPersonsPresentAtIndex:0];
//    [meeting insertObject:[[Person alloc] initWithName:@"foo" rate:5.0] inPersonsPresentAtIndex:0];
//    [meeting insertObject:[[Person alloc] initWithName:@"foo" rate:7.0] inPersonsPresentAtIndex:0];
//    STAssertEqualsWithAccuracy([[meeting totalBillingRate] doubleValue], 15.0, 0.01, @"meeting rate nexpected");
//}

@end
