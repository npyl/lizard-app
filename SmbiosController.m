//
//  SmbiosController.m
//  Lizard
//
//  Created by ronan on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SmbiosController.h"

@implementation SmbiosController

//smbios.plist synthetize
@synthesize SMfamily;
@synthesize SMbiosversion;
@synthesize SMmanufacter;
@synthesize SMproductname;
@synthesize SMsystemversion;
@synthesize SMserial;
@synthesize SMexternalclock;
@synthesize SMmaximalclock;
@synthesize SMmemtype;
@synthesize SMmemspeed;
@synthesize SMbiosDate;
@synthesize SMcputype;

//@synthesize SMuuid;;
@synthesize setSmbioPath;
@synthesize smbiosData;

// tableau memoire
@synthesize smOne;
@synthesize smTwo;
@synthesize smThree;
@synthesize smFour;
@synthesize theDico;

//serail build
@synthesize snCountry;
@synthesize snYear;
@synthesize snWeek;
@synthesize snUnit;
@synthesize snModel;


// Gestion des popups et creation d'un plist si besoin
- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	
	//definition du dossier Extra
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *chameleonSmbiosPath = [showExtraPath stringByAppendingPathComponent:sSmbiosPath];
	
	//chemin smbios relatif a la partition
	NSString *smbiosRealPath = [showExtraPath stringByDeletingLastPathComponent];
	NSString *smbiosFinalPath = [smbiosRealPath stringByAppendingPathComponent:setSmbioPath];
	
	//task pour authopen
	NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
	NSFileHandle *writeHandle = [pipe fileHandleForWriting];
	[task setLaunchPath:@"/usr/libexec/authopen"];
	
	BOOL isDir;
	NSFileManager *theManager = [NSFileManager defaultManager];
	NSMutableDictionary *smbiosDict = [NSMutableDictionary dictionary];
	
	
	// On lance les actions
	if (returnCode == NSAlertFirstButtonReturn) {
		//créer des entrées si elles n'existent pas
		if (! SMfamily) {
			[smbiosDict setObject:@"Mac Pro" forKey:@"SMfamily"];
			self.SMfamily = [smbiosDict objectForKey:@"SMfamily"];
		}
		if (! SMproductname) {
			[smbiosDict setObject:@"MacPro3,1" forKey:@"SMproductname"];
			self.SMproductname = [smbiosDict objectForKey:@"SMproductname"];
		}
		if (! SMbiosversion) {
			[smbiosDict setObject:@"MP31.88Z.00C1.B00.0802091544" forKey:@"SMbiosversion"];
			self.SMbiosversion = [smbiosDict objectForKey:@"SMbiosversion"];
		}
		self.smbiosData = [NSPropertyListSerialization dataFromPropertyList:smbiosDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
		
		//pas de dossier extra, on le crée
		if ((![theManager fileExistsAtPath:showExtraPath isDirectory:&isDir]) && ((smbiosFinalPath == chameleonSmbiosPath) || (! setSmbioPath)))   {
			[theManager createDirectoryAtPath:showExtraPath attributes:nil];
		}
		if ([theManager isWritableFileAtPath:showExtraPath]){
			//tient compte du chemin boot.plist s'il existe
			if (setSmbioPath) {
				[smbiosData writeToFile:smbiosFinalPath atomically:YES];
			}
			else {
				[smbiosData writeToFile:chameleonSmbiosPath atomically:YES];
			}
		}
		else if (![theManager isWritableFileAtPath:showExtraPath]){
			if (setSmbioPath) {
				[task setArguments:[NSArray arrayWithObjects:@"-c", @"-w", smbiosFinalPath, nil]];
			}
			else {
				[task setArguments:[NSArray arrayWithObjects:@"-c", @"-w", chameleonSmbiosPath, nil]];
			}
			[task setStandardInput:pipe];
			[writeHandle writeData:smbiosData];
			[task launch];
			close([writeHandle fileDescriptor]);//fermuture manuelle
			[task waitUntilExit];//pour que l'icone s'affiche au bon moment
			[task release];
		}
		
		[smbioIconhError setImage: nil];
		[smbioPathError setStringValue:@""];
		if (! SMfamily)
			[SMfamilyUpdate setStringValue:@"Mac Pro"];
		if (! SMproductname)
			[SMproductnameUpdate setStringValue:@"MacPro3,1"];
		if (! SMbiosversion)
			[SMbiosversionUpdate setStringValue:@"MP31.88Z.00C1.B00.0802091544"];
	}
}

