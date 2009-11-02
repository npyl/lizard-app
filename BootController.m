//
//  BootController.m
//  Chameleon Manager
//
//  Created by ronan on 19/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "BootController.h"
#import "Application.h"

@implementation BootController

//com.apple.Boot.plist synthetize
@synthesize graphicsMode;
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
@synthesize wait;
@synthesize pciRoot;
@synthesize dpString;

@synthesize viewBootData;

@synthesize themeAuthor;
@synthesize themeVersion;
@synthesize themeWidth;
@synthesize themeHeight;

@synthesize theicon;
@synthesize selectedPath;
@synthesize diskType;
@synthesize diskUUID;
@synthesize diskROnly;

//constantes
NSString *errorDesc;
NSError *errorFile = nil;

//init
- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	//definition du dossier Extra
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *chameleonBootPath = [showExtraPath stringByAppendingPathComponent:bootPath];
	
	//task pour authopen
	NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
	NSFileHandle *writeHandle = [pipe fileHandleForWriting];
	[task setLaunchPath:@"/usr/libexec/authopen"];
	
	//check les preferences du path com.boot
	BOOL systemBoot;
	systemBoot = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemBoot"];
	if (systemBoot == YES) {
		comBootPath = systemeBootPath;
	}
	else {
		comBootPath = chameleonBootPath;
	}
	
	BOOL isDir;
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSMutableDictionary *bootDict = [NSMutableDictionary dictionary];
    if (returnCode == NSAlertFirstButtonReturn) {
		if (! kernelPath) {
		[bootDict setObject:@"mach_kernel" forKey:@"Kernel"];
		}
		if (! kernelFlags) {
		[bootDict setObject:@"" forKey:@"Kernel Flags"];
		}
		NSData *bootData = [NSPropertyListSerialization dataFromPropertyList:bootDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
		
		// verifie que le tout est en place
		if ((![theManager fileExistsAtPath:showExtraPath isDirectory:&isDir]) && (comBootPath = chameleonBootPath)){
			[theManager createDirectoryAtPath:showExtraPath attributes:nil];
		}
		if ([theManager isWritableFileAtPath:showExtraPath]){
			[bootData writeToFile:comBootPath atomically:NO];
			if (! kernelPath) {
			[kernelPathUpdate setStringValue:@"mach_kernel"];
			}
			[imageStatus setImage: nil];
			[bootSizeDisplay setStringValue:@""];
			
		}
		//pas de dossier extra, on le crée
		else if (![theManager isWritableFileAtPath:showExtraPath]) {
			[task setArguments:[NSArray arrayWithObjects:@"-c", @"-w",comBootPath, nil]];
			[task setStandardInput:pipe];
			[writeHandle writeData:bootData];
			[task launch];
			close([writeHandle fileDescriptor]);//fermuture manuelle
			[task waitUntilExit];//pour que l'icone s'affiche au bon moment
			[task release];
		}
		if (! kernelPath) {
			[kernelPathUpdate setStringValue:@"mach_kernel"];
		}
			[imageStatus setImage: nil];
			[bootSizeDisplay setStringValue:@""];
	}
}
- (IBAction)timeOutValue:(id)sender {
	if ([TimeOutSlide intValue]==0) {
		[timeOutNumBox setStringValue:@""];
		[timeOut setValue:nil];
	}
}
- (void)awakeFromNib {
	//definition du dossier Extra
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *chameleonBootPath = [showExtraPath stringByAppendingPathComponent:bootPath];
	NSString *chameleonThemesPath = [showExtraPath stringByAppendingPathComponent:themePath];
	//récupère la racine du chemin indiqué
	NSString *bootLoaderPath = [showExtraPath stringByDeletingLastPathComponent];
	
	//check les preferences du path com.boot
	BOOL systemBoot;
	systemBoot = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemBoot"];
	if (systemBoot == YES) {
		comBootPath = systemeBootPath;
		[systemBootStatus setStringValue:@"System default path"];
	}
	else {
		comBootPath = chameleonBootPath;
	}
	//pref version chameleon
	BOOL DisableSoundState;
	DisableSoundState = [[NSUserDefaults standardUserDefaults] boolForKey:@"disableCC"];
	
	NSFileManager *theManager = [NSFileManager defaultManager];
	//arch pour SL
	
	if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_5) {
		[SystemCheck setEnabled:YES];
	}
	else {
		[SystemCheck setEnabled:NO];
	}
	
	// definir la version de Chameleon installée
	NSString *bootChamPath = [bootLoaderPath stringByAppendingPathComponent:@"boot"];
	NSString *version3 = @"Chameleon 2 RC3";
	NSString *version2 = @"Chameleon 2 RC2";
	NSString *version1 = @"Chameleon 2 RC1";
	NSString *errorVersion = @"Chameleon?";
	NSString *noChameleon = @"No boot";
	NSString *noBootFile = @"com.apple.Boot.plist not found!";
	NSString *goodStatus = [[NSBundle mainBundle] pathForResource:@"status-available" ofType:@"tiff"];
	NSString *warningStatus = [[NSBundle mainBundle] pathForResource:@"status-idle" ofType:@"tiff"];
	NSString *noStatus = [[NSBundle mainBundle] pathForResource:@"status-nostatus" ofType:@"tiff"];
	NSString *errorStatus = [[NSBundle mainBundle] pathForResource:@"status-away" ofType:@"tiff"];
	NSString *defaultThumbPath = [[NSBundle mainBundle] pathForResource:@"no-thumb" ofType:@"png"];
	
	NSDictionary *FileAttributes = [theManager fileAttributesAtPath:bootChamPath traverseLink:NO];
	NSNumber *theFileSize = [FileAttributes objectForKey:NSFileSize];
	NSImage *warningIcon = [[NSImage alloc] initWithContentsOfFile:warningStatus];
	NSImage *errorIcon = [[NSImage alloc] initWithContentsOfFile:errorStatus];
	NSImage *noStatusIcon = [[NSImage alloc] initWithContentsOfFile:noStatus];
	NSImage *goodIcon = [[NSImage alloc] initWithContentsOfFile:goodStatus];
	NSImage *defaultThumb = [[NSImage alloc] initWithContentsOfFile:defaultThumbPath];

