//
//  Document.m
//  MeetingTracker
//
//  Created by Craig Beck on 10/15/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import "Document.h"
#import "Meeting.h"
#import "Person.h"

@implementation Document

#pragma mark - Object Creation

- (id)init
{
    self = [super init];
    if (self)
    {
        _meeting = [[[Meeting alloc] init] retain];
        [_meeting addObserver:self forKeyPath:kKeyPathPersonsPresent options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        _isMeetingStarted = NO;
    }
    return self;
}

- (void)dealloc
{
    [_timer release];
    _timer = nil;
    
    [_meeting release];
    _meeting = nil;
    
    [super dealloc];
}

#pragma mark - Window Methods

- (NSString *)windowNibName
{
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(updateUI:)
                                                  userInfo:nil
                                                   repeats:YES]];
    [self updateUI:[self timer]];
    [_startMeetingButton setEnabled:![self isMeetingStarted]];
    [_stopMeetingButton setEnabled:[self isMeetingStarted]];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [self stopMeeting:self];
    [[self timer] invalidate];
}

#pragma mark - NSCoding Methods

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:[self meeting]];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    Meeting *meeting;
	@try
    {
		meeting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	@catch (NSException *e)
    {
		if (outError)
        {
			NSDictionary *d = @{ NSLocalizedFailureReasonErrorKey: @"Data is corrupted."} ;
			*outError = [NSError errorWithDomain:NSOSStatusErrorDomain
											code:unimpErr
										userInfo:d];
		}
		return NO;
	}
    
    [self startObservingMeeting:meeting];
    _meeting = [meeting retain];
    return YES;
}

#pragma mark - Meeting property

- (Meeting *)meeting
{
    return _meeting;
}

- (void)setMeeting:(Meeting *)aMeeting
{
    if (_meeting == aMeeting) return;
    [aMeeting retain];
    
    [self startObservingMeeting:aMeeting];
    
    [self stopObservingMeeting:_meeting];
    [[[self undoManager] prepareWithInvocationTarget:self] setMeeting:_meeting];
    [_meeting release];
    
    _meeting = aMeeting;
}

#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    Person *person;
    if (keyPath == kKeyPathPersonsPresent)
    {
        switch ([[change objectForKey:kChangeKind] intValue]) {
            case kChangeAdd:
                person = [[change objectForKey:kNewObject] objectAtIndex:0];
                [self startObservingPerson:person];
                [[[self undoManager] prepareWithInvocationTarget:[self meeting]] removeFromPersonsPresent:person];
                break;
            case kChangeRemove:
                person = [[change objectForKey:kOldObject] objectAtIndex:0];
                [self stopObservingPerson:person];
                [[[self undoManager] prepareWithInvocationTarget:[self meeting]] insertObject:person inPersonsPresentAtIndex:[[change objectForKey:@"indexes"] firstIndex]];
                break;
            default:
                break;
        }
    }
    else if (keyPath == kKeyPathHourlyRate)
    {
        switch ([[change objectForKey:kChangeKind] intValue]) {
            case kChangeUpdate:
                [[[self undoManager] prepareWithInvocationTarget:object] setHourlyRate:[change objectForKey:kOldObject]];
                break;
            default:
                break;
        }
    }
    else if (keyPath == kKeyPathName)
    {
        switch ([[change objectForKey:kChangeKind] intValue]) {
            case kChangeUpdate:
                [(Person *)[[self undoManager] prepareWithInvocationTarget:object] setName:[change objectForKey:kOldObject]];
                break;
            default:
                break;
        }
    }
}

- (void)startObservingMeeting:(Meeting *)meeting
{
    [meeting addObserver:self forKeyPath:kKeyPathPersonsPresent options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[meeting personsPresent] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop)
    {
        [self startObservingPerson:object];
    }];
}

- (void)stopObservingMeeting:(Meeting *)meeting
{
    [meeting removeObserver:self forKeyPath:kKeyPathPersonsPresent];
    [[meeting personsPresent] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop)
    {
        [self stopObservingPerson:object];
    }];
}

- (void)startObservingPerson:(Person *)person
{
    [person addObserver:self forKeyPath:kKeyPathName options:NSKeyValueObservingOptionOld context:nil];
    [person addObserver:self forKeyPath:kKeyPathHourlyRate options:NSKeyValueObservingOptionOld context:nil];
}

- (void)stopObservingPerson:(Person *)person
{
    [person removeObserver:self forKeyPath:kKeyPathName];
    [person removeObserver:self forKeyPath:kKeyPathHourlyRate];
}

#pragma mark - Meeting Actions

- (IBAction)startMeeting:(id)sender
{
    _isMeetingStarted = YES;
    [_startMeetingButton setEnabled:![self isMeetingStarted]];
    [_stopMeetingButton setEnabled:[self isMeetingStarted]];
    [[self meeting] setStartingTime:[NSDate date]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"meeting.started" object:[self meeting]];
}

- (IBAction)stopMeeting:(id)sender
{
    _isMeetingStarted = NO;
    [_startMeetingButton setEnabled:![self isMeetingStarted]];
    [_stopMeetingButton setEnabled:[self isMeetingStarted]];
    [[self meeting] setEndingTime:[NSDate date]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"meeting.stopped" object:[self meeting]];
}

- (BOOL)isMeetingStarted
{
    return _isMeetingStarted;
}

#pragma mark - Logging Actions

- (IBAction)logMeeting:(id)sender
{
    Log(@"%@", [self meeting]);
}

- (IBAction)logParticipants:(id)sender
{
    Log(@"%@", [[self meeting] personsPresent]);
}

#pragma mark - UI Methods

- (void)updateUI:(NSTimer *)timer
{
    [[self meeting] willChangeValueForKey:@"currentTime"];
    [[self meeting] didChangeValueForKey:@"currentTime"];
    [[self meeting] willChangeValueForKey:@"accruedCost"];
    [[self meeting] didChangeValueForKey:@"accruedCost"];
    [[self meeting] willChangeValueForKey:@"elapsedTimeDisplayString"];
    [[self meeting] didChangeValueForKey:@"elapsedTimeDisplayString"];
}

#pragma mark - Property Accessors

- (void)setTimer:(NSTimer *)timer
{
    if (timer == _timer) return;
    [_timer release];
    _timer = [timer retain];
}

- (NSTimer *)timer
{
    return _timer;
}

- (NSDate *)currentTime
{
    return [NSDate date];
}

#pragma mark - Reset methods

- (IBAction)resetWithCaptains:(id)sender
{
    [self setMeeting:[Meeting meetingWithCaptains]];
}

- (IBAction)resetWithStooges:(id)sender
{
    [self setMeeting:[Meeting meetingWithStooges]];
}

- (IBAction)resetWithDogs:(id)sender
{
    [self setMeeting:[Meeting meetingWithDogs]];
}

@end
