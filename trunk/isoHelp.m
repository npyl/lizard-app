//
//  isoHelp.m
//  Lizard
//
//  Created by ronan on 29/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "isoHelp.h"


@implementation isoHelp
- (IBAction)isoHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"isoHelp"
                                               inBook:@"Lizard Help"];
}

@end
