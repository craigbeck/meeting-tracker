//
//  Document.h
//  MeetingTracker
//
//  Created by Craig Beck on 10/15/12.
//  Copyright (c) 2012 Craig Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;

@interface Document : NSDocument {
    NSTimer *_timer;
    Meeting *_meeting; 
}

@property (assign) IBOutlet NSTextField *currentTimeLabel;
@property (assign) IBOutlet NSDateFormatter *currentTimeFormatter;
@property (assign) IBOutlet NSButton *startMeetingButton;
@property (assign) IBOutlet NSButton *stopMeetingButton;

- (IBAction)startMeeting:(id)sender;
- (IBAction)stopMeeting:(id)sender;
- (IBAction)addParticipant:(id)sender;
- (IBAction)removeParticipant:(id)sender;

- (Meeting *)meeting;
- (void)setMeeting:(Meeting *)aMeeting;
- (IBAction)logMeeting:(id)sender;
- (IBAction)logParticipants:(id)sender;
- (void)updateUI:(NSTimer *)timer;


- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)timer;

@end
