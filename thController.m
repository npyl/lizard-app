//
//  thController.m
//  Lizard
//
//  Created by ronan on 19/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "thController.h"


@implementation thController
- (id)init
{
	// the nib name is exactly the nib file name but without the extension
	if (![super initWithNibName:@"cdBoot" bundle:nil]) {
		return nil;
	}
	
	[self setTitle:@"cdBoot Management"];
	return self;
}
@end
