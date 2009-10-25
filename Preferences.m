//
//  Preferences.m
//  Lizard
//
//  Created by ronan on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Preferences.h"


@implementation Preferences

BOOL isFolder;
NSString * backupDefaultDisplay = @"~/Desktop/Lizard (default)";
NSString * backupDefault = @"/Desktop/Lizard/Backup";
NSString * extraDefaultDisplay = @"/Extra (default)";
NSString * extraDefault = @"/Extra";

- (void)openPanelWillEnd:(id)panel returnCode:(NSInteger)code contextInfo:(void *)userInfo {
	if (code == NSAlertDefaultReturn) {
		NSString *theBackupPath = [panel filename];
		NSFileManager *theManager = [NSFileManager defaultManager];
        if (([theManager fileExistsAtPath:theBackupPath isDirectory:&isFolder] && isFolder)) {
			[[NSUserDefaults standardUserDefaults] setValue:theBackupPath forKey:@"Backup Folder"];
			[displayBackupPath setTextColor:[NSColor blackColor]];
			[displayBackupPath setStringValue:theBackupPath];
		}
	}

}

- (void)openPanelShouldEnd:(id)panel returnCode:(NSInteger)code contextInfo:(void *)userInfo {
	if (code == NSAlertDefaultReturn) {
		NSString *extraPath = [panel filename];
        NSFileManager *theManager = [NSFileManager defaultManager];
		
        if (([theManager fileExistsAtPath:extraPath isDirectory:&isFolder] && isFolder) && [[extraPath lastPathComponent] isEqualToString:@"Extra"]) {
			[[NSUserDefaults standardUserDefaults] setValue:extraPath forKey:@"Extra Folder"];
			[displayExtraPath setTextColor:[NSColor blackColor]];
			[displayExtraPath setStringValue:extraPath];
		}
        else {
			[displayExtraPath setTextColor:[NSColor redColor]];
			[displayExtraPath setStringValue:[[extraPath lastPathComponent] stringByAppendingString:@" is not an Extra folder"]];
			NSLog(@"can't find Extra folder at path");
		}
		if ([extraPath isEqualToString:extraDefault]) {
			[displayExtraPath setTextColor:[NSColor grayColor]];
			[displayExtraPath setStringValue:extraDefaultDisplay];
		}
		
	}
}

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	return;
}

- (void)awakeFromNib  {
NSString *DisableCCState = [[NSUserDefaults standardUserDefaults] stringForKey:@"DisableCC"];
NSString *DisableSoundState = [[NSUserDefaults standardUserDefaults] stringForKey:@"DisableSound"];
NSString *systemBootState = [[NSUserDefaults standardUserDefaults] stringForKey:@"systemBoot"];
NSString *updateState = [[NSUserDefaults standardUserDefaults] stringForKey:@"disableUpdates"];

	if ((DisableCCState) && (DisableSoundState) && (systemBootState) && (updateState)) {
		[disableCC setStringValue:DisableCCState];
		[disableSound setStringValue:DisableSoundState];
		[systemBoot setStringValue:systemBootState];
		[disableChamUpdates setStringValue:updateState];
	}
NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
NSString *showBackupPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Backup Folder"];

	if (showExtraPath) {
		[displayExtraPath setStringValue:showExtraPath];
	}
	if (showBackupPath) {
		[displayBackupPath setStringValue:showBackupPath];
	} 
	
	if ([showExtraPath isEqualToString:extraDefault]) {
		[displayExtraPath setTextColor:[NSColor grayColor]];
		[displayExtraPath setStringValue:extraDefaultDisplay];
		
	}
	if ([showBackupPath isEqualToString:backupDefault]) {
		[displayBackupPath setTextColor:[NSColor grayColor]];
		[displayBackupPath setStringValue:backupDefaultDisplay];
		
	}
}

- (IBAction)chooseExtraPath:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setTitle:@"Choose a Path"];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(openPanelShouldEnd:returnCode:contextInfo:) contextInfo:NULL];

}

- (IBAction)clearPath:(id)sender {
	[displayExtraPath setStringValue:extraDefaultDisplay];
	[displayExtraPath setTextColor:[NSColor grayColor]];
	[[NSUserDefaults standardUserDefaults] setValue:extraDefault forKey:@"Extra Folder"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)activateBackupPath:(id)sender {
	if ([backupPath state]==NSOffState) {
			[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Backup Folder"];
	}
		
	else if (([backupPath state]==NSOnState) && (displayBackupPath)) {
			if ([[displayBackupPath stringValue] isEqualToString:backupDefaultDisplay]) {
				[[NSUserDefaults standardUserDefaults] setValue:backupDefault forKey:@"Backup Folder"];
			}
			else {
				[displayBackupPath setStringValue:backupDefaultDisplay];
				[displayBackupPath setTextColor:[NSColor grayColor]];
				[[NSUserDefaults standardUserDefaults] setValue:backupDefault forKey:@"Backup Folder"];
			}
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)chooseBackupPath:(id)sender {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSWarningAlertStyle];
	
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setTitle:@"Choose a Folder"];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(openPanelWillEnd:returnCode:contextInfo:) contextInfo:NULL];
	
	if (![theManager isWritableFileAtPath:[displayBackupPath stringValue]]) {
		[[NSUserDefaults standardUserDefaults] setValue:backupDefault forKey:@"Backup Folder"];
		[displayBackupPath setTextColor:[NSColor grayColor]];
		[displayBackupPath setStringValue:backupDefaultDisplay];
		[alert setMessageText:@"You don't have permission on this folder"];
        [alert setInformativeText:@"Please choose a different folder"];
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)clearBackupPath:(id)sender {
	[displayBackupPath setStringValue:backupDefaultDisplay];
	[displayBackupPath setTextColor:[NSColor grayColor]];
	[[NSUserDefaults standardUserDefaults] setValue:backupDefault forKey:@"Backup Folder"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
@end
