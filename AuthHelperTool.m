//
//  AuthHelperTool.m
//  Lizard
//
//  Created by ronan on 18/10/09.
//  Copyright 2009 darwinx86. All rights reserved.
//
// should be renamed AuthHelperTool then copied in resources folder after build

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"AuthHelperTool started");
	NSLog([NSString stringWithFormat:@"%d",argc] );
	
	// Nomber d'arguments envoyer par le IBAction
	if (argc == 10)
	{
		// Hasn't been called as root yet.
		NSLog(@"AuthHelperTool executing self-repair");
		
		// Paraphrased from http://developer.apple.com/documentation/Security/Conceptual/authorization_concepts/03authtasks/chapter_3_section_4.html
		OSStatus myStatus;
		AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
		AuthorizationRef myAuthorizationRef;
		
		myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
		if (myStatus != errAuthorizationSuccess)
			return myStatus;
		
		AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
		AuthorizationRights myRights = {1, &myItems};
		myFlags = kAuthorizationFlagDefaults |
		kAuthorizationFlagInteractionAllowed |
		kAuthorizationFlagPreAuthorize |
		kAuthorizationFlagExtendRights;
		
		myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, NULL, myFlags, NULL );
		if (myStatus != errAuthorizationSuccess)
			return myStatus;
		
		char *myToolPath = argv[1];
		char *myArguments[] = {argv[1], "--self-repair", argv[2], argv[3],argv[4],argv[5],argv[6],argv[7],argv[8],argv[9], NULL};
		FILE *myCommunicationsPipe = NULL;
		
		myFlags = kAuthorizationFlagDefaults;
		myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, myToolPath, myFlags, myArguments, &myCommunicationsPipe);
		NSLog(@"AuthHelperTool called AEWP");
	}
	else
	{
		//Nombre d'arguments déclarés dans myArguments plus haut
		if (argc == 11)
		{
			NSString *command = [NSString stringWithCString:argv[3] encoding:NSUTF8StringEncoding];
			NSString *boot0 = [NSString stringWithCString:argv[4] encoding:NSUTF8StringEncoding];
			NSString *boot1h = [NSString stringWithCString:argv[5] encoding:NSUTF8StringEncoding];
			NSString *boot = [NSString stringWithCString:argv[6] encoding:NSUTF8StringEncoding];
			NSString *selectedDevice = [NSString stringWithCString:argv[7] encoding:NSUTF8StringEncoding];
			NSString *rDiskX = [NSString stringWithCString:argv[8] encoding:NSUTF8StringEncoding];
			NSString *fdiskPath = [NSString stringWithCString:argv[9] encoding:NSUTF8StringEncoding];
			NSString *theRootPath = [NSString stringWithCString:argv[10] encoding:NSUTF8StringEncoding];
			
			//NSString *theTest = [NSString stringWithCString:argv[4]];
			NSLog(@"AuthHelperTool sent command %@", command);
			
			if ([command isEqualToString:@"duplicate"])
			{
				NSLog(@"AuthHelperTool executing %@", command);
				
				// setuid pour executer sudo.
				setuid(0);
				NSArray *fdiskArgs = [NSArray arrayWithObjects: fdiskPath, @"-f", boot0, @"-u", @"-y", [@"/dev/r" stringByAppendingString:rDiskX], nil];
				[NSTask launchedTaskWithLaunchPath:@"/usr/bin/sudo" arguments:fdiskArgs];
				NSLog(@"done with %@: ?", fdiskArgs);
				sleep(2);
				NSArray *ddArgs = [NSArray arrayWithObjects: @"dd", [@"if="stringByAppendingString:boot1h], [@"of=/dev/r" stringByAppendingString:selectedDevice], nil];
				[NSTask launchedTaskWithLaunchPath:@"/usr/bin/sudo" arguments:ddArgs];
				NSLog(@"done with %@: ?", ddArgs);
				sleep(2);
				NSArray *cpArgs = [NSArray arrayWithObjects: @"cp", boot, theRootPath, nil];
				[NSTask launchedTaskWithLaunchPath:@"/usr/bin/sudo" arguments:cpArgs];
				NSLog(@"done with %@: ?", cpArgs);
			}
			return 1;
		}
	}
	//NSLog(@"AuthHelperTool exiting");
	
	[pool release];
	return 0;
}
