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
    if (self) {
        // Add your subclass-specific initialization here.
        _meeting = [[Meeting meetingWithCaptains] retain];
        _isMeetingStarted = NO;
    }
    NSLog(@"init finished");
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
    [_meeting setStartingTime:[NSDate date]];
    [self updateUI:[self timer]];
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"windowWillClose");
    [[self timer] invalidate];
}

#pragma mark - NSCoding Methods

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    // TODO: implement saving
    return [NSData data];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
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
    NSLog(@"meeting started");
    _isMeetingStarted = YES;
    [[self meeting] setStartingTime:[NSDate date]];
}

- (IBAction)stopMeeting:(id)sender
{
    NSLog(@"meeting stopped");
    _isMeetingStarted = NO;
    [[self meeting] setEndingTime:[NSDate date]];
}

- (BOOL)isMeetingStarted
{
    return _isMeetingStarted;
}

- (IBAction)addParticipant:(id)sender
{
    NSLog(@"add participant");
    Person *person = [[[Person alloc] init] autorelease];
    [[self meeting] addToPersonsPresent:person];
}

- (IBAction)removeParticipant:(id)sender
{
    NSLog(@"remove participant");
}

#pragma mark - Logging Actions

- (IBAction)logMeeting:(id)sender
{
    NSLog(@"%@", [self meeting]);
}

- (IBAction)logParticipants:(id)sender
{
    NSLog(@"%@", [[self meeting] personsPresent]);
}

#pragma mark - UI Methods

- (void)updateUI:(NSTimer *)timer  {
    [[self currentTimeLabel] setStringValue:[NSString stringWithFormat:@"%@", [NSDate date]]];
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

@end
