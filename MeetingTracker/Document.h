//
//  Document.h
//  MeetingTracker
//
//  Created by Craig Beck on 10/15/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kChangeKind @"kind"
#define kChangeUpdate 1
#define kChangeAdd 2
#define kChangeRemove 3
#define kOldObject @"old"
#define kNewObject @"new"
#define kObjectIndexes @"indexes"
#define kKeyPathPersonsPresent @"personsPresent"
#define kKeyPathName @"name"
#define kKeyPathHourlyRate @"hourlyRate"


@class Meeting;

@interface Document : NSDocument {
    NSTimer *_timer;
    Meeting *_meeting;
    BOOL _isMeetingStarted;
}

@property (assign) IBOutlet NSTextField *currentTimeLabel;
@property (assign) IBOutlet NSDateFormatter *currentTimeFormatter;
@property (assign) IBOutlet NSButton *startMeetingButton;
@property (assign) IBOutlet NSButton *stopMeetingButton;

- (IBAction)startMeeting:(id)sender;
- (IBAction)stopMeeting:(id)sender;
- (Meeting *)meeting;
- (void)setMeeting:(Meeting *)aMeeting;
- (IBAction)logMeeting:(id)sender;
- (IBAction)logParticipants:(id)sender;
- (void)updateUI:(NSTimer *)timer;
- (BOOL)isMeetingStarted;

- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)timer;
- (NSDate *)currentTime;

- (IBAction)resetWithCaptains:(id)sender;
- (IBAction)resetWithStooges:(id)sender;
- (IBAction)resetWithDogs:(id)sender;
@end