- (void)awakeFromNib {
	// creation du table
	//conversion des types memoire pour l'affichageNSFileManager *theManager = [NSFileManager defaultManager];
	NSString *SMmemDisplayDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"SMmemdefault"];
	NSString *SMcpuDisplayDefault = [[NSUserDefaults standardUserDefaults] stringForKey:@"SMcpudefault"];
	
	if ([SMmemtype isEqualToString:@"18"]) { 
			[SMmemtypeConv setStringValue:DDR];
	}
	else if ([SMmemtype isEqualToString:@"19"]) {
			[SMmemtypeConv setStringValue:DDR2];
	}
	else if ([SMmemtype isEqualToString:@"20"]) {
			[SMmemtypeConv setStringValue:FBDIMM];
	}
	else if ([SMmemtype isEqualToString:@"24"]) {
			[SMmemtypeConv setStringValue:DDR3];
	}
		
	if ([SMcputype isEqualToString:@"257"])  {
			[SMcputypeConv setStringValue:coreSolo];
	}
	else if ([SMcputype isEqualToString:@"769"]) {
			[SMcputypeConv setStringValue:coreTwo];
	}
	else if ([SMcputype isEqualToString:@"1281"]) {
			[SMcputypeConv setStringValue:coreXeon];
	}
	else if ([SMcputype isEqualToString:@"1537"]) {
			[SMcputypeConv setStringValue:iCore5];
	}
	
	if ([SMmemDisplayDefault isEqualToString:@"default"]) {
		[SMmemtypeConv setStringValue:memDefault];
		[SMmemtypeConv setTextColor:[NSColor redColor]]; 
	}
	if ([SMcpuDisplayDefault isEqualToString:@"default"]) {
		[SMcputypeConv setStringValue:cpuDefault];
		[SMcputypeConv setTextColor:[NSColor redColor]]; 
	}
	// affiche une icone si chemin different actif
			NSFileManager *theManager = [NSFileManager defaultManager];
	NSString *smbiosMissing = @"smbios.plist not found!";
	[displaySmbiosPath setPathStyle:NSPathStyleStandard];
	NSPropertyListFormat format;
	
	//check les preferences du path com.boot
	BOOL systemBoot;
	
	//definition du dossier Extra
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *chameleonBootPath = [showExtraPath stringByAppendingPathComponent:sBootPath];
	NSString *chameleonSmbiosPath = [showExtraPath stringByAppendingPathComponent:sSmbiosPath];
	NSString *comBootPath;
	
	//chemin smbios relatif a la partition
	NSString *smbiosRealPath = [showExtraPath stringByDeletingLastPathComponent];
	NSString *smbiosFinalPath = [smbiosRealPath stringByAppendingPathComponent: setSmbioPath ];
	
	//lecture des préférences
	systemBoot = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemBoot"];
	if (systemBoot == YES) {
		comBootPath = sSystemeBootPath;
	}
	else {
		comBootPath = chameleonBootPath;
	}
	
	NSData *plistBootXML = [[NSFileManager defaultManager] contentsAtPath:comBootPath];
	NSMutableDictionary *bootTemp = (NSMutableDictionary *)[NSPropertyListSerialization
															propertyListFromData:plistBootXML
															mutabilityOption:NSPropertyListMutableContainersAndLeaves
															format:&format errorDescription:&errorDesc];
	self.setSmbioPath = [bootTemp objectForKey:@"SMBIOS"];
	
	NSString *plistPath;	
	// récupere le chemin du fichier boot.plist
	NSString *errorStatus = [[NSBundle mainBundle] pathForResource:@"status-away" ofType:@"tiff"];
	NSString *okStatus = [[NSBundle mainBundle] pathForResource:@"status-available" ofType:@"tiff"];
	NSImage *errorIcon = [[NSImage alloc] initWithContentsOfFile:errorStatus];
	NSImage *okIcon = [[NSImage alloc] initWithContentsOfFile:okStatus];
	
	//la danse des erreurs
	if ((([[theManager displayNameAtPath:smbiosFinalPath] isEqualToString:@"smbios.plist"] && (!setSmbioPath))) || (([theManager fileExistsAtPath:chameleonSmbiosPath]) && (!setSmbioPath))){ //toutes les conditions sont remplies
		plistPath = smbiosFinalPath;

	}
	else {
		
		if ((setSmbioPath) && [[theManager displayNameAtPath:smbiosFinalPath] isEqualToString:@"smbios.plist"] && [theManager fileExistsAtPath:smbiosFinalPath]){ // ne pas spécifier de message d'erreur pour ne pas masquer le chemin
			[smbioPathError setStringValue:@""];
			[smbioIconhError setImage: okIcon];

		}
		else if ((setSmbioPath) && [[theManager displayNameAtPath:smbiosFinalPath] isEqualToString:@"smbios.plist"] && (![theManager fileExistsAtPath:smbiosFinalPath])){ //chemin custom mais pas trouvé
			[displaySmbiosPath setHidden: YES];
			[smbioIconhError setImage: errorIcon];
		}
		
		else {
			[smbioPathError setStringValue:smbiosMissing];
			[smbioIconhError setImage: errorIcon];
			NSLog(@" smbios.plist not found. misconfiguration in com.apple.boot.plist");
		}
		
		[[smbioIconhError image] release];
	}
}
- (id)init {
    
	if (self = [super init]) { //boot.plist pour smbios
		
		NSPropertyListFormat format;
		//check chemin défini dans les pref du com.apple.Boot.plist
		BOOL systemBoot;
		
		//definition du dossier Extra
		NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
		NSString *chameleonBootPath = [showExtraPath stringByAppendingPathComponent:sBootPath];
		NSString *chameleonSmbiosPath = [showExtraPath stringByAppendingPathComponent:sSmbiosPath];
		
		//chemin smbios relatif a la partition
		NSString *smbiosFinalPath;
		NSString *smbiosRealPath = [showExtraPath stringByDeletingLastPathComponent];	
		
		NSString *comBootPath;
		systemBoot = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemBoot"];
		if (systemBoot == YES) {
			comBootPath = sSystemeBootPath;
		}
		else {
			comBootPath = chameleonBootPath;
		}
		//le dico
        NSData *plistBootXML = [[NSFileManager defaultManager] contentsAtPath:comBootPath];
        NSMutableDictionary *bootTemp = (NSMutableDictionary *)[NSPropertyListSerialization
																propertyListFromData:plistBootXML
																mutabilityOption:NSPropertyListMutableContainersAndLeaves
																format:&format errorDescription:&errorDesc];
		self.setSmbioPath = [bootTemp objectForKey:@"SMBIOS"];

		// smbios.plist
		if (setSmbioPath) {
			smbiosFinalPath = [smbiosRealPath stringByAppendingPathComponent: setSmbioPath ];
		}
		else {
			smbiosFinalPath = chameleonSmbiosPath;
		}
		
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:smbiosFinalPath];
		NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
											  propertyListFromData:plistXML
											  mutabilityOption:NSPropertyListMutableContainersAndLeaves
											  format:&format errorDescription:&errorDesc];
		
		self.SMfamily = [temp objectForKey:@"SMfamily"];
		self.SMbiosversion = [temp objectForKey:@"SMbiosversion"];
		self.SMmanufacter = [temp objectForKey:@"SMmanufacter"];
		self.SMproductname = [temp objectForKey:@"SMproductname"];
		self.SMsystemversion = [temp objectForKey:@"SMsystemversion"];
		self.SMserial = [temp objectForKey:@"SMserial"];
		self.SMexternalclock = [temp objectForKey:@"SMexternalclock"];
		self.SMmaximalclock = [temp objectForKey:@"SMmaximalclock"];
		self.SMmemtype = [temp objectForKey:SMmemKey];
		self.SMmemspeed = [temp objectForKey:@"SMmemspeed"];
		self.SMbiosDate = [temp objectForKey:@"SMbiosdate"];
		self.SMcputype = [temp objectForKey:SMcpuKey];
		
		//self.SMuuid = [temp objectForKey:@"SMUUID"];
		self.smbiosData = [NSPropertyListSerialization dataFromPropertyList:temp format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
		
		int i = 0;
		int a = 0;
		int b = 0;
		int c = 0;
		NSString *key;
		NSString *tempMe;
		NSString *SMSer;
		NSString *SMPart;
		NSMutableArray *manArray = [[NSMutableArray alloc]init];
		NSMutableArray *serArray = [[NSMutableArray alloc]init];
		NSMutableArray *partArray = [[NSMutableArray alloc]init];
		NSMutableArray *bankArray = [[NSMutableArray alloc]init];
		
		//scan la memoire et ajoute les valeurs dans le tableau
		for (key in temp) {
			if ([temp valueForKey:[UserMen stringByAppendingFormat:@"%d",i]]) {
				tempMe = [temp valueForKey:[UserMen stringByAppendingFormat:@"%d",i]];
				if (tempMe) {
					[manArray insertObject:tempMe atIndex:a];
					[bankArray insertObject:[NSString stringWithFormat:@"%d",i] atIndex:a]; //manufacter comme referent
					a++;
				}
			}
			if ([temp valueForKey:[UserSerial stringByAppendingFormat:@"%d",i]]) {
				SMSer = [temp valueForKey:[UserSerial stringByAppendingFormat:@"%d",i]];
				if (SMSer) {
					[serArray insertObject:SMSer atIndex:b];
					b++;
				}
			}
			if ([temp valueForKey:[UserPart stringByAppendingFormat:@"%d",i]]) {
				SMPart = [temp valueForKey:[UserPart stringByAppendingFormat:@"%d",i]];
				if (SMPart) {
					[partArray insertObject:SMPart atIndex:c];
					c++;
				}
			}
			i++;
		}

	//construire le dico en memoire
		self.smOne = [NSMutableArray arrayWithArray:bankArray];
		self.smTwo = [NSMutableArray arrayWithArray:manArray];
		self.smThree = [NSMutableArray arrayWithArray:serArray];
		self.smFour = [NSMutableArray arrayWithArray:partArray];
			
		self.theDico = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:smOne, smTwo, smThree, smFour, nil]
						forKeys:[NSArray arrayWithObjects:UserBank, UserMen, UserSerial, UserPart, nil]];
	}
    return self;
}

