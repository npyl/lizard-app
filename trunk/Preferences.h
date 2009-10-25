//
//  Preferences.h
//  Lizard
//
//  Created by ronan on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Preferences : NSObject {

	IBOutlet id disableCC;
	IBOutlet id disableSound;
	IBOutlet id systemBoot;
	IBOutlet id disableChamUpdates;
	
	IBOutlet id displayExtraPath;
	IBOutlet id backupPath;
	IBOutlet id displayBackupPath;
}

- (IBAction)chooseExtraPath:(id)sender;
- (IBAction)clearPath:(id)sender;

- (IBAction)chooseBackupPath:(id)sender;
- (IBAction)clearBackupPath:(id)sender;
- (IBAction)activateBackupPath:(id)sender;

@end
