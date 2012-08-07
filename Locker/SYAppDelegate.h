//
//  SYAppDelegate.h
//  Locker
//
//  Created by Serhat Yanıkoğlu on 06.08.2012.
//  Copyright (c) 2012 Serhat Yanıkoğlu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SYAppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSMenuItem *lockScreenMenuItem;
	IBOutlet NSMenuItem *quitMenuItem;
}

@property (nonatomic, retain) NSStatusItem *statusItem;

- (IBAction)lockScreen:(id)sender;
- (IBAction)quitApplication:(id)sender;

@end
