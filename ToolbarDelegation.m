//
//  ToolbarDelegation.m
//  Lizard
//
//  Created by ronan on 18/10/09.
//  Copyright 2009 darwinx86. All rights reserved.
//

#import "ToolbarDelegation.h"


@implementation ToolbarDelegation

- (BOOL)validateToolbarItem:(NSToolbarItem *)item
{
    return YES;
}

- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar
{
	return [self allIdentifiersFor:toolbar];
}

- (NSArray *)allIdentifiersFor:(NSToolbar *)toolbar
{
	NSMutableArray *identifiers = [[NSMutableArray alloc] init];
	
	for (NSToolbarItem *item in [toolbar items]) {
		[identifiers addObject:[item itemIdentifier]];
	}
	
	return [identifiers autorelease];
}

@end
