//
//  smController.m
//  Lizard
//
//  Created by ronan on 19/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "smController.h"


@implementation smController
- (id)init
{
	// the nib name is exactly the nib file name but without the extension
	if (![super initWithNibName:@"Smbios" bundle:nil]) {
		return nil;
	}
	
	[self setTitle:@"SmbiosController.plist"];
	return self;
}
@end
