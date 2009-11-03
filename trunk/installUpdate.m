//
//  installUpdate.m
//  Lizard
//
//  Created by ronan on 18/10/09.
//  Copyright 2009 darwinx86. All rights reserved.
//
#import "installUpdate.h"
@implementation installUpdate

@synthesize resourceKeys;
@synthesize volumeURLs;
@synthesize theicon;
@synthesize iconKey;
@synthesize rDisk;
@synthesize selectedDevice;
@synthesize selectedPath;
@synthesize diskType;
@synthesize diskUUID;
@synthesize diskROnly;
@synthesize rDiskXArray;
@synthesize rDiskX;
@synthesize theRootPath;
@synthesize warmImages;
@synthesize i386Path;
@synthesize boot;
@synthesize boot0;
@synthesize boot1h;
@synthesize dlWindow;
@synthesize opExtra;
@synthesize smPlist;
@synthesize vThemes;
@synthesize lExtensions;
@synthesize coExtensions;
@synthesize displayFinal;

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSAlertFirstButtonReturn) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSInformationalAlertStyle];
		
		//force le foirage du script si pas de variable
		if ([bBoot state]==NSOffState) {
			boot = @"null";
		}
		if ([bBoot0 state]==NSOffState) {
			boot0 = @"null";
		}
		if ([bBoot1h state]==NSOffState) {
			boot1h = @"null";
		}
		//envoi les données à l'helpertool (10)
		NSArray *args = [NSArray arrayWithObjects:helperToolPath, @"duplicate", boot0, boot1h, boot, selectedDevice, rDiskX,[i386Path stringByAppendingPathComponent:@"fdisk"],theRootPath, nil];
		
		NSTask *runInstall = [[NSTask alloc] init];
		[runInstall setLaunchPath:helperToolPath];
		[runInstall setArguments:args];
		[runInstall launch];
		[runInstall waitUntilExit];
		int status = [runInstall terminationStatus];
		if (status == 0) {
			[alert setMessageText:@"Installation Success"];
			[alert setInformativeText:@"Process appears terminated successfully."];
			[alert runModal];
			NSLog (@"install ok");
		}
		[runInstall release];
	}
	return;
}

