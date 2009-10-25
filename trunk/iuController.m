//
//  iuController.m
//  Lizard
//
//  Created by ronan on 18/10/09.
//  Copyright 2009 darwinx86. All rights reserved.
//

#import "iuController.h"


@implementation iuController
- (id)init
{
	// the nib name is exactly the nib file name but without the extension
	if (![super initWithNibName:@"instalUpdate" bundle:nil]) {
		return nil;
	}
	
	[self setTitle:@"install and update"];
	return self;
}
@end
