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
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
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
	[self setMeeting:meeting];
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
    [_meeting release];
    _meeting = aMeeting;
}

#pragma mark - Meeting Actions

- (IBAction)startMeeting:(id)sender
{
    _isMeetingStarted = YES;
    [_startMeetingButton setEnabled:![self isMeetingStarted]];
    [_stopMeetingButton setEnabled:[self isMeetingStarted]];
    [[self meeting] setStartingTime:[NSDate date]];
}

- (IBAction)stopMeeting:(id)sender
{
    _isMeetingStarted = NO;
    [_startMeetingButton setEnabled:![self isMeetingStarted]];
    [_stopMeetingButton setEnabled:[self isMeetingStarted]];
    [[self meeting] setEndingTime:[NSDate date]];
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

@end
