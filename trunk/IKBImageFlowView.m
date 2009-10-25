//
//  IKBImageFlowView.m
//  IKBrowserViewDND
//
//  Created by David Gohara on 2/28/08.
//  Copyright 2008 SmackFu-Master. All rights reserved.
//

#import "IKBImageFlowView.h"

@implementation IKBImageFlowView

#pragma mark -
#pragma mark QuickLook Implementation

/* 
 * Code derived from:  http://ciaranwal.sh/2007/12/07/quick-look-apis
 */

- (void)quickLookSelectedItems:(int)itemIndex
{
	NSMutableArray * browserData = [[self dataSource] browserData];
	
	NSMutableArray* URLs   = [NSMutableArray arrayWithCapacity:[browserData count]];
	
	NSURL * fileURL = [NSURL fileURLWithPath:[[browserData objectAtIndex:itemIndex] fullImagePath]];
	[URLs addObject:fileURL];
	
	// The code above just gathers an array of NSURLs representing the selected items,
	// to set here
	[[QLPreviewPanel sharedPreviewPanel] setURLs:URLs currentIndex:0 preservingDisplayState:YES];
	
}

- (void)updateQuicklook
{
	// Otherwise, set the current items
	[self quickLookSelectedItems:[self selectedIndex]];
	
	// And then display the panel
	[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFrontWithEffect:2];
	
	// Restore the focus to our window to demo the selection changing, scrolling 
	// (left/right) and closing (space) functionality
	[[self window] makeKeyWindow];
}

- (void)userDidPressSpaceInOutlineView:(id)anOutlineView
{
	// If the user presses space when the preview panel is open then we close it
	if([[QLPreviewPanel sharedPreviewPanel] isOpen])
		[[QLPreviewPanel sharedPreviewPanel] closeWithEffect:2];
	else
	{
		[self updateQuicklook];
	}
}

- (void)userDidPressLeftRightInView:(id)outlineView
{
	
	if([[QLPreviewPanel sharedPreviewPanel] isOpen])
	{
		[self updateQuicklook];
	}
	
}

- (void)keyDown:(NSEvent *)event
{	
	[super keyDown:event];
	
	if([[event charactersIgnoringModifiers] characterAtIndex:0] == ' ')
		[self userDidPressSpaceInOutlineView:self];
	else if([[event charactersIgnoringModifiers] characterAtIndex:0] == NSRightArrowFunctionKey)
		[self userDidPressLeftRightInView:self];
	else if([[event charactersIgnoringModifiers] characterAtIndex:0] == NSLeftArrowFunctionKey)
		[self userDidPressLeftRightInView:self];

	
}


@end
