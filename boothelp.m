//
//  boothelp.m
//  Lizard
//
//  Created by ronan on 11/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "boothelp.h"


@implementation boothelp
//injections
- (IBAction)bootHelpFile:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"bootHelpMe"
                                               inBook:@"Lizard Help"];
}
@end
