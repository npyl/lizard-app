//
//  smbioshelp.m
//  Lizard
//
//  Created by ronan on 12/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "smbioshelp.h"


@implementation smbioshelp

- (IBAction)smbiosHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"smbiosHelp"
                                               inBook:@"Lizard Help"];
}
@end