//le fichier existe
if ([theManager fileExistsAtPath:comBootPath]) {	
	if 	(DisableSoundState == NO) {
	if (([theFileSize intValue]==295328) || ([theFileSize intValue]==308288)) {
		[imageStatus setImage: warningIcon];
		[smbiosPathStatus setImage: warningIcon];
		[vbiosStatus setImage: warningIcon];
		[vromStatus setImage: warningIcon];
		[logoStatus setImage: warningIcon];
		[bannerStatus setImage: warningIcon];
		[waitStatus setImage: warningIcon];
	}
		
	if (! theFileSize) {
		[imageStatus setImage:noStatusIcon];
		[bootSizeDisplay setStringValue:noChameleon];
		NSLog(@"no boot file on root folder");
	}
	else if ([theFileSize intValue]==295328) {
		[bootSizeDisplay setStringValue:version1];
		[graphicsEnablerStatus setImage: warningIcon];
		[ethernetStatus setImage: warningIcon];
		NSLog(@"initialized with chameleon 2 RC1");
	}
	else if ([theFileSize intValue]==308288) {
		[bootSizeDisplay setStringValue:version2];	
		NSLog(@"initialized with chameleon 2 RC2");
	}
	else if ([theFileSize intValue]==309344) {
		[bootSizeDisplay setStringValue:version3];
		[imageStatus setImage: goodIcon];
		NSLog(@"initialized with chameleon 2 RC3");
	}
	else {
		[bootSizeDisplay setStringValue:errorVersion];
		[imageStatus setImage: errorIcon];
		NSLog(@"Unknown bootloader");
	}
}
// activer le GUI
	if (([GUI isEqualToString:@"No"]) ||
		([GUI isEqualToString:@"n"])  ||
		([GUI isEqualToString:@"N"])){
		([GUIBox setState:NSOnState]);
	}
	if (([bootBanner isEqualToString:@"No"]) ||
		([bootBanner isEqualToString:@"n"])  ||
		([bootBanner isEqualToString:@"N"])){
		([bootBannerBox setState:NSOnState]);
	}
	if (([vBios isEqualToString:@"No"]) ||
		([vBios isEqualToString:@"n"])  ||
		([vBios isEqualToString:@"N"])){
		([vBiosBox setState:NSOnState]);
	}
	if ([SLarch isEqualToString:@"i386"]) {
		[legacyBootBox setState:NSOnState];
	}
		
	if (([graphicsEnablerBox state]==NSOnState) && (devProps)) {
		[graphicsEnablerBox setEnabled:YES];
			if ([theFileSize intValue] > 295328) {
				[graphicsEnablerStatus setImage: errorIcon];
			}
		}
	if (([ethernetBuiltInBox state]==NSOnState) && (devProps)){
		[ethernetBuiltInBox setEnabled:YES];
			if ([theFileSize intValue] > 295328) {
				[ethernetStatus setImage: errorIcon];
			}
		}
	
		
	// theme.plist
	NSPropertyListFormat format;
	BOOL isDir;
	
		if (selectedTheme) { // condition pour empêcher le plantage si stringByAppendingString est vide (pas de theme dans le plist)
		NSString *themeShortPath = [chameleonThemesPath stringByAppendingPathComponent:selectedTheme];
		NSString *themePlistPath = [themeShortPath stringByAppendingPathComponent:@"theme.plist"];
		NSString *themeThumbPath = [themeShortPath stringByAppendingPathComponent:@"thumb.png"];
		
		if ([theManager fileExistsAtPath:themeShortPath isDirectory:&isDir]) { //previent plantage si pas de dossier Theme
			NSData *plistThemeXML = [[NSFileManager defaultManager] contentsAtPath:themePlistPath];
			NSMutableDictionary *themeTemp = (NSMutableDictionary *)[NSPropertyListSerialization
																 propertyListFromData:plistThemeXML
																 mutabilityOption:NSPropertyListMutableContainersAndLeaves
																 format:&format errorDescription:&errorDesc];
		
			self.themeAuthor = [themeTemp objectForKey:@"Author"]; // <key>Author</key> à ajouter dans le theme.plist
			self.themeVersion = [themeTemp objectForKey:@"Version"];
			self.themeWidth = [themeTemp objectForKey:@"screen_width"];
			self.themeHeight = [themeTemp objectForKey:@"screen_height"];// <key>Version</key> à ajouter dans le theme.plist
		
		// afficher la date
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  // obtenir un format court et lisible 
			[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; //
			[dateFormatter setDateStyle:NSDateFormatterLongStyle];            //configuration du format
			
			NSDictionary *theFileAttributes = [theManager fileAttributesAtPath:themeShortPath traverseLink:NO];
			NSString *dateStr = [dateFormatter stringFromDate:[theFileAttributes objectForKey:NSFileCreationDate]]; //récupere la date et la convertie
			[fileCreatedDisplay setStringValue:dateStr];
			
			if ([theManager fileExistsAtPath:themeThumbPath]) {
				// affciher l'image
				NSImage *thumbFromTheme = [[NSImage alloc] initWithContentsOfFile:themeThumbPath];
				[[themeThumbDisplay image] release];
				[themeThumbDisplay setImage: thumbFromTheme];
			}
			else {
				// image par défault si pas de thumb
				[themeThumbDisplay setImage:defaultThumb ];
					NSLog(@"no thumb found for selected theme");
			}
		}
		else {
			[themeThumbDisplay setImage:defaultThumb ];
			NSLog(@"Specified theme not found");
		}
	}
	
	else {
		// avertisssement
		[themeThumbDisplay setImage:defaultThumb];
				NSLog(@"no theme selected");
	}
}

// auncun des deux n'existe ((evite de recrer un instance dans IB)
else if ((![theManager fileExistsAtPath:comBootPath]) && (![theManager fileExistsAtPath:@"/boot"])){
	[bootSizeDisplay setStringValue:@"No com.appleBoot.plist and boot files found!"];
	[imageStatus setImage: errorIcon];
}

// seulement le boot

else if (![theManager fileExistsAtPath:comBootPath]){
	[bootSizeDisplay setStringValue:noBootFile];
	[imageStatus setImage: errorIcon];
	}
}

