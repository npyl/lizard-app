//
//  SmbiosController.h
//  Lizard
//
//  Created by ronan on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SmbiosController : NSObject {
	IBOutlet NSView *mainWindow;
	IBOutlet NSTextField *testMe;
	
	//chemin du smbios
	NSString *setSmbioPath;
	IBOutlet NSPathControl *displaySmbiosPath;
	
	//conversion memoire au lancement
	IBOutlet id SMmemtypeConv;
	IBOutlet id SMcputypeConv;
	
	// indicateur pour un chemin alternatif
	IBOutlet id imageStatus;
	IBOutlet id smbioPathError;
	IBOutlet id smbioIconhError;
	
	IBOutlet NSWindow *smWindow;
	NSData *smbiosData;
	
	//recreation du plist
	IBOutlet NSComboBox *SMfamilyUpdate;
	IBOutlet NSComboBox *SMproductnameUpdate;
	IBOutlet id SMsystemversionUpdate;
	IBOutlet id SMserialUpdate;
	IBOutlet id SMmanufacterUpdate;
	IBOutlet NSComboBox *SMbiosversionUpdate;
	
	//confirmation de sauvegarde
	IBOutlet id saveGood;
	
	// Nombre de clés pour les slots de ram
	NSMutableArray *smOne;
	NSMutableArray *smTwo;
	NSMutableArray *smThree;
	NSMutableArray *smFour;
	NSDictionary *theDico;
	
	IBOutlet NSTableView *tableView;
	
	//les champs connectés aux colones
	IBOutlet id ramBank;
    IBOutlet id ramManufacter;
    IBOutlet id ramSerial;
    IBOutlet id ramPart;
	
	//smbios.plsi controllers
	NSString *SMfamily;
	NSString *SMbiosversion;
	NSString *SMmanufacter;
	NSString *SMproductname;
	NSString *SMsystemversion;
	NSString *SMserial;
	NSString *SMexternalclock;
	NSString *SMmaximalclock;
	NSString *SMmemtype;
	NSString *SMmemspeed;
	NSString *SMbiosDate;
	NSString *SMcputype;
	//NSString *SMuuid;
}
@property (copy, nonatomic) NSString *SMfamily;
@property (copy, nonatomic) NSString *SMbiosversion;
@property (copy, nonatomic) NSString *SMmanufacter;
@property (copy, nonatomic) NSString *SMproductname;
@property (copy, nonatomic) NSString *SMsystemversion;
@property (copy, nonatomic) NSString *SMserial;
@property (copy, nonatomic) NSString *SMexternalclock;
@property (copy, nonatomic) NSString *SMmaximalclock;
@property (copy, nonatomic) NSString *SMmemtype;
@property (copy, nonatomic) NSString *SMmemspeed;
@property (copy, nonatomic) NSString *SMbiosDate;
@property (copy, nonatomic) NSString *SMcputype;

//@property (copy, nonatomic) NSString *SMuuid;
@property (copy, nonatomic) NSString *setSmbioPath;

@property (retain, nonatomic) NSData *smbiosData;

- (IBAction)saveSMBIOS:(id)sender;
- (IBAction)bindSelection:(id)sender;

NSString *sSystemeBootPath = @"/Library/Preferences/SystemConfiguration/com.apple.Boot.plist";
NSString *sBootPath = @"com.apple.Boot.plist";
NSString *sSmbiosPath = @"smbios.plist";
NSString *errorDesc;

// memoire smbios
NSString *DDR = @"DDR";
NSString *DDR2 = @"DDR2";
NSString *DDR3 = @"DDR3";
NSString *FBDIMM = @"FBDIMM";
NSString *memDefault = @"DDR2 (Default)";
NSString *SMmemKey = @"SMmemtype";

// cpu type
NSString *coreSolo = @"Intel Core Solo";
NSString *coreTwo = @"Intel Core 2 Duo";
NSString *coreXeon = @"Quad-Core Intel Xeon";
NSString *cpuDefault = @"Intel Core 2 Duo (Default)";
NSString *SMcpuKey = @"SMcputype";


// clés mémoire
NSString *UserMen = @"SMmemmanufacter_";
NSString *UserSerial = @"SMmemserial_";
NSString *UserPart = @"SMmempart_";
NSString *UserBank = @"ramBank";

// Gestion memoire
- (IBAction)addRow:(id)sender;
- (IBAction)insertRow:(id)sender;
- (IBAction)removeRow:(id)sender;
- (IBAction) synchronizeModel:(id)sender;
- (IBAction) synchronizeProduct:(id)sender;
- (IBAction) synchronizeRom:(id)sender;

- (IBAction)smPreview:(id)sender;

@property (retain, nonatomic) NSMutableArray *smOne;
@property (retain, nonatomic) NSMutableArray *smTwo;
@property (retain, nonatomic) NSMutableArray *smThree;
@property (retain, nonatomic) NSMutableArray *smFour;
@property (retain, nonatomic) NSDictionary *theDico;

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex;
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)pObject forTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex;
@end