// début ecriture smbios.plist
- (IBAction)saveSMBIOS:(id)sender {
	//reinitialise le message  "defaut" pour la memoire/cpuType
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SMmemdefault"];
	[SMmemtypeConv setTextColor:[NSColor blackColor]];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SMcpudefault"];
	[SMcputypeConv setTextColor:[NSColor blackColor]];
	
	//backup du fichier
	NSError *errorFile = nil;
	NSString *showBackupPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Backup Folder"];
	
	//parcourir les champs après creation du plist
	[saveGood setImage: nil];
	[testMe selectText:sender];
	
	//definition du dossier Extra
	NSString *showExtraPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"Extra Folder"];
	NSString *chameleonSmbiosPath = [showExtraPath stringByAppendingPathComponent:sSmbiosPath];
	
	//task pour authopen
	NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *writeHandle = [pipe fileHandleForWriting];
	
	// sauvegarde les champs selectionnnés
	
	//restaurer l'image après le dernier fade
	[saveGood setImage: nil];
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0];
	[[saveGood animator] setAlphaValue:1];
	[NSAnimationContext endGrouping];
	
	// pas de tableau, sinon nil empèche la sauvegarde	
	NSMutableDictionary *smbiosDict = [NSMutableDictionary dictionary];
	
	//chemin smbios relatif a la partition
	NSString *smbiosFinalPath;
	NSString *smbiosRealPath = [showExtraPath stringByDeletingLastPathComponent];
	NSFileManager *theManager = [NSFileManager defaultManager];
	
	if (setSmbioPath) {
		smbiosFinalPath = [smbiosRealPath stringByAppendingPathComponent: setSmbioPath ];
	}
	else {
		smbiosFinalPath = chameleonSmbiosPath;
	}
	
	if (SMfamily)
		[smbiosDict setObject:SMfamily forKey:@"SMfamily"];		
	if (SMbiosversion)
		[smbiosDict setObject:SMbiosversion forKey:@"SMbiosversion"];		
	if (SMmanufacter)
		[smbiosDict setObject:SMmanufacter forKey:@"SMmanufacter"];		
	if (SMproductname)
		[smbiosDict setObject:SMproductname forKey:@"SMproductname"];		
	if (SMsystemversion)
		[smbiosDict setObject:SMsystemversion forKey:@"SMsystemversion"];		
	if (SMserial)
		[smbiosDict setObject:SMserial forKey:@"SMserial"];		
	if (SMmaximalclock)
		[smbiosDict setObject:SMmaximalclock forKey:@"SMmaximalclock"];		
	if (SMexternalclock)
		[smbiosDict setObject:SMexternalclock forKey:@"SMexternalclock"];
	if (SMmemspeed)
		[smbiosDict setObject:SMmemspeed forKey:@"SMmemspeed"];		
	if (SMbiosDate)
		[smbiosDict setObject:SMbiosDate forKey:@"SMbiosdate"];	
	if (SMmemtype) {
		if ([SMmemtype isEqualToString:DDR] || [SMmemtype isEqualToString:@"18"]) {
				[smbiosDict setObject:@"18" forKey:SMmemKey];
		}
		else if ([SMmemtype isEqualToString:DDR2] || [SMmemtype isEqualToString:@"19"]) {
				[smbiosDict setObject:@"19" forKey:SMmemKey];
		}
		else if ([SMmemtype isEqualToString:FBDIMM] || [SMmemtype isEqualToString:@"20"]) {
				[smbiosDict setObject:@"20" forKey:SMmemKey];
		}
		else if ([SMmemtype isEqualToString:DDR3] || [SMmemtype isEqualToString:@"24"]) {
				[smbiosDict setObject:@"24" forKey:SMmemKey];
		}
		else	{
				[smbiosDict setObject:@"19" forKey:SMmemKey];
				[[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"SMmemdefault"];  // memoire par defaut enregistré dans les prefs pour message au lancement
				[SMmemtypeConv setStringValue:memDefault];// affiche la valeur par defaut
				[SMmemtypeConv setTextColor:[NSColor redColor]];// attire l'attention
					NSLog(@"Misconfiguration with memory type");
		}
	}
	if (SMcputype) {
		if ([SMcputype isEqualToString:coreSolo] || [SMcputype isEqualToString:@"257"]) {
				[smbiosDict setObject:@"257" forKey:SMcpuKey];
		}
		else if ([SMcputype isEqualToString:coreTwo] || [SMcputype isEqualToString:@"769"]) {
				[smbiosDict setObject:@"769" forKey:SMcpuKey];
		}
		else if ([SMcputype isEqualToString:coreXeon] || [SMcputype isEqualToString:@"1281"]) {
				[smbiosDict setObject:@"1281" forKey:SMcpuKey];
		}
		else if ([SMcputype isEqualToString:iCore5] || [SMcputype isEqualToString:@"1537"]) {
			[smbiosDict setObject:@"1537" forKey:SMcpuKey];
		}
		else {
				[smbiosDict setObject:@"257" forKey:SMcpuKey];
				[[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"SMcpudefault"];  // memoire par defaut enregistré dans les prefs pour message au lancement
				[SMcputypeConv setStringValue:cpuDefault];// affiche la valeur par defaut
				[SMcputypeConv setTextColor:[NSColor redColor]];// attire l'attention
					NSLog(@"Misconfiguration with cpu type");
		}
	}
	//if (SMuuid)
	//[smbiosDict setObject:SMuuid forKey:@"SMUUID"];		
	
	// enregistrement des infos memoire
	int i = 0;
	for ( NSString *ramEntry in self.smOne)
	{
		[smbiosDict setObject:[self.smTwo objectAtIndex:i] forKey:[NSString stringWithFormat:@"%@%@", UserMen,ramEntry]];
		[smbiosDict setObject:[self.smThree objectAtIndex:i] forKey:[NSString stringWithFormat:@"%@%@", UserSerial,ramEntry]];
		[smbiosDict setObject:[self.smFour objectAtIndex:i] forKey:[NSString stringWithFormat:@"%@%@", UserPart,ramEntry]];		
		i++;
	}

	
	self.smbiosData = [NSPropertyListSerialization dataFromPropertyList:smbiosDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
	// declaration des alertes
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSWarningAlertStyle];
	
	if ([theManager fileExistsAtPath:smbiosFinalPath]) {
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
				if ([createBackPath stringByAppendingPathComponent:sSmbiosPath]) {
					//affiche Date 
					NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
					[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
					[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
					NSDictionary *theFileAttributes = [theManager fileAttributesAtPath:createBackPath traverseLink:NO];
					NSString *dateStr = [dateFormatter stringFromDate:[theFileAttributes objectForKey:NSFileModificationDate]];
					NSString *theDate = [dateStr stringByAppendingString:@"."];
					[theManager copyItemAtPath:[createBackPath stringByAppendingPathComponent:sSmbiosPath] toPath:[createBackPath stringByAppendingPathComponent:[theDate stringByAppendingString:sSmbiosPath]] error:&errorFile];
				}
			}
			else { 
				createBackPath = showBackupPath; 
			}
			[theManager copyItemAtPath:smbiosFinalPath toPath:[createBackPath stringByAppendingPathComponent:[smbiosFinalPath lastPathComponent]] error:&errorFile];
		}
		
		if (![theManager isWritableFileAtPath:smbiosFinalPath]) {
			
			//utilisation de authopen pour élever les permissions via un pipe
			[task setLaunchPath:@"/usr/libexec/authopen"];
			[task setArguments:[NSArray arrayWithObjects:@"-c", @"-w", smbiosFinalPath, nil]];
			[task setStandardInput:pipe];
			[writeHandle writeData:smbiosData];
			[task launch];
			close([writeHandle fileDescriptor]);//fermuture manuelle
			[task waitUntilExit]; //pour que l'icone s'affiche au bon moment
			[task release];
		}
		
		//les autorisations sont déjà bonne
		else if ([theManager isWritableFileAtPath:smbiosFinalPath]) {
			[smbiosData writeToFile:smbiosFinalPath atomically:NO]; //NO sinon ne fonctionne pas depuis authopen
		}
		
		//chargement de l'image
		NSString *acceptPath = [[NSBundle mainBundle] pathForResource:@"accept" ofType:@"png"];
		NSImage *saveGoodIcon = [[NSImage alloc] initWithContentsOfFile:acceptPath];
		[saveGood setImage: saveGoodIcon];
		
		//fade out
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:1.0];
		[[saveGood animator] setAlphaValue:0];
		[NSAnimationContext endGrouping];
		NSLog(@"smbios.plist updated succesfully");
		}
		else if (![theManager fileExistsAtPath:smbiosFinalPath]){
		[alert setMessageText:@"smbios.plist not Found"];
		[alert addButtonWithTitle:@"Generate new"];
		[alert addButtonWithTitle:@"Cancel"];
        [alert setInformativeText:@"Press 'Generate new' to create a new smbios.plist (from the com.apple.Boot.plist target or by defaut in Extra folder) then press save if you entered datas"];
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
		}	
}
//Gestion du tableau memoire
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.smOne count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
	
	if ([[pTableColumn identifier] isEqualToString:@"smBank"]) {
		return [smOne objectAtIndex:pRowIndex];
	}
	if ([[pTableColumn identifier] isEqualToString:UserMen]) {
		return [smTwo objectAtIndex:pRowIndex];
	}
	if ([[pTableColumn identifier] isEqualToString:UserSerial]) {
		return [smThree objectAtIndex:pRowIndex];
	}
	if ([[pTableColumn identifier] isEqualToString:UserPart]) {
		return [smFour objectAtIndex:pRowIndex];
	}
	return NULL;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)pObject forTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
}