// injection des devprops
- (IBAction)getDevProps:(id)sender
{	
	NSTask *gfxutil = [[NSTask alloc] init];
	[gfxutil setLaunchPath:[[NSBundle mainBundle] pathForResource:@"getDevProp" ofType:@"sh"]];
	[gfxutil launch];
		
	[progressIndicator startAnimation: self]; //lancement de l'anim
	[gfxutil waitUntilExit]; //surveille le script et bloque le bouton
	int status = [gfxutil terminationStatus];
	
	if (status == 0) { //script terminé avec succès
		[progressIndicator stopAnimation: self];
		NSLog(@"dev-props checked.");
	}
	else {
		[progressIndicator stopAnimation: self]; //problème avec le script	
		NSLog(@"no dev-props.");
	}	
}
- (IBAction)insertFlag:(id)sender {
	NSString *addedFlag = [[theFlag objectValueOfSelectedItem] stringByAppendingString:@" "];
	if (! kernelFlags) {
		self.kernelFlags = addedFlag;
	}
	else {
		self.kernelFlags = [self.kernelFlags stringByAppendingString:addedFlag]; // ajoute la valeur au string
	}
}

// debut recuperation plist
- (id) init {

    if (self = [super init]) {
		[NSThread detachNewThreadSelector:@selector(getPartitions) toTarget:self withObject:self];
		//definition du dossier Extra
		NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
		NSString *chameleonBootPath = [showExtraPath stringByAppendingPathComponent:bootPath];
		NSString *chameleonThemesPath = [showExtraPath stringByAppendingPathComponent:themePath];
	
		NSFileManager* fileManager = [NSFileManager defaultManager];
		NSArray *directory = [fileManager contentsOfDirectoryAtPath:chameleonThemesPath error:&errorFile];
		
			// You don't need autorelease if you use garbage collection
		dataOfArray = [[NSMutableArray alloc] init];
		NSMutableArray *files = [[directory mutableCopy]autorelease];
		[dataOfArray addObjectsFromArray:files];
			NSLog(@"%d theme selected",[dataOfArray retainCount]);
		
        NSPropertyListFormat format;
   
		// com.apple.boot.plist
		//check les preferences du path com.boot
		BOOL systemBoot;
		systemBoot = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemBoot"];
		if (systemBoot == YES) {
			comBootPath = systemeBootPath;
		}
		else {
			comBootPath = chameleonBootPath;
		}
        plistBootXML = [[NSFileManager defaultManager] contentsAtPath:comBootPath];
        bootTemp = (NSMutableDictionary *)[NSPropertyListSerialization
												  propertyListFromData:plistBootXML
												  mutabilityOption:NSPropertyListMutableContainersAndLeaves
												  format:&format errorDescription:&errorDesc];

		self.graphicsMode = [bootTemp objectForKey:@"Graphics Mode"];
		self.kernelPath = [bootTemp objectForKey:@"Kernel"];
		self.kernelFlags = [[bootTemp objectForKey:@"Kernel Flags"] stringByAppendingString:@" "];
		self.graphicsEnabler = [bootTemp objectForKey:@"GraphicsEnabler"];
		self.timeOut = [bootTemp objectForKey:@"Timeout"];
		self.ethernetBuiltIn = [bootTemp objectForKey:@"EthernetBuiltIn"];
		self.selectedTheme = [bootTemp objectForKey:@"Theme"];
		self.USBBusFix = [bootTemp objectForKey:@"USBBusFix"];
		self.EHCIacquire = [bootTemp objectForKey:@"EHCIacquire"];
		self.UHCIreset = [bootTemp objectForKey:@"UHCIreset"];
		self.Wake = [bootTemp objectForKey:@"Wake"];
		self.ForceWake = [bootTemp objectForKey:@"ForceWake"];
		self.WakeImage = [bootTemp objectForKey:@"WakeImage"];
		self.DropSSDT = [bootTemp objectForKey:@"DropSSDT"];
		self.DSDT = [bootTemp objectForKey:@"DSDT"];
		self.SMBIOSdefaults = [bootTemp objectForKey:@"SMBIOSdefaults"];
		self.Rescan = [bootTemp objectForKey:@"Rescan"];
		self.RescanPrompt = [bootTemp objectForKey:@"Rescan Prompt"];
		self.GUI = [bootTemp objectForKey:@"GUI"];
		self.InstantMenu = [bootTemp objectForKey:@"Instant Menu"];
		self.DefaultPartition = [bootTemp objectForKey:@"Default Partition"];
		self.setSmbioPath = [bootTemp objectForKey:@"SMBIOS"];
		self.quietBoot = [bootTemp objectForKey:@"Quiet Boot"];
		self.vBios = [bootTemp objectForKey:@"VBIOS"];
		self.bootBanner = [bootTemp objectForKey:@"Boot Banner"];
		self.legacyLogo = [bootTemp objectForKey:@"Legacy Logo"];
		self.videoROM = [bootTemp objectForKey:@"VideoROM"];
		self.forceHPET = [bootTemp objectForKey:@"forceHPET"];
		self.SLarch = [bootTemp objectForKey:@"arch"];
		self.devProps = [bootTemp objectForKey:@"device-properties"];
		self.wait = [bootTemp objectForKey:@"Wait"];
		
		self.viewBootData = [NSPropertyListSerialization dataFromPropertyList:bootTemp
																		   format:NSPropertyListXMLFormat_v1_0
																 errorDescription:&errorDesc];
    }
    return self;
	[saveGood setImage: nil];
	self.kernelFlags = [[NSMutableString alloc] initWithCapacity:10];
}