- (void)awakeFromNib
{
	helperToolPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LizardHelperTool"] retain];
	[extraBox setHidden:YES];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)theView {
	
    return self.rDisk.count;
}
- (id)tableView:(NSTableView *)theView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
	
	int i = 0;
	NSString *theString;
	NSMutableArray *bankArray = [NSMutableArray arrayWithCapacity:15];
	NSMutableArray *stoleArray = [NSMutableArray arrayWithCapacity:15];
	NSMutableArray *warmArray = [NSMutableArray arrayWithCapacity:15];
	NSImage  *theImage;
	
	NSString *goodStatus = [[NSBundle mainBundle] pathForResource:@"status-available" ofType:@"tiff"];
	NSString *warningStatus = [[NSBundle mainBundle] pathForResource:@"status-idle" ofType:@"tiff"];
	NSString *noStatus = [[NSBundle mainBundle] pathForResource:@"status-away" ofType:@"tiff"];
	NSImage *warningIcon = [[NSImage alloc] initWithContentsOfFile:warningStatus];
	NSImage *errorIcon = [[NSImage alloc] initWithContentsOfFile:noStatus];
	NSImage *goodIcon = [[NSImage alloc] initWithContentsOfFile:goodStatus];
	
	//récupération des icones
	for (theString in displayFinal) {
		theImage = [[NSWorkspace sharedWorkspace]iconForFile:[displayFinal objectAtIndex:i]];
		[bankArray insertObject:theImage atIndex:i];
		[stoleArray insertObject:[[displayFinal objectAtIndex:i] lastPathComponent] atIndex:i];
		if ([[diskROnly objectAtIndex:i] isEqualToString:@"Yes"]) {
			[warmArray insertObject:errorIcon atIndex:i];
		}
		else if ([[diskUUID objectAtIndex:i] isEqualToString:@"Not bootable"]) {
			[warmArray insertObject:warningIcon atIndex:i];
		}
		else {
			[warmArray insertObject:goodIcon atIndex:i];
		}
		i++;    
	}
	//stockage
	iconKey = [NSMutableArray arrayWithArray:bankArray];
	resourceKeys = [NSMutableArray arrayWithArray:stoleArray];
	warmImages = [NSMutableArray arrayWithArray:warmArray];
	
	if ([[tableColumn identifier] isEqualToString:@"icon"]) {
		return [iconKey objectAtIndex:rowIndex];
	}
	if ([[tableColumn identifier] isEqualToString:@"path"]) {
		return [selectedPath objectAtIndex:rowIndex];
	}
	if ([[tableColumn identifier] isEqualToString:@"warm"]) {
		return [warmImages objectAtIndex:rowIndex];
	}
	if ([[tableColumn identifier] isEqualToString:@"mount"]) {
		return [displayFinal objectAtIndex:rowIndex];
	}
	//if ([[tableColumn identifier] isEqualToString:@"point"]) {
	//return [theicon objectAtIndex:rowIndex];
	//}
	return NULL;
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
	
}
- (id)init {
    
	if (self = [super init]) {
        
		self.theicon = [[NSWorkspace sharedWorkspace] mountedLocalVolumePaths];
		
		NSString *trootName = @"";
		NSString *rootName = @"";
		NSString *readOnly = @"";
		NSString *rOnly = @"";
		NSString *type = @"";
		NSString *UUID = @"";
		NSString *rDiskXx = @"";
		NSString *trDiskXx = @"";
		NSString *moreString;
		NSString *theName = @"";
		NSString *tTheName = @"";
		//NSString *finalRDisk;
		NSMutableArray *listItem = [NSMutableArray arrayWithCapacity:10];
		NSMutableArray *listName = [NSMutableArray arrayWithCapacity:10];
		NSMutableArray *listType = [NSMutableArray arrayWithCapacity:10];
		NSMutableArray *listUUID = [NSMutableArray arrayWithCapacity:10];
		NSMutableArray *listROnly= [NSMutableArray arrayWithCapacity:10];
		NSMutableArray *listRDiskX= [NSMutableArray arrayWithCapacity:10];
		NSMutableArray *myString = [NSMutableArray arrayWithCapacity:10];
		
		int i = 0;
		for (moreString in theicon)
		{
			NSArray *listItems;
			NSArray *itemsFirst;
			NSTask *diskutil=[[NSTask alloc] init];
			NSPipe *pipe=[[NSPipe alloc] init];
			NSFileHandle *handle;
			
			[diskutil setLaunchPath:@"/usr/sbin/diskutil"];
			[diskutil setArguments:[NSArray arrayWithObjects:@"info",[theicon objectAtIndex:i], nil]];
			[diskutil setStandardOutput:pipe];
			handle=[pipe fileHandleForReading];
			[diskutil launch];
			NSString *string=[[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSUTF8StringEncoding]; // convert NSData -> NSString
			
			listItems = [string componentsSeparatedByString:@" Device Identifier:"];
			itemsFirst = [string componentsSeparatedByString:@" Partition Type:"];
			itemsFirst = [[itemsFirst objectAtIndex:1] componentsSeparatedByString:@"Bootable:"];
			tTheName = [[itemsFirst objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			theName = [tTheName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			
			//NSLog (theName);
			if (![theName isEqualToString: @"None"]) { // rien ne s'afiche sinon
				//ajout du rdisk dans une array
				if ([listItems objectAtIndex:0])
				{
					//supprime l'espace a l'entrée
					listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Device Node:"];
					trootName = [[listItems objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
					rootName = [trootName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
					[listItem insertObject:rootName atIndex:0 + i];
					if ([rootName isEqualToString: @""]) { // rien ne s'afiche sinon
						[listItem insertObject:@"Untitled" atIndex:0 + i];
						rootName = @"Untitled";
					}
					self.rDisk = [NSMutableArray arrayWithArray:listItem];
					
				}
				// Volume Name
				listItems = [string componentsSeparatedByString:@"Volume Name:"];
				if ([listItems objectAtIndex:0]) {
					if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_5) { //modifications dans diskutil
						listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Escaped with Unicode:"];
					}
					else {
						listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Mount Point:"];
					}
					readOnly = [[listItems objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					[listName insertObject:readOnly atIndex:i];
					if ([readOnly isEqualToString: @""]) { // rien ne s'afiche sinon
						[listName insertObject:@"Untitled" atIndex:i];
						readOnly = @"Untitled";
					}
					self.selectedPath = [NSMutableArray arrayWithArray:listName];
				}
				
				//System files
				listItems = [string componentsSeparatedByString:@"File System:"];
				if ([listItems objectAtIndex:0]) {
					if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_5) {
						listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Type:"];
					}
					else {
						listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Owners:"];
					}
					type = [[listItems objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					[listType insertObject:type atIndex:i];
					if ([type isEqualToString: @""]) { // rien ne s'afiche sinon
						[listType insertObject:@"Unknown" atIndex:i];
						type = @"Unknown";
					}
					self.diskType = [NSMutableArray arrayWithArray:listType];
				}
				
				//Bootable
				listItems = [string componentsSeparatedByString:@"Bootable:"];
				if ([listItems objectAtIndex:0]) {
					listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Media Type:"];
					UUID = [[listItems objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					[listUUID insertObject:UUID atIndex:i];
					if ([UUID isEqualToString: @""]) { // rien ne s'afiche sinon
						[listUUID insertObject:@"Unknown" atIndex:i];
						UUID = @"Unknown";
					}
					self.diskUUID = [NSMutableArray arrayWithArray:listUUID];
				}
				
				//readOnly
				if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_5) {
					listItems = [string componentsSeparatedByString:@"Read-Only Volume:"];
				}
				else {
					listItems = [string componentsSeparatedByString:@"Read Only:"];
				}
				if ([listItems objectAtIndex:0]) {
					listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Ejectable:"];
					rOnly = [[listItems objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					[listROnly insertObject:rOnly atIndex:i];
					if ([rOnly isEqualToString: @""]) { // rien ne s'afiche sinon
						[listROnly insertObject:@"Unknown" atIndex:i];
						rOnly = @"Unknown";
					}
					self.diskROnly = [NSMutableArray arrayWithArray:listROnly];
				}
				
				//rdiskX
				listItems = [string componentsSeparatedByString:@"Part Of Whole:"];
				if ([listItems objectAtIndex:0]) {
					listItems = [[listItems objectAtIndex:1] componentsSeparatedByString:@"Device / Media Name:"];
					trDiskXx = [[listItems objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					rDiskXx = [trDiskXx stringByReplacingOccurrencesOfString:@"\n" withString:@""];
					[listRDiskX insertObject:rDiskXx atIndex:i];
					if ([rDiskXx isEqualToString: @""]) { // rien ne s'afiche sinon
						[listRDiskX insertObject:@"Unknown" atIndex:i];
						rDiskXx = @"Unknown";
					}
					self.rDiskXArray = [NSMutableArray arrayWithArray:listRDiskX];
				}
				[myString insertObject:[theicon objectAtIndex:i] atIndex:i];
				self.displayFinal =  [NSMutableArray arrayWithArray:myString];
				[diskutil release];
				i++;
			}
		}
	}
	return self;
	//NSLog ([diskROnly description]);
}

- (IBAction)selectDevice:(id)sender {
	//recuperation de la valeure du rdisk
	self.selectedDevice = [rDisk objectAtIndex:[theView selectedRow]];
	self.rDiskX = [rDiskXArray objectAtIndex:[theView selectedRow]];
	[theFormat setStringValue:[diskType objectAtIndex:[theView selectedRow]]];
	[theUUID setStringValue:[diskUUID objectAtIndex:[theView selectedRow]]];
	[theROnly setStringValue:[diskROnly objectAtIndex:[theView selectedRow]]];
	[theRDisk setStringValue:[rDisk objectAtIndex:[theView selectedRow]]];
}

- (void)loopAccrosVerion {
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSString *mExtensions = [self.opExtra stringByAppendingPathComponent:@"Extensions"];
	NSString *lPath;
	NSDirectoryEnumerator* c;
	NSString* fileName;
	NSString* fullPath;
	int i = 0;
	self.lExtensions = [NSMutableArray arrayWithCapacity:10];
	
	if ([theManager fileExistsAtPath:mExtensions]) {
		if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_5) {
			lPath = [mExtensions stringByAppendingPathComponent:@"10.6"];
			c = [theManager enumeratorAtPath:lPath];
		}
		else {
			lPath = [mExtensions stringByAppendingPathComponent:@"10.5"];
			c = [theManager enumeratorAtPath:lPath];
		}
		while ( fileName = [c nextObject] )
		{
			fullPath = [lPath stringByAppendingPathComponent:fileName];
			if ([fullPath hasSuffix:@"kext"]) {
				[self.lExtensions insertObject:fullPath atIndex:i];
				i++;
			}
		}
		//NSLog([lExtensions description]);
	}
	[pool release];
}

- (void)loopAccrosExtensions {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSString *mExtensions = [self.opExtra stringByAppendingPathComponent:@"Extensions"];
	NSString *colPath = [mExtensions stringByAppendingPathComponent:@"Common"];
	NSDirectoryEnumerator* c;
	NSString* fileName;
	NSString* fullPath;
	int i = 0;
	self.coExtensions = [NSMutableArray arrayWithCapacity:10];
	
	//extensions Commom
	if ([theManager fileExistsAtPath:colPath]) {
		c = [theManager enumeratorAtPath:colPath];
		while ( fileName = [c nextObject] )
		{
			fullPath = [colPath stringByAppendingPathComponent:fileName];
			if ([fullPath hasSuffix:@"kext"]) {
				[self.coExtensions insertObject:fullPath atIndex:i];
				i++;
			}
		}
		//NSLog([coExtensions description]);
	}
	[pool release];
}
- (void)loopAccrosThemes {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSString *themesPath = [opExtra stringByAppendingPathComponent:@"Themes"];
	NSDirectoryEnumerator* c;
	NSString* fileName;
	NSString* fullPath;
	int i = 0;
	BOOL isDir = YES;
	self.vThemes = [NSMutableArray arrayWithCapacity:10];
	
	//themes
	if ([theManager fileExistsAtPath:themesPath]) {
		c = [theManager enumeratorAtPath:themesPath];
		while ( fileName = [c nextObject] )
		{
			fullPath = [themesPath stringByAppendingPathComponent:fileName];
			if ([theManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
				[self.vThemes insertObject:fullPath atIndex:i];
				i++;
			}
		}
		//NSLog([vThemes description]);
	}
	[pool release];
}
- (void)openPanelWillEnd:(id)panel returnCode:(NSInteger)code contextInfo:(void *)userInfo {
	
	if (code == NSAlertDefaultReturn) {
		BOOL isDir;
		NSString *processOkStatus = [[NSBundle mainBundle] pathForResource:@"accept" ofType:@"png"];
		NSString *processKoStatus = [[NSBundle mainBundle] pathForResource:@"block" ofType:@"png"];
		NSImage *processOk = [[NSImage alloc] initWithContentsOfFile:processOkStatus];
		NSImage *processKo = [[NSImage alloc] initWithContentsOfFile:processKoStatus];
		NSFileManager *theManager = [NSFileManager defaultManager];
		NSString *sourcesFolder = [panel filename];
		self.i386Path = [sourcesFolder stringByAppendingPathComponent:@"i386"];
		self.opExtra = [sourcesFolder stringByAppendingPathComponent:@"Optional Extras"];
		NSString *mExtensions = [opExtra stringByAppendingPathComponent:@"Extensions"];
		NSString *themesPath = [opExtra stringByAppendingPathComponent:@"Themes"];
		self.smPlist = [opExtra stringByAppendingPathComponent:@"smbios.plist"];
		//NSLog(smPlist);
		
		//extensions Osversion
		self.boot0 = [i386Path stringByAppendingPathComponent:@"boot0"];
		self.boot1h = [i386Path stringByAppendingPathComponent:@"boot1h"];
		self.boot = [i386Path stringByAppendingPathComponent:@"boot"];
		self.theRootPath = [[theicon objectAtIndex:[theView selectedRow]] stringByAppendingPathComponent:@"boot"];
		//NSLog (theRootPath);
		//appel des loops
		[NSThread detachNewThreadSelector:@selector(loopAccrosVerion) toTarget:self withObject:self];
		[NSThread detachNewThreadSelector:@selector(loopAccrosExtensions) toTarget:self withObject:self];
		[NSThread detachNewThreadSelector:@selector(loopAccrosThemes) toTarget:self withObject:self];
		[extraBox setTitle:[theManager displayNameAtPath:sourcesFolder]];
		
		
		if ([theManager fileExistsAtPath:boot isDirectory:&isDir] && ! isDir) {
			[bBoot setState:1];
			[bBoot setEnabled:YES];
			[iBoot setImage:processOk];
			[checkBoot setStringValue:@""];
		}
		else {
			[iBoot setImage:processKo];
			[checkBoot setStringValue:@": boot missing!"];
			[bBoot setState:0];
			[bBoot setEnabled:NO];
			
		}
		if ([theManager fileExistsAtPath:boot0 isDirectory:&isDir] && ! isDir) {
			[bBoot0 setState:1];
			[bBoot0 setEnabled:YES];
			[iBoot0 setImage:processOk];
			[checkBoot0 setStringValue:@""];
		}
		else {
			[iBoot0 setImage:processKo];
			[checkBoot0 setStringValue:@": boot0 missing!"];
			[bBoot0 setState:0];
			[bBoot0 setEnabled:NO];
		}
		if ([theManager fileExistsAtPath:boot1h isDirectory:&isDir] && ! isDir) {
			[bBoot1h setState:1];
			[bBoot1h setEnabled:YES];
			[iBoot1h setImage:processOk];
			[checkBoot1h setStringValue:@""];
		}
		else {
			[iBoot1h setImage:processKo];
			[checkBoot1h setStringValue:@": boot1h missing!"];
			[bBoot1h setState:0];
			[bBoot1h setEnabled:NO];
		}
		
		if ([theManager fileExistsAtPath:smPlist]) {
			[bSmbios setEnabled:YES];
			[iSmbios setImage:processOk];
		}
		else {
			[iSmbios setImage:processKo];
			[bSmbios setEnabled:NO];
			[bSmbios setState:0];
		}
		if ([theManager fileExistsAtPath:themesPath]) {
			[bThemes setEnabled:YES];
			[iThemes setImage:processOk];
		}
		else {
			[iThemes setImage:processKo];
			[bThemes setEnabled:NO];
			[bThemes setState:0];
		}
		if ([theManager fileExistsAtPath:mExtensions]) {
			[bExtensions setEnabled:YES];
			[iExtensions setImage:processOk];
		}
		else {
			[iExtensions setImage:processKo];
			[bExtensions setEnabled:NO];
			[bExtensions setState:0];
		}
		
	}
	return;
	
}

- (IBAction)selectFolder:(id)sender {
	
	if (! selectedDevice) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert setMessageText:@"No device selected!"];
        [alert setInformativeText:@"Please, select device before openning chameleon's bin folder"];
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		
	}
	else {
		//NSFileManager *theManager = [NSFileManager defaultManager];
		NSOpenPanel *openPanel = [NSOpenPanel openPanel];
		[openPanel setTitle:@"Select Chameleon Folder"];
		[openPanel setCanChooseFiles:NO];
		[openPanel setCanChooseDirectories:YES];

		[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(openPanelWillEnd:returnCode:contextInfo:) contextInfo:NULL];
		
		if ([extraBox isHidden]) {
			NSWindow *window = [sender window];
			NSRect frame = [window frame];
			CGFloat sizeChange = [extraBox frame].size.height + 20;
			[extraBox setHidden:NO];
			frame.size.height += sizeChange;
			frame.origin.y -= sizeChange;
			[window setFrame:frame display:YES animate:YES];
			
		}
		
	}
}

- (IBAction)serverUpdate:(id)sender {
	if (![dlWindow isVisible]) {
		[dlWindow makeKeyAndOrderFront:self];
	}
	else {
		[dlWindow orderOut:nil];
	}
}
- (IBAction)launchInstall:(id)sender
{
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSWarningAlertStyle];
	NSString *readOnlycheck = [theROnly stringValue];
	
	if ((! selectedDevice)  || (! i386Path)) {
		if ((!selectedDevice) && (i386Path)) {
			[alert setMessageText:@"No device selected!"];
			[alert setInformativeText:@"Please, select device before openning chameleon's i386 folder"];
		}
		else if ((selectedDevice) && (! i386Path)) {
			[alert setMessageText:@"Chameleon's folder not specified"];
			[alert setInformativeText:@"Please, select a folder before running installation"];
		}
		else {
			[alert setMessageText:@"Chameleon's folder and device not specified"];
			[alert setInformativeText:@"Please, complete those informations before running installation"];
		}
	}
	else if ([readOnlycheck isEqualToString:@"Yes"]) {
		[alert setMessageText:[NSString stringWithFormat:@"%@ %@",[selectedPath objectAtIndex:[theView selectedRow]],  @"is a Read-Only Device"]];
		[alert setInformativeText:@"Installation Aborded"];
	}
	else if (([bBoot state]==NSOffState) && ([bBoot0 state]==NSOffState) && ([bBoot1h state]==NSOffState)){
		[alert setMessageText:@"Nothing to install!"];
		[alert setInformativeText:@"Please, select at least one file"];
	}
	else {
		[alert addButtonWithTitle:@"Install"];
		[alert addButtonWithTitle:@"Cancel"];
		[alert setMessageText:@"Chameleon installation"];
		[alert setInformativeText:[NSString stringWithFormat:@"You really want to install Chameleon on %@ %@ %@ %@",[selectedPath objectAtIndex:[theView selectedRow]], @"(", [rDisk objectAtIndex:[theView selectedRow]], @") ?"]];     
	}
	[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)installExtra:(id)sender {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSInformationalAlertStyle];
	//chemins pour la copie des fichiers
	NSString *rootPartition = [theicon objectAtIndex:[theView selectedRow]];
	NSString *extraFolder = [rootPartition stringByAppendingPathComponent:@"Extra"];
	NSString *themesFolder = [extraFolder stringByAppendingPathComponent:@"Themes"];
	NSString *extFolder = [extraFolder stringByAppendingPathComponent:@"Extensions"];
	//test de copie des fichiers
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSError *copyError;
	NSString *contentString;
	
	if ([[theROnly stringValue] isEqualToString:@"Yes"]) {
		[alert setMessageText:[NSString stringWithFormat:@"%@ %@",[selectedPath objectAtIndex:[theView selectedRow]],  @"is a Read-Only Device"]];
		[alert setInformativeText:@"Installation Aborded"];
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		
	}
	else {
		[progressIndicator startAnimation: self];
		int f = 0;
		if (![theManager fileExistsAtPath:extraFolder]) {
			[theManager createDirectoryAtPath:extraFolder attributes:nil];
		}
		if (![theManager fileExistsAtPath:themesFolder]) {
			[theManager createDirectoryAtPath:themesFolder attributes:nil];
		}
		if (![theManager fileExistsAtPath:extFolder]) {
			[theManager createDirectoryAtPath:extFolder attributes:nil];
		}
		if ([bExtensions state]==NSOnState) {
			for (contentString in coExtensions) {
				[theManager copyItemAtPath:[coExtensions objectAtIndex:f] toPath:[extFolder stringByAppendingPathComponent:[contentString lastPathComponent]] error:&copyError];
				f++;
			}
			f = 0;
			for (contentString in lExtensions) {
				[theManager copyItemAtPath:[lExtensions objectAtIndex:f] toPath:[extFolder stringByAppendingPathComponent:[contentString lastPathComponent]] error:&copyError];
				f++;
			}
		}
		f = 0;
		if ([bThemes state]==NSOnState) {
			for (contentString in vThemes) {
				[theManager copyItemAtPath:[vThemes objectAtIndex:f] toPath:[themesFolder stringByAppendingPathComponent:[contentString lastPathComponent]] error:&copyError];
				f++;
			}
		}
		if ([bSmbios state]==NSOnState) {
			[theManager copyItemAtPath:self.smPlist toPath:[extraFolder stringByAppendingPathComponent:[self.smPlist lastPathComponent]] error:&copyError];
		}
		[progressIndicator stopAnimation: self];
		//NSLog ([coExtensions description]);
		if (copyError)
			[[NSAlert alertWithError:copyError] beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		
		else if (([bSmbios state]==NSOffState) && ([bExtensions state]==NSOffState) && ([bThemes state]==NSOffState)){
			[alert setMessageText:@"Nothing to install!"];
			[alert setInformativeText:@"Please, select at least one option"];
			[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		}
		else {
			[alert setMessageText:@"Files installed Succesfully"];
			[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		}
		[alert release];
	}
}

- (void)dealloc 
{ 
    [super dealloc];
}
@end