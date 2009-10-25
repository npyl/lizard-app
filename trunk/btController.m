//  Lizard
//
//  Created by ronan on 19/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "btController.h"


@implementation btController
- (id)init
{
	// the nib name is exactly the nib file name but without the extension
	if (![super initWithNibName:@"Boot" bundle:nil]) {
		return nil;
	}
	
	[self setTitle:@"com.apple.boot.plist"];
	return self;
}
@end
