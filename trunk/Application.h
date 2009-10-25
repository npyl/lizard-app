//
//  Application.h
//  Lizard
//
//  Created by ronan on 18/10/09.
//  Copyright 2009 darwinx86. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ToolbarDelegation.h"
#import "thController.h"
#import "smController.h"
#import "btController.h"
#import "iuController.h"

@interface Application : NSObject {
	IBOutlet NSBox *viewHolder;
	IBOutlet NSToolbar *toolbar;
	IBOutlet NSWindow *window;
	
	ToolbarDelegation *toolbarHandler;
	NSMutableArray *availableControllers;
}

- (IBAction)changeView:(id)sender;

@end
