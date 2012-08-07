//
//  SYAppDelegate.m
//  Locker
//
//  Created by Serhat Yanıkoğlu on 06.08.2012.
//  Copyright (c) 2012 Serhat Yanıkoğlu. All rights reserved.
//

#import "SYAppDelegate.h"
#import "DDHotKeyCenter.h"

@implementation SYAppDelegate

@synthesize statusItem;

// Constants
unsigned short globalHotkey = 37;
NSUInteger globalHotkeyModifiers = NSCommandKeyMask; // use | for multiple values


#pragma mark - App Delegate Methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	if (![self registerHotKey:globalHotkey withModifiedFlags:globalHotkeyModifiers]) {
		[[NSApplication sharedApplication] terminate:nil];
	}
}

-(void)awakeFromNib{
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	self.statusItem.menu = statusMenu;
	self.statusItem.highlightMode = YES;
//	self.statusItem.image = [NSImage imageNamed:@"Status"];
//	self.statusItem.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
	self.statusItem.image = [NSImage imageNamed:@"lock-6-22x18"];
	self.statusItem.alternateImage = [NSImage imageNamed:@"lock-6-22x18-inverted2"];
}

- (void) dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [super dealloc];
}


#pragma mark - Menu Methods

- (IBAction)lockScreen:(id)sender {

	NSString *cgSessionLaunchPath = @"/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession";
	NSString *cgSessionArgv1 = @"-suspend";

	NSTask *cgSession = [[NSTask alloc] init];
    [cgSession setLaunchPath:cgSessionLaunchPath];
    [cgSession setArguments:[NSArray arrayWithObjects:cgSessionArgv1, nil]];
    [cgSession setStandardInput:[NSPipe pipe]];

	NSLog(@"Locking the screen...");
    [cgSession launch];
    [cgSession waitUntilExit];

	// Check if termination successful
	if ([cgSession terminationStatus]) {
		NSLog(@"CGSession returned with a status of: %d", [cgSession terminationStatus]);
	}

	[cgSession release];
}

- (IBAction)showAbout:(id)sender {
	NSLog(@"Displaying about...");
}

- (IBAction)quitApplication:(id)sender {
	
	[self unregisterHotkey:globalHotkey withModifiedFlags:globalHotkeyModifiers];

	NSLog(@"Terminating the application...");
	[[NSApplication sharedApplication] terminate:nil];
}


# pragma mark - Hotkey Methods

// 37 for L
// NSCommandKeyMask for Cmd
// Key codes: http://boredzo.org/blog/archives/2007-05-22/virtual-key-codes
- (BOOL)registerHotKey:(unsigned short)keyCode withModifiedFlags:(NSUInteger)flags {
	NSLog(@"Registering global hotkey (⌘L)...");

	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];

	if (![c registerHotKeyWithKeyCode:keyCode modifierFlags:flags target:self action:@selector(hotkeyWithEvent:) object:nil]) {

		NSLog(@"Unable to register global hotkey (⌘L).");
		[c release];
		return NO;
	} else {

//		NSLog(@"Registered global hotkey: %@", [c registeredHotKeys]);
		[c release];
		return YES;
	}
}

- (void)unregisterHotkey:(unsigned short)hotkey withModifiedFlags:(NSUInteger)flags {
	NSLog(@"Unregistering global hotkey...");	
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:hotkey modifierFlags:flags];
	[c release];
}

- (void)hotkeyWithEvent:(NSEvent *)hkEvent {

	if (hkEvent.keyCode == globalHotkey) {
		[self lockScreen:nil];
	} else {
		NSLog(@"Unknown key event occured: %@", hkEvent);
	}
}
@end