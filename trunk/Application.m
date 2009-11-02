//
//  Application.m
//  Lizard
//
//  Created by ronan on 18/10/09.
//  Copyright 2009 darwinx86. All rights reserved.
//

#import "Application.h"
#import "TestGeneralViewController.h"
#import "MBPreferencesController.h"

@implementation Application

- (void)awakeFromNib
{
	// remove DS_Store
	NSError *error;
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *removeDS = [showExtraPath stringByAppendingPathComponent:@"Themes/.DS_Store"];
	if (removeDS) {
	[theManager removeItemAtPath:removeDS error:&error];
	}
	
	//paramètre dossier Extra par defaut
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	if (!showExtraPath) {
		[[NSUserDefaults standardUserDefaults] setValue:@"/Extra" forKey:@"Extra Folder"];
	}
		
	
	//centrer l'application au lancement
	[window center];
	
	toolbarHandler = [[ToolbarDelegation alloc] init];
	[toolbar setDelegate:toolbarHandler];
	
	NSToolbarItem *button = [[toolbar items] objectAtIndex:1];
	[toolbar setSelectedItemIdentifier:[button itemIdentifier]];
	[self changeView:button];

	
}
// terminer le programme a la fermeture
- (BOOL)windowShouldClose:(id)window {
	[NSApp terminate:nil];
	return YES;
}

- (id)init
{
	[super init];
	
	availableControllers = [[NSMutableArray alloc] init];
	
	NSViewController *controller;
	
	controller = [[btController alloc] init];
	[availableControllers addObject:controller];
	[controller release];
	
	controller = [[smController alloc] init];
	[availableControllers addObject:controller];
	[controller release];
	
	controller = [[thController alloc] init];
	[availableControllers addObject:controller];
	[controller release];
	
	controller = [[iuController alloc] init];
	[availableControllers addObject:controller];
	[controller release];
	
	return self;
}

- (IBAction)changeView:(id)sender
{
	int i = [sender tag];
	
	NSViewController *controller = [availableControllers objectAtIndex:i];
	NSView *view = [controller view];
	
	NSSize currentSize = [[viewHolder contentView] frame].size;
	NSSize newSize = [view frame].size;
	
	float deltaWidth = newSize.width - currentSize.width;
	float deltaHeight = newSize.height - currentSize.height;
	
	NSRect frame = [window frame];

	frame.size.height += deltaHeight;
	frame.origin.y -= deltaHeight;
	frame.size.width += deltaWidth;
	
	[viewHolder setContentView:nil];
	
	[window setFrame:frame 
			 display:YES 
			 animate:YES];
	
	[viewHolder setContentView:view];
	
	[view setNextResponder:controller];
	[controller setNextResponder:viewHolder];
}

- (void)dealloc
{
	[toolbarHandler release];
	[availableControllers release];
	[super dealloc];
}
@end