- (IBAction)bindSelection:(id)sender {
	int selectedView = [tableView selectedRow];
	[ramBank setStringValue:[self.smOne objectAtIndex:selectedView]];
	[ramManufacter setStringValue:[self.smTwo objectAtIndex:selectedView]];
	[ramSerial setStringValue:[self.smThree objectAtIndex:selectedView]];
	[ramPart setStringValue:[self.smFour objectAtIndex:selectedView]];
}
- (IBAction)addRow:(id)sender
{
	if ([[ramBank stringValue]isEqualToString:@"" ]) {
		[smOne addObject:@"1"];	
	}
	else {
		[smOne addObject:[ramBank stringValue]];
	}
	[smTwo addObject:[ramManufacter stringValue]];
	[smThree addObject:[ramSerial stringValue]];
	[smFour addObject:[ramPart stringValue]];
	[tableView reloadData];
}
- (IBAction)insertRow:(id)sender
{	
	int selectedView = [tableView selectedRow];
	[smOne removeObjectAtIndex:selectedView];
	[smThree removeObjectAtIndex:selectedView];
	[smFour removeObjectAtIndex:selectedView];
	[smTwo removeObjectAtIndex:selectedView];
	
	if ([[ramBank stringValue]isEqualToString:@"" ]) {
		[smOne insertObject:@"1" atIndex:selectedView];
	}
	else {
		[smOne insertObject:[ramBank stringValue] atIndex:selectedView];
	}
	[smTwo insertObject:[ramManufacter stringValue] atIndex:selectedView];
	[smThree insertObject:[ramSerial stringValue] atIndex:selectedView];
	[smFour insertObject:[ramPart stringValue] atIndex:selectedView];

	[tableView reloadData];
}

