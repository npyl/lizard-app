//
//  cdController.m
//  Lizard
//
//  Created by ronan on 03/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IKBBrowseritem.h"
#import "cdController.h"

@implementation cdController

@synthesize kernelPath;
@synthesize kernelFlags;
@synthesize graphicsEnabler;
@synthesize timeOut;
@synthesize ethernetBuiltIn;
@synthesize selectedTheme;
@synthesize USBBusFix;
@synthesize EHCIacquire;
@synthesize UHCIreset;
@synthesize Wake;
@synthesize ForceWake;
@synthesize WakeImage;
@synthesize DropSSDT;
@synthesize DSDT;
@synthesize SMBIOSdefaults;
@synthesize Rescan;
@synthesize RescanPrompt;
@synthesize GUI;
@synthesize InstantMenu;
@synthesize DefaultPartition;
@synthesize setSmbioPath;
@synthesize quietBoot;
@synthesize vBios;
@synthesize bootBanner;
@synthesize legacyLogo;
@synthesize videoROM;
@synthesize forceHPET;
@synthesize SLarch;
@synthesize devProps;
@synthesize graphicsMode;

@synthesize browserData;
NSString *bootcdPath = @"/tmp/isodir";
NSString *bootFinalPath = @"/tmp/newiso";
NSString *extraFinalPath = @"/tmp/newiso/Extra";
NSString *themeFinalPath = @"/tmp/newiso/Extra/Themes";
NSString *prebootPath = @"/tmp/newiso/Extra/Preboot";
NSString *prebootDirPath = @"/tmp/newiso/Extra/Preboot/Extra";
//cdboot init
- (id)init 
{ 
    [super init]; 
    if (self) { 
        cdbootIsRunning = FALSE;
        cdbootPipe = nil; 
        cdbootTask = nil; 
    } 
    return self; 
} 
//cdboot part
- (void)dealloc 
{ 
    if (cdbootPipe) { [cdbootPipe release]; cdbootPipe = nil; } 
    if (cdbootTask) { [cdbootTask release]; cdbootTask = nil; } 
    [super dealloc]; 
} 

- (void)awakeFromNib
{	
	//cretation du repertoire temporaire
	NSFileManager *bootcdDirectory = [NSFileManager defaultManager];
	if ([bootcdDirectory fileExistsAtPath:bootcdPath]) {
		
		[bootcdDirectory removeFileAtPath:bootcdPath handler:nil];
		[bootcdDirectory removeFileAtPath:bootFinalPath handler:nil];
		[bootcdDirectory  createDirectoryAtPath:bootcdPath attributes:nil];
		[bootcdDirectory  createDirectoryAtPath:bootFinalPath attributes:nil];
	}	
	else {
		[bootcdDirectory  createDirectoryAtPath:bootcdPath attributes:nil];
		[bootcdDirectory  createDirectoryAtPath:bootFinalPath attributes:nil];
		
	}
	
	browserData = [[NSMutableArray alloc] initWithCapacity:10];
	
	[browserView setDelegate:self];
	[browserView setDataSource:self];
	[browserView setDraggingDestinationDelegate:self];
	
	//bouton avancé
    NSInteger dtState = [[[NSUserDefaults standardUserDefaults] valueForKey:@"disclosureTriangleState"] intValue];
    if (dtState == NSOffState) {
        [self disclosureTrianglePressed:disclosureTriangle];
    }
}
- (IBAction)disclosureTrianglePressed:(id)sender {
    NSWindow *window = [sender window];
    NSRect frame = [window frame];
    CGFloat sizeChange = [extraBox frame].size.height + 3;
    switch ([sender state]) {
        case NSOnState:
            [extraBox setHidden:NO];
            frame.size.height += sizeChange;
            frame.origin.y -= sizeChange;
            break;
        case NSOffState:
            [extraBox setHidden:YES];
            frame.size.height -= sizeChange;
            frame.origin.y += sizeChange;
            break;
        default:
            break;
    }
    [window setFrame:frame display:YES animate:YES];
}

