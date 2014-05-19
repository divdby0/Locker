//
//  AppDelegate.m
//  Locker
//
//  Created by Serhat Yanıkoğlu on 06.08.2012.
//  Copyright (c) 2012 Serhat Yanıkoğlu. All rights reserved.
//

#import "AppDelegate.h"
#import "DDHotKeyCenter.h"

@implementation AppDelegate

@synthesize statusItem;

#pragma mark - Constants
unsigned short globalHotKey = 37;
NSUInteger globalHotKeyModifiers = NSCommandKeyMask; // use | for multiple values


#pragma mark - App Delegate Methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	if (![self registerHotKey:globalHotKey withModifiedFlags:globalHotKeyModifiers]) {
		[[NSApplication sharedApplication] terminate:nil];
	}
}

- (void)awakeFromNib {
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	self.statusItem.menu = statusMenu;
	self.statusItem.highlightMode = YES;
	self.statusItem.image = [NSImage imageNamed:@"StatusIcon"];
	self.statusItem.alternateImage = [NSImage imageNamed:@"StatusIconHighlighted"];
}

- (void) dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    [super dealloc];
}


#pragma mark - Menu Methods

- (IBAction)startScreenSaver:(id)sender {
    NSString * screenSaverLaunchPath = @"/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine";

    NSTask *screenSaver = [[NSTask alloc] init];
    [screenSaver setLaunchPath:screenSaverLaunchPath];
    [screenSaver setStandardInput:[NSPipe pipe]];

    NSLog(@"Starting the screen saver.");
    [screenSaver launch];
    [screenSaver waitUntilExit];

    // Check if termination is successful
    if ([screenSaver terminationStatus]) {
        NSLog(@"ScreenSaver returned with a status of: %d", [screenSaver terminationStatus]);
    }

    [screenSaver release];
}

- (IBAction)lockScreen:(id)sender {

	NSString *cgSessionLaunchPath = @"/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession";
	NSString *cgSessionArgv1 = @"-suspend";

	NSTask *cgSession = [[NSTask alloc] init];
    [cgSession setLaunchPath:cgSessionLaunchPath];
    [cgSession setArguments:[NSArray arrayWithObjects:cgSessionArgv1, nil]];
    [cgSession setStandardInput:[NSPipe pipe]];

	NSLog(@"Locking the screen.");
    [cgSession launch];
    [cgSession waitUntilExit];

	// Check if termination is successful
	if ([cgSession terminationStatus]) {
		NSLog(@"CGSession returned with a status of: %d", [cgSession terminationStatus]);
	}

	[cgSession release];
}

- (IBAction)showAbout:(id)sender {
	NSLog(@"Displaying about.");

	[[NSApplication sharedApplication] orderFrontStandardAboutPanel:nil];
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (IBAction)quitApplication:(id)sender {

    [self unregisterHotKey:globalHotKey withModifiedFlags:globalHotKeyModifiers];

	NSLog(@"Terminating the application.");
	[[NSApplication sharedApplication] terminate:nil];
}


# pragma mark - Hotkey Methods

// 37 for L
// NSCommandKeyMask for Cmd
// Key codes: http://boredzo.org/blog/archives/2007-05-22/virtual-key-codes
- (BOOL)registerHotKey:(unsigned short)keyCode withModifiedFlags:(NSUInteger)flags {
	NSLog(@"Registering global hotkey (⌘L).");

	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];

	if (![c registerHotKeyWithKeyCode:keyCode modifierFlags:flags target:self action:@selector(hotKeyWithEvent:) object:nil]) {

		NSLog(@"Unable to register global hotkey (⌘L).");
		[c release];
		return NO;
	} else {

//		NSLog(@"Registered global hotKey: %@", [c registeredHotKeys]);
		[c release];
		return YES;
	}
}

- (void)unregisterHotKey:(unsigned short)hotkey withModifiedFlags:(NSUInteger)flags {
	NSLog(@"Unregistering global hotkey.");
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:hotkey modifierFlags:flags];
	[c release];
}

- (void)hotKeyWithEvent:(NSEvent *)hotKeyEvent {

	if (hotKeyEvent.keyCode == globalHotKey) {
//		[self lockScreen:nil];
		[self startScreenSaver:nil];
	} else {
		NSLog(@"Unknown key event occured: %@", hotKeyEvent);
	}
}

@end