- (IBAction)removeRow:(id)sender
	{
		int selectedView = [tableView selectedRow];
		if ([tableView selectedRow] > -1) {
			[smOne removeObjectAtIndex:selectedView];
			[smThree removeObjectAtIndex:selectedView];
			[smFour removeObjectAtIndex:selectedView];
			[smTwo removeObjectAtIndex:selectedView];
			[tableView reloadData];
		}
}

//synchro des selections dans les modeles
- (IBAction) synchronizeModel:(id)sender {
	[SMproductnameUpdate selectItemAtIndex:[SMfamilyUpdate indexOfSelectedItem]];
	[SMbiosversionUpdate selectItemAtIndex:[SMfamilyUpdate indexOfSelectedItem]];
	self.SMbiosversion = [SMbiosversionUpdate stringValue];
	self.SMproductname = [SMproductnameUpdate stringValue];
	self.SMfamily = [SMfamilyUpdate stringValue];
}
- (IBAction) synchronizeProduct:(id)sender {
	[SMfamilyUpdate selectItemAtIndex:[SMproductnameUpdate indexOfSelectedItem]];
	[SMbiosversionUpdate selectItemAtIndex:[SMproductnameUpdate indexOfSelectedItem]];
	self.SMbiosversion = [SMbiosversionUpdate stringValue];
	self.SMproductname = [SMproductnameUpdate stringValue];
	self.SMfamily = [SMfamilyUpdate stringValue];
}
- (IBAction) synchronizeRom:(id)sender {
	[SMproductnameUpdate selectItemAtIndex:[SMbiosversionUpdate indexOfSelectedItem]];
	[SMfamilyUpdate selectItemAtIndex:[SMbiosversionUpdate indexOfSelectedItem]];
	self.SMbiosversion = [SMbiosversionUpdate stringValue];
	self.SMproductname = [SMproductnameUpdate stringValue];
	self.SMfamily = [SMfamilyUpdate stringValue];
}
// appel preview
- (IBAction)smPreview:(id)sender {
	if (![smWindow isVisible]) {
		[smWindow makeKeyAndOrderFront:self];
	}
	else {
		[smWindow orderOut:nil];
	}
}