#pragma mark - 
#pragma mark Cover Flow Data Source Methods
- (NSUInteger) numberOfItemsInImageFlow:(id) aBrowser
{
	return [browserData count];
}

- (id) imageFlow:(id) aBrowser itemAtIndex:(NSUInteger)index
{
	return [browserData objectAtIndex:index];
}

#pragma mark - 
#pragma mark Browser Drag and Drop Methods
- (unsigned int)draggingEntered:(id <NSDraggingInfo>)sender
{
	
	if([sender draggingSource] != self){
		NSPasteboard *pb = [sender draggingPasteboard];
		NSString * type = [pb availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]];
		
		if(type != nil){
			return NSDragOperationEvery;
		}
	}
	return NSDragOperationNone;
}

- (unsigned int)draggingUpdated:(id <NSDraggingInfo>)sender
{
	return NSDragOperationEvery;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
				[cdConfirm setImage: nil];
	return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{

	NSArray *files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
	NSFileManager *theManager = [NSFileManager defaultManager];
	
	for(id file in files){

		[progressIndicator startAnimation: self];
		NSImage * image = [[NSWorkspace sharedWorkspace] iconForFile:file];
		
		//defini le chmein
		NSString *filePath = [theManager displayNameAtPath:file];
		NSString *imageID = [file lastPathComponent];
		IKBBrowserItem *item = [[IKBBrowserItem alloc] initWithImage:image imageID:imageID];
		[browserData addObject:item];
		[browserView reloadData];
		
		//copier le fichier au bon endroit
		NSString *tempFolder = [ @"/tmp/isodir" stringByAppendingPathComponent:filePath ];
		
		//remplace le fichier et l'icone actuelle
		if ([theManager fileExistsAtPath:tempFolder]) {
			[browserData removeObject:item];
			[browserView reloadData];
			[theManager removeFileAtPath:tempFolder handler:nil];
		}
			[theManager copyPath:file toPath:tempFolder handler:nil];
				[progressIndicator stopAnimation: self];
	}
	if([browserData count] > 0) {
		return YES;
	}
	return NO;
}

// tout supprimer
- (IBAction)removeAll:(id)sender 
{
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSString *tempFolder = @"/tmp/isodir/";
		NSString *extraFolder = @"/tmp/newiso/Extra";
	[theManager removeFileAtPath:tempFolder handler:nil];
	[theManager removeFileAtPath:extraFolder handler:nil];
	
	// supprime les images une par une
	while ([browserData count] > 0) {
		[browserData removeObjectAtIndex:0];
	}
	// rafraichi l'affichage
	[browserView reloadData];
	[cdConfirm setImage: nil];
	[theManager createDirectoryAtPath:tempFolder attributes:nil]; //recreation du dossier
	
}

//revoir
- (void)concludeDragOperation:(id < NSDraggingInfo >)sender
{
}


//script de generateur d'ISO
- (IBAction)createCdBoot:(id)sender
{	
	if (cdbootIsRunning) { 
        cdbootIsRunning = FALSE; 
        [cdbootButton setEnabled:NO];
	} 
	else {
		//cretation du repertoire temporaire
		NSFileManager *bootcdDirectory = [NSFileManager defaultManager];
		NSString *extraFolder = @"/tmp/newiso/Extra";
		//Nettoyage
			[bootcdDirectory removeFileAtPath:extraFolder handler:nil];
			[bootcdDirectory  createDirectoryAtPath:extraFinalPath attributes:nil];
			[bootcdDirectory  createDirectoryAtPath:prebootPath attributes:nil];
			[bootcdDirectory  createDirectoryAtPath:prebootDirPath attributes:nil];
		
		BOOL DisableSoundState;
		DisableSoundState = [[NSUserDefaults standardUserDefaults] boolForKey:@"disableSound"];
		NSString *vide = @"";
		NSError *fileError;
		NSString *processOkStatus = [[NSBundle mainBundle] pathForResource:@"block" ofType:@"png"];
		NSImage *processOk = [[NSImage alloc] initWithContentsOfFile:processOkStatus];
		NSFileHandle *theFileHandle;
		NSFileManager *theManager = [NSFileManager defaultManager];
		//preparer la copie du cdboot
		NSString *cdbootFile = [[NSBundle mainBundle] pathForResource:@"cdboot" ofType:nil];
		NSString *tempISO = @"/tmp/isodir/cdboot";
		//copie du cdboot
		[theManager copyPath:cdbootFile toPath:tempISO handler:nil];
		
	
		
		cdbootTask = [[NSTask alloc] init]; 
		cdbootPipe = [[NSPipe alloc] init];
		theFileHandle = [cdbootPipe fileHandleForReading];
		NSSound *sound;
		if (cdbootTask && cdbootPipe && theFileHandle) {
			// contruire le dictionnaire
			NSString *errorTesc = nil;
			NSPropertyListFormat format;
			
			// com.apple.boot.plist
			NSString *isoBootPath = @"/tmp/isodir/com.apple.Boot.plist";
			NSString *plistpreBootPath = @"/tmp/com.apple.Boot.plist";
			NSString *machkernelPath = @"/tmp/isodir/mach_kernel";
			NSString *thesmbiosPath = @"/tmp/isodir/smbios.plist";
			NSString *dsdtPath = @"/tmp/isodir/dsdt.aml";
			NSString *DSDTPath = @"/tmp/isodir/DSDT.aml";
			NSString *romPath = @"/tmp/isodir/NVIDIA.ROM";
			system("chmod -R 777 /tmp/isodir"); //modification des autojrisations pour le script sinon blocage
			NSData *isoBootXML = [[NSFileManager defaultManager] contentsAtPath:isoBootPath];
			NSMutableDictionary *isoTemp = (NSMutableDictionary *)[NSPropertyListSerialization
																	propertyListFromData:isoBootXML
																	mutabilityOption:NSPropertyListMutableContainersAndLeaves
																	format:&format errorDescription:&errorTesc];
			
			self.graphicsMode = [isoTemp objectForKey:@"Graphics Mode"];
			self.kernelPath = [isoTemp objectForKey:@"Kernel"];
			self.kernelFlags = [isoTemp objectForKey:@"Kernel Flags"];
			self.graphicsEnabler = [isoTemp objectForKey:@"GraphicsEnabler"];
			self.timeOut = [isoTemp objectForKey:@"TimeOut"];
			self.ethernetBuiltIn = [isoTemp objectForKey:@"EthernetBuiltIn"];
			self.selectedTheme = [isoTemp objectForKey:@"Theme"];
			self.USBBusFix = [isoTemp objectForKey:@"USBBusFix"];
			self.EHCIacquire = [isoTemp objectForKey:@"EHCIacquire"];
			self.UHCIreset = [isoTemp objectForKey:@"UHCIreset"];
			self.Wake = [isoTemp objectForKey:@"Wake"];
			self.ForceWake = [isoTemp objectForKey:@"ForceWake"];
			self.WakeImage = [isoTemp objectForKey:@"WakeImage"];
			self.DropSSDT = [isoTemp objectForKey:@"DropSSDT"];
			self.DSDT = [isoTemp objectForKey:@"DSDT"];
			self.SMBIOSdefaults = [isoTemp objectForKey:@"SMBIOSdefaults"];
			self.RescanPrompt = [isoTemp objectForKey:@"Rescan Prompt"];
			self.GUI = [isoTemp objectForKey:@"GUI"];
			self.InstantMenu = [isoTemp objectForKey:@"Instant Menu"];
			self.DefaultPartition = [isoTemp objectForKey:@"Default Partition"];
			self.setSmbioPath = [isoTemp objectForKey:@"SMBIOS"];
			self.quietBoot = [isoTemp objectForKey:@"Quiet Boot"];
			self.vBios = [isoTemp objectForKey:@"VBIOS"];
			self.bootBanner = [isoTemp objectForKey:@"Boot Banner"];
			self.legacyLogo = [isoTemp objectForKey:@"Legacy Logo"];
			self.videoROM = [isoTemp objectForKey:@"VideoROM"];
			self.forceHPET = [isoTemp objectForKey:@"forceHPET"];
			self.SLarch = [isoTemp objectForKey:@"arch"];
			self.devProps = [isoTemp objectForKey:@"device-properties"];
			
			[isoTemp setObject:@"Yes" forKey:@"Rescan"];
			
			if ([theManager fileExistsAtPath:thesmbiosPath]) {
				[isoTemp setObject:@"rd(0,0)/Extra/smbios.plist" forKey:@"SMBIOS"];
			}
			else if (setSmbioPath) {
				[isoTemp setObject:vide forKey:@"SMBIOS"];
			}
			
			if ([theManager fileExistsAtPath:machkernelPath]) {
				[isoTemp setObject:@"rd(0,0)/Extra/mach_kernel" forKey:@"Kernel"];
			}
			else if (kernelPath) {
				[isoTemp setObject:kernelPath forKey:@"Kernel"];
			}
			
			if ([theManager fileExistsAtPath:dsdtPath]) {
				[isoTemp setObject:@"rd(0,0)/Extra/dsdt.aml" forKey:@"DSDT"];
			}
			else if ([theManager fileExistsAtPath:DSDTPath]) {
				[isoTemp setObject:@"rd(0,0)/Extra/DSDT.aml" forKey:@"DSDT"];
			}
			else if (DSDT) {
				[isoTemp setObject:vide forKey:@"DSDT"];
			}
			
			if ([theManager fileExistsAtPath:romPath]) {
				[isoTemp setObject:@"rd(0,0)/Extra/NVIDIA.ROM" forKey:@"VideoROM"];
			}
			else if (videoROM) {
				[isoTemp setObject:vide forKey:@"VideoROM"];
			}

			if (graphicsMode)
				[isoTemp setObject:graphicsMode forKey:@"Graphics Mode"];			
			if (kernelFlags)
				[isoTemp setObject:kernelFlags forKey:@"Kernel Flags"];			
			if (graphicsEnabler)
				[isoTemp setObject:graphicsEnabler forKey:@"GraphicsEnabler"];			
			if (quietBoot)
				[isoTemp setObject:quietBoot forKey:@"Quiet Boot"];			
			if (ethernetBuiltIn)
				[isoTemp setObject:ethernetBuiltIn forKey:@"EthernetBuiltIn"];			
			if (selectedTheme)
				[isoTemp setObject:selectedTheme forKey:@"Theme"];			
			if (USBBusFix)
				[isoTemp setObject:USBBusFix forKey:@"USBBusFix"];			
			if (UHCIreset)
				[isoTemp setObject:UHCIreset forKey:@"UHCIreset"];			
			if (Wake)
				[isoTemp setObject:Wake forKey:@"Wake"];			
			if (ForceWake)
				[isoTemp setObject:ForceWake forKey:@"ForceWake"];			
			if (WakeImage)
				[isoTemp setObject:WakeImage forKey:@"WakeImage"];			
			if (DropSSDT)
				[isoTemp setObject:DropSSDT forKey:@"DropSSDT"];			
			if (SMBIOSdefaults)
				[isoTemp setObject:SMBIOSdefaults forKey:@"SMBIOSdefaults"];			
			if (RescanPrompt)
				[isoTemp setObject:RescanPrompt forKey:@"Rescan Prompt"];			
			if (([disableUI state]==NSOnState))
				[isoTemp setObject:@"No" forKey:@"GUI"];						
			if (InstantMenu)
				[isoTemp setObject:InstantMenu forKey:@"Instant Menu"];
			if (DefaultPartition)
				[isoTemp setObject:DefaultPartition forKey:@"Default Partition"];
			if (EHCIacquire)
				[isoTemp setObject:EHCIacquire forKey:@"EHCIacquire"];
			if (vBios)
				[isoTemp setObject:vBios forKey:@"VBIOS"];
			if (bootBanner)
				[isoTemp setObject:bootBanner forKey:@"Boot Banner"];
			if (legacyLogo)
				[isoTemp setObject:legacyLogo forKey:@"Legacy Logo"];
			if (timeOut)
				[isoTemp setObject:timeOut forKey:@"TimeOut"];			
			if (forceHPET)
				[isoTemp setObject:forceHPET forKey:@"forceHPET"];
			if (SLarch)
				[isoTemp setObject:SLarch forKey:@"arch"];
			if (devProps)
				[isoTemp setObject:devProps forKey:@"device-properties"];
			
			NSData *isoBootData = [NSPropertyListSerialization dataFromPropertyList:isoTemp
																			   format:NSPropertyListXMLFormat_v1_0
																	 errorDescription:&errorTesc];
			
			if (isoBootData){
				[isoBootData writeToFile:isoBootPath atomically:NO];
				NSLog(@"com.apple.Boot.plist ready for ISO");
			}

			//fichier dans le dossier Extra
			NSMutableDictionary *preisoTemp = [NSMutableDictionary dictionary];
			[preisoTemp setObject:@"Yes" forKey:@"Rescan"];
			//assurer les bon reglages -> pas de boot direct
			if (timeOut) {
				[preisoTemp setObject:timeOut forKey:@"Time Out"];
			}
			else if (RescanPrompt) {
				[preisoTemp setObject:RescanPrompt forKey:@"Rescan Prompt"];
			}
			else {
				[preisoTemp setObject:@"Yes"forKey:@"Instant Menu"];
			}
			//
			[preisoTemp setObject:vide forKey:@"Kernel Flags"];
			[preisoTemp setObject:@"mach_kernel" forKey:@"Kernel"];
			if (([disableUI state]==NSOnState)) {
				[preisoTemp setObject:@"No" forKey:@"GUI"];
			}
			
			if (selectedTheme) {
				[preisoTemp setObject:selectedTheme forKey:@"Theme"];
				//extraction du theme choisi
				NSString *themeFolderPath = @"/tmp/isodir/Themes/";
				NSString *theThemePath = [themeFolderPath stringByAppendingString:selectedTheme];
				NSString *theFinalPath = @"/tmp/newiso/Extra/Themes/";
				
				// creation du dossier theme si réelement present
				if ([theManager fileExistsAtPath:theThemePath]) {
					[bootcdDirectory  createDirectoryAtPath:themeFinalPath attributes:nil];
					[theManager copyItemAtPath:theThemePath toPath:[theFinalPath stringByAppendingString:selectedTheme] error:&fileError];
				}
			}
			if (graphicsMode)
				[preisoTemp setObject:graphicsMode forKey:@"Graphics Mode"];
			
			NSData *plistPreBootData = [NSPropertyListSerialization dataFromPropertyList:preisoTemp format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorTesc];
			
			if (plistPreBootData){
				[plistPreBootData writeToFile:plistpreBootPath atomically:NO];
				NSLog(@"com.apple.Boot.plist ready for ISO");
			}
			
			//on lance le script
			cdbootIsRunning = TRUE;
			[progressIndicator startAnimation: self];
			[cdbootTask setLaunchPath:[[NSBundle mainBundle] pathForResource:@"cdBootCreator" ofType:@"sh"]];
			[cdbootTask setStandardOutput:cdbootPipe];

			[cdbootTask launch];
			[cdConfirm setImage: nil]; // efface le texte de confirmation si on recommence
			[NSThread detachNewThreadSelector:@selector(cdbootData:) toTarget:self withObject:theFileHandle];
			 }
		
		else {

			 if (cdbootPipe) { [cdbootPipe release]; cdbootPipe = nil; } 
			 if (cdbootTask) { [cdbootTask release]; cdbootTask = nil; }//problème avec le script
			if 	(DisableSoundState == NO) {
				sound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Sounds/Basso.aiff" byReference:YES];
				[sound play];
			}
			 [cdConfirm setImage: processOk];
			 NSLog(@"iso failed.");
			[sound release];
		 }
	 }
}
 
// affiche le log de création de l'ISO
- (void)cdbootData:(NSFileHandle*) theFileHandle 
{	
	//check sons preferences
	BOOL DisableSoundState;
	DisableSoundState = [[NSUserDefaults standardUserDefaults] boolForKey:@"disableSound"];
	
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSString *isoBootPath = @"/tmp/isodir/com.apple.Boot.plist";
	NSString *extensionsPath = @"/tmp/isodir/Extensions";
	NSString *mkextPath = @"/tmp/isodir/Extensions.mkext";
	NSString *tempFolder = @"/tmp/isodir/";
	NSString *processOkStatus = [[NSBundle mainBundle] pathForResource:@"accept" ofType:@"png"];
	NSString *processKoStatus = [[NSBundle mainBundle] pathForResource:@"block" ofType:@"png"];
	NSImage *processOk; 
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
	NSSound *sound;
 
    while (cdbootIsRunning) {
        NSData *theData = [theFileHandle availableData];

        if ([theData length]) { 

            NSString *theString = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding]; 
            NSRange theEnd = NSMakeRange([[cdbootView string] length], 0); 
            [cdbootView replaceCharactersInRange:theEnd withString:theString]; 
            theEnd.location += [theString length]; 
            [cdbootView scrollRangeToVisible:theEnd];
			[theString release];
        }
        if (([cdbootTask isRunning] == NO) && ([theData length] == 0)) 
            cdbootIsRunning = NO; 
    }  
    [cdbootTask terminate]; 
    [cdbootTask waitUntilExit]; 

    if (cdbootPipe) { [cdbootPipe release]; cdbootPipe = nil; }
    if (cdbootTask) { [cdbootTask release]; cdbootTask = nil; } 
    
	[progressIndicator stopAnimation:self];
	int status = [cdbootTask terminationStatus];
	
	if (([theManager fileExistsAtPath:isoBootPath]) && 
										(status == 0) && 
										(([theManager fileExistsAtPath:mkextPath]) || [theManager fileExistsAtPath:extensionsPath])) {
		sound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Sounds/Glass.aiff" byReference:YES];
		processOk = [[NSImage alloc] initWithContentsOfFile:processOkStatus];
		
		//rafraichir le tout
		if ([refreshAll state]==NSOnState) {
			[theManager removeFileAtPath:tempFolder handler:nil];
			// supprime les images une par une
			while ([browserData count] > 0) {
				[browserData removeObjectAtIndex:0];
			}
			// rafraichi l'affichage
			[browserView reloadData];
			[theManager createDirectoryAtPath:tempFolder attributes:nil];
			NSLog(@"everything in place.");
		}
		//mount the iso if desired
		if ([mountISO state]==NSOnState) {
			system("hdiutil attach ~/Desktop/BootCD.iso");//  bourinnage pour l'enregistrement A virer
		}
	}
	else {
		sound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Sounds/Basso.aiff" byReference:YES];
		processOk = [[NSImage alloc] initWithContentsOfFile:processKoStatus];
		NSLog(@"terminationStatus = %d", [cdbootTask terminationStatus]);
	}
	if 	(DisableSoundState == NO) {
			[sound play];
	}
	[[cdConfirm image] release];
	[cdConfirm setImage: processOk];
    [cdbootButton setEnabled:YES];
    [thePool release];
	[sound release];
    [NSThread exit];
} 
@end