// début ecriture du plists
- (IBAction)saveBoot:(id)sender {
	//definition du dossier Extra
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *chameleonBootPath = [showExtraPath stringByAppendingPathComponent:bootPath];
	
	//backup du fichier
	NSString *showBackupPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Backup Folder"];
	
	// aller sur un champ invisible pour valider le courant
	[kernelPathUpdate selectText:sender];
	[timeOutNumBox selectText:sender];
	[testMe selectText:sender];
	
	//task pour authopen
	NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *writeHandle = [pipe fileHandleForWriting];
	
	//restaurer l'image après le dernier fade
	[saveGood setImage: nil]; // si le fichier est supprimé pendant que l'app tourne
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0];
	[[saveGood animator] setAlphaValue:1];
	[NSAnimationContext endGrouping];
	
	NSFileManager *theManager = [NSFileManager defaultManager];
	
	//pour desactivation des alertes uniquement avec rc3 (voir devprops)
	NSString *bootChamPath = @"/boot";
	NSDictionary *FileAttributes = [theManager fileAttributesAtPath:bootChamPath traverseLink:NO];
	NSNumber *theFileSize = [FileAttributes objectForKey:NSFileSize];
	
	// pas de tableau, sinon nil empèche la sauvegarde
	//check les preferences du path com.boot
	BOOL systemBoot;
	systemBoot = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemBoot"];
	if (systemBoot == YES) {
		comBootPath = systemeBootPath;
	}
	else {
		comBootPath = chameleonBootPath;
	}
	NSMutableDictionary *bootDict = [NSMutableDictionary dictionary];
	
	// checkboxes
	if (([enableCheckBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"Wait"];
	
	if (([graphicsEnablerBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"GraphicsEnabler"];
	if (([graphicsEnablerBox state]==NSOffState))
		[vBiosBox setState:NSOffState];
	
	if (([ethernetBuiltInBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"EthernetBuiltIn"];
	
	if (([quietBootBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"Quiet Boot"];
	
	if (([USBBusFixBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"USBBusFix"];
	
	if (([UHCIresetBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"UHCIreset"];
	
	if (([WakeBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"Wake"];
	
	if (([ForceWakeBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"ForceWake"];
	
	if (([DropSSDTBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"DropSSDT"];
	
	if (([SMBIOSdefaultsBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"SMBIOSdefaults"];
	
	if (([RescanBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"Rescan"];
	
	if (([RescanPromptBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"Rescan Prompt"];
	
	if (([GUIBox state]==NSOnState))
		[bootDict setObject:@"No" forKey:@"GUI"];
	
	if (([InstantMenuBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"Instant Menu"];
	
	if (([EHCIacquireBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"EHCIacquire"];
	
	if (([vBiosBox state]==NSOnState))
		[bootDict setObject:@"No" forKey:@"VBIOS"];
	
	if (([bootBannerBox state]==NSOnState))
		[bootDict setObject:@"No" forKey:@"Boot Banner"];
	
	if (([legacyLogoBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"Legacy Logo"];
	
	if (([forceHPETBox state]==NSOnState))
		[bootDict setObject:@"Yes" forKey:@"forceHPET"];
	
	if (([legacyBootBox state]==NSOnState) && (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_5)) {
		[bootDict setObject:@"i386" forKey:@"arch"];
	}
	
	// textfields	
	if (graphicsMode)
		[bootDict setObject:graphicsMode forKey:@"Graphics Mode"];	
	if (! kernelPath)
		[bootDict setObject:@"mach_kernel" forKey:@"Kernel"];//config defaut apple
	if (kernelPath)
		[bootDict setObject:kernelPath forKey:@"Kernel"];	
	if (! kernelFlags)
		[bootDict setObject:@"" forKey:@"Kernel Flags"]; //config defaut apple
	if (kernelFlags) {
		//supprime l'espace à la fin
		if([self.kernelFlags hasSuffix:@" "]) {
			kernelFlags = [self.kernelFlags substringFromIndex:[self.kernelFlags length] - [@" " length]];
		}
			[bootDict setObject:kernelFlags forKey:@"Kernel Flags"];
	}
	if (selectedTheme)
		[bootDict setObject:selectedTheme forKey:@"Theme"];	
	if (WakeImage)
		[bootDict setObject:WakeImage forKey:@"WakeImage"];	
	if (DSDT)
		[bootDict setObject:DSDT forKey:@"DSDT"];	
	
	if (DefaultPartition) {
		self.DefaultPartition = [DefaultPartition substringToIndex:7];//isole uniquement le hd(x,x)
		[bootDict setObject:DefaultPartition forKey:@"Default Partition"];
	}
	if (setSmbioPath)
		[bootDict setObject:setSmbioPath forKey:@"SMBIOS"];	
	if (videoROM)
		[bootDict setObject:videoROM forKey:@"VideoROM"];	
	if ([timeOut intValue]>0) {
		NSString *saveTime = [NSString stringWithFormat:@"%@", timeOut]; //convertir la valeur string
		[bootDict setObject:saveTime forKey:@"Timeout"];
	}
	
	//corrige l'apparence si devprop sont nil
	if ((devProps) && ([theFileSize intValue] > 295328) && ([ethernetBuiltInBox state]==NSOffState)) {
			[ethernetStatus setImage: nil];
	}
	if ((devProps) && ([theFileSize intValue] > 295328) && ([graphicsEnablerBox state]==NSOffState)) {
			[graphicsEnablerStatus setImage: nil];
	}
	if (devProps)
		[bootDict setObject:devProps forKey:@"device-properties"];

	self.viewBootData = [NSPropertyListSerialization dataFromPropertyList:bootDict
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&errorDesc];
	// declaration des alertes
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSWarningAlertStyle];
	if ([theManager fileExistsAtPath:comBootPath]) {
		
		//backup du fichier
		if (showBackupPath) {
			NSString *createBackPath;

			if ([showBackupPath isEqualToString:@"/Desktop/Lizard/Backup"]) { //defaultPath
				NSString *theBackPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Desktop"];
				createBackPath = [theBackPath stringByAppendingPathComponent:@"Lizard/Backup"];
				
				if (![theManager fileExistsAtPath: [createBackPath stringByDeletingLastPathComponent]]) {
					[theManager createDirectoryAtPath:[theBackPath stringByAppendingPathComponent:@"Lizard"] attributes:nil];
				}
				if (![theManager fileExistsAtPath: createBackPath]) {
					[theManager createDirectoryAtPath:createBackPath attributes:nil];
				}
				if ([createBackPath stringByAppendingPathComponent:bootPath]) {
					//affiche Date 
					NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  // obtenir un format court et lisible 
					[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; //
					[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
					NSDictionary *theFileAttributes = [theManager fileAttributesAtPath:createBackPath traverseLink:NO];
					NSString *dateStr = [dateFormatter stringFromDate:[theFileAttributes objectForKey:NSFileModificationDate]];
					NSString *theDate = [dateStr stringByAppendingString:@"."];
					[theManager copyItemAtPath:[createBackPath stringByAppendingPathComponent:bootPath] toPath:[createBackPath stringByAppendingPathComponent:[theDate stringByAppendingString:bootPath]] error:&errorFile];
				}
			}
			else { 
				createBackPath = showBackupPath; 
			}
			[theManager copyItemAtPath:comBootPath toPath:[createBackPath stringByAppendingPathComponent:[comBootPath lastPathComponent]] error:&errorFile];
		}
		//fin du backup
		
		if (![theManager isWritableFileAtPath:comBootPath]) {
		
			//utilisation de authopen pour élever les permissions via un pipe
			[task setLaunchPath:@"/usr/libexec/authopen"];
			[task setArguments:[NSArray arrayWithObjects:@"-c", @"-w", comBootPath, nil]];
			[task setStandardInput:pipe];
			[writeHandle writeData:viewBootData];
			[task launch];
			close([writeHandle fileDescriptor]);//fermuture manuelle
			[task waitUntilExit];//pour que l'icone s'affiche au bon moment
			[task release];
		}
			//les autorisations sont déjà bonnes
		else if ([theManager isWritableFileAtPath:comBootPath]) {
			[viewBootData writeToFile:comBootPath atomically:NO]; //NO sinon ne fonctionne pas depuis authopen
		}
		
			NSString *acceptPath = [[NSBundle mainBundle] pathForResource:@"accept" ofType:@"png"];
			NSImage *saveGoodIcon = [[NSImage alloc] initWithContentsOfFile:acceptPath];
			[saveGood setImage: saveGoodIcon];
				NSLog(@"com.apple.Boot.plist updated succesfully");
		//fade out
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext] setDuration:1.0];
			[[saveGood animator] setAlphaValue:0];
			[NSAnimationContext endGrouping];
	}
	else if (![theManager fileExistsAtPath:comBootPath]){
		[alert setMessageText:@"com.apple.Boot.plist not found"];
		[alert addButtonWithTitle:@"Generate new"];
		[alert addButtonWithTitle:@"Cancel"];
        [alert setInformativeText:@"Press 'Generate new' to create a new com.apple.Boot.plist in Extra folder then press save if you entered data"];
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
	}

}
// Selection du thême via le bouton
- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
	return [dataOfArray count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index
{
	return [dataOfArray objectAtIndex:index];
}

-(void)dealloc
{
	[dataOfArray release];
	[super dealloc];
}

//afficher les informations du theme en temps reel
- (IBAction) sendThemeUpdate:(id)sender {
	// evite le blocage du theme
	[themeUpdate selectText:sender];
	[testMe selectText:sender];
	
	// Definition du dossier Extra
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *chameleonThemesPath = [showExtraPath stringByAppendingPathComponent:themePath];
	
	NSString *folderPath = [chameleonThemesPath stringByAppendingPathComponent:selectedTheme];
	NSString *thumbsPath = [folderPath stringByAppendingPathComponent:@"/thumb.png"];
	NSString *themePrefPath = [folderPath stringByAppendingPathComponent:@"/theme.plist"];
	NSFileManager *theManager = [NSFileManager defaultManager];
	[fileNameDisplay setStringValue:[theManager displayNameAtPath:folderPath]];
	
	//affiche Date 
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  // obtenir un format court et lisible 
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; //
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];            //configuration du format
	
	NSDictionary *theFileAttributes = [theManager fileAttributesAtPath:folderPath traverseLink:YES];
	NSString *dateStr = [dateFormatter stringFromDate:[theFileAttributes objectForKey:NSFileCreationDate]];
	[fileCreatedDisplay setStringValue:dateStr];
	
	if ([theManager fileExistsAtPath:thumbsPath] && (selectedTheme)) {//affiche l'icone si elle existe
		NSImage *thumbFromTheme = [[NSImage alloc] initWithContentsOfFile:thumbsPath];
		[[themeThumbDisplay image] release];
		[themeThumbDisplay setImage: thumbFromTheme];
		//FadeIn
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0];
		[[themeThumbDisplay animator] setAlphaValue:0];
		[NSAnimationContext endGrouping];
		[NSAnimationContext beginGrouping];
		[[themeThumbDisplay animator] setAlphaValue:1];
		[NSAnimationContext endGrouping];
	}
	else { // image par defaut sinon
		NSString *defaultThumbPath = [[NSBundle mainBundle] pathForResource:@"no-thumb" ofType:@"png"];
		NSImage *defaultThumb = [[NSImage alloc] initWithContentsOfFile:defaultThumbPath];
		[[themeThumbDisplay image] release];
		[themeThumbDisplay setImage:defaultThumb ];
	}
	
	//infos du plist
	NSPropertyListFormat format;
	NSData *plistThemeXML = [[NSFileManager defaultManager] contentsAtPath:themePrefPath];
	NSDictionary *themeTemp = (NSDictionary *)[NSPropertyListSerialization
											   propertyListFromData:plistThemeXML
											   mutabilityOption:NSPropertyListMutableContainersAndLeaves
											   format:&format errorDescription:&errorDesc];
	
	self.themeAuthor = [themeTemp objectForKey:@"Author"]; // <key>Author</key> à ajouter dans le theme.plist
	self.themeVersion = [themeTemp objectForKey:@"Version"];
	self.themeWidth = [themeTemp objectForKey:@"screen_width"];
	self.themeHeight = [themeTemp objectForKey:@"screen_height"];
	}

// récup le PCIroot

- (IBAction) setPCIRoot:(id)sender {
	
	NSImage *processIcon = [NSImage imageNamed:@"NSComputer"];
	NSTask *gfxutil = [[NSTask alloc] init];
	NSPipe *pipe=[[NSPipe alloc] init];
	NSFileHandle *handle;
	NSArray *outPuts;
	NSString *tempString;
	
	[gfxutil setLaunchPath:[[NSBundle mainBundle] pathForResource:@"gfxutil" ofType:nil]];
	[gfxutil setArguments:[NSArray arrayWithObjects:@"-f", @"display", nil]];
	[gfxutil setStandardOutput:pipe];
	handle=[pipe fileHandleForReading];
	[gfxutil launch];
	
	NSString *string=[[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
	outPuts = [string componentsSeparatedByString:@"DevicePath = "];
	tempString = [outPuts objectAtIndex:1];
	//NSLog (@"%@",tempString); 
	if ([tempString hasPrefix:@"PciRoot(0x0)"]) {
		self.pciRoot = @"0";
	}
	else if ([tempString hasPrefix:@"PciRoot(0x1)"]) {
		self.pciRoot = @"1";
	}
	else {
		self.pciRoot = @"error: can't find a correct value";
	}
	
	[gfxutil release];
	[pipe release];
	
	if (pciRoot) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"PCIRoot configuration"];
		[alert setIcon:processIcon];
		[alert setInformativeText:[NSString stringWithFormat:@"%@ %@", @"Detected PCIRoot value is:", self.pciRoot]];
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		[alert release];
	}
}
- (void) getPartitions
{
		NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
	self.theicon = [[NSWorkspace sharedWorkspace] mountedLocalVolumePaths];
	NSString *trootName = @"";
	NSString *rootName = @"";
	NSString *readOnly = @"";
	NSString *moreString;
	NSString *theName = @"";
	NSString *tTheName = @"";
	//NSString *finalRDisk;
	NSMutableArray *listItem = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray *listName = [NSMutableArray arrayWithCapacity:10];
	
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
				if ([rootName isEqualToString: @""]) { // rien ne s'afiche sinon
					rootName = @"Untitled";
				}
				moreString = [rootName stringByReplacingOccurrencesOfString:@"disk" withString:@"hd("];
				moreString = [moreString stringByReplacingOccurrencesOfString:@"s" withString:@","];
				[listItem insertObject:rootName atIndex:i];
				
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
				if ([readOnly isEqualToString: @""]) { // rien ne s'afiche sinon
					readOnly = @"Untitled";
				}
			}
			self.dpString = [NSString stringWithFormat:@"%@%@", moreString, @")"];
			[listName insertObject:[NSString stringWithFormat:@"%@ %@ %@",self.dpString,@"->",readOnly] atIndex:i];
			self.selectedPath = [NSMutableArray arrayWithArray:listName];
			[diskutil release];
			[string release];
			[pipe release];
			i++;
		}
	}
	[thePool release];
}

// envoie la valeur du default partition

- (void)openPanelWillEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AppleShowAllFiles"];
	if (returnCode == NSOKButton) {
		if ([actionTag intValue]==1) { 
			self.WakeImage = [sheet filename];
		}
		if (([actionTag intValue]==2) && ([[[sheet filename] lastPathComponent]isEqualToString:@"DSDT.aml"] || [[[sheet filename] lastPathComponent]isEqualToString:@"dsdt.aml"])) { 
			self.DSDT = [sheet filename];
		}
		if (([actionTag intValue]==3) && [[[sheet filename] lastPathComponent]isEqualToString:@"smbios.plist"]) { 
			self.setSmbioPath = [sheet filename];
		}
		if (([actionTag intValue]==4) && [[[sheet filename] lastPathComponent]isEqualToString:@"NVIDIA.ROM"]){ 
			self.videoROM = [sheet filename];
		}
	}
	return;
}

- (IBAction)getWakeImage:(id)sender 
{
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppleShowAllFiles"];
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	actionTag = [NSNumber numberWithInteger:1];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(openPanelWillEnd:returnCode:contextInfo:) contextInfo:NULL];
}
- (IBAction)getDSDT:(id)sender 
{
	actionTag = [NSNumber numberWithInteger:2];
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(openPanelWillEnd:returnCode:contextInfo:) contextInfo:NULL];
}
- (IBAction)getSMPath:(id)sender 
{
	actionTag = [NSNumber numberWithInteger:3];
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(openPanelWillEnd:returnCode:contextInfo:) contextInfo:NULL];
}
- (IBAction)getVideoRom:(id)sender 
{
	actionTag = [NSNumber numberWithInteger:4];
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(openPanelWillEnd:returnCode:contextInfo:) contextInfo:NULL];
}
- (IBAction)bootPreview:(id)sender {
	if (![bootWindow isVisible]) {
		[bootWindow makeKeyAndOrderFront:self];
	}
	else {
		[bootWindow orderOut:nil];
	}
}

@end