//Serial Builder
- (IBAction)randomUnit:(id)sender {
    self.snUnit = [NSNumber numberWithInt:100 + rand()%899];
	[self updateSerial];
}
- (IBAction)randomWeek:(id)sender {
    self.snWeek = [NSNumber numberWithInt:1 + rand()%51];
	[self updateSerial];
}
- (IBAction)randomYear:(id)sender {
    self.snYear = [NSNumber numberWithInt: 5 + [snCombYear indexOfSelectedItem]];
	[self updateSerial];
}
- (IBAction)randomCountry:(id)sender {
	int realCountry = [snCombCountry indexOfSelectedItem];
	
	if (realCountry == 0)
		self.snCountry = @"W8";
	else if (realCountry == 1)
		self.snCountry = @"CK";
	else if (realCountry == 2)
		self.snCountry = @"G8";
	else if (realCountry == 3)
		self.snCountry = @"V7";
	else if (realCountry == 4)
		self.snCountry = @"CY";
	else if (realCountry == 5)
		self.snCountry = @"RN";
	else if (realCountry == 6) {
		self.snCountry = @"RM";
	}
	[self updateSerial];
}

- (IBAction)randomModel:(id)sender {
	int realModel = [snCombModel indexOfSelectedItem];
	
	if (realModel == 0)
		self.snModel = @"0P1";
	else if (realModel == 1)
		self.snModel = @"66D";
	else if (realModel == 2)
		self.snModel = @"1G0";
	else if (realModel == 3)
		self.snModel = @"W87";
	else if (realModel == 4) {
		self.snModel = @"XYL";
	}
	[self updateSerial];
}

// mise à jour du champ
- (void) updateSerial {
	
	NSNumber *emptyNum = [NSNumber numberWithInt:00];
	NSString *emptyStg = @"00";
	
	if (!snCountry)
		snCountry = emptyStg;
	if (!snYear)
		snYear = emptyNum;
	if (!snWeek)
		snWeek = emptyNum;
	if (!snUnit)
		snUnit = emptyNum;
	if (!snModel) {
		snModel = emptyStg;
	}
	self.SMserial = [NSString stringWithFormat:@"%@%@%@%@%@", snCountry, snYear, snWeek, snUnit, snModel];
}

// appel serial builder
- (IBAction)sBuilder:(id)sender {
	if (![sbWindow isVisible]) {
		[sbWindow makeKeyAndOrderFront:self];
	}
	else {
		[sbWindow orderOut:nil];
	}
}
@